# pdf_contact_editor — substituição determinística de E-MAIL e TELEFONE em PDF

## Context

Você precisa trocar dois campos (`ENDEREÇO ELETRÔNICO` e `TELEFONE`) em comprovantes de CNPJ da Receita Federal — o caso concreto é o cartão CNPJ do CARTAO DE TODOS FORMIGA LTDA. Hoje isso é refeito à mão. A solução tem que ser determinística (sem IA interpretando o documento), preservar o layout pixel a pixel e nunca tocar no arquivo original.

**Resultado esperado:** um projeto Python que recebe um PDF, localiza os dois valores pelos rótulos, pede os novos valores, remove o texto antigo de verdade (redaction) e escreve o novo na mesma baseline, gerando `<nome>_atualizado.pdf` — com validação antes e depois.

---

## Análise técnica do PDF de referência

PDF analisado: `C:\Users\Administrator\Downloads\download.pdf` (1 página, A4 `594.96 x 841.92`, 1 imagem/logo, 102 vetores). Ele é o comprovante que você citou no exemplo.

### Como o texto está estruturado

Cada campo é **um bloco próprio**, com o rótulo na `line 0` e o valor na `line 1`:

| | Rótulo (line 0) | Valor (line 1) |
|---|---|---|
| bloco 17 | `ENDEREÇO ELETRÔNICO` — ArialMT 6.0pt | `FORMIGA.MG@CARTAODETODOS.COM` — Arial-BoldMT 7.995pt |
| bloco 18 | `TELEFONE` — ArialMT 6.0pt | `(31) 7133-4683` — Arial-BoldMT 7.995pt |

Dados reais extraídos:

```
email  bbox=(43.89, 375.51, 198.40, 384.44)  origin=(43.89, 382.75)  cor=0x333333
phone  bbox=(286.64, 375.51, 341.32, 384.44) origin=(286.64, 382.75) cor=0x333333
```

### Três achados que definem a implementação

**1. As bordas das células são retângulos preenchidos, não linhas.** A célula do e-mail é exatamente `x ∈ [40.0, 274.0]`, a do telefone `x ∈ [283.0, 507.25]`, ambas `y ∈ [367.75, 388.0]`. Isso dá a **largura disponível exata** para o novo texto, sem chutar.

Consequência crítica: `apply_redactions()` do PyMuPDF, no default, apaga line art tocado pela redação — isso **destruiria as bordas da tabela**. Vou passar explicitamente `graphics=fitz.PDF_REDACT_LINE_ART_NONE` e `images=fitz.PDF_REDACT_IMAGE_NONE`.

**2. A fonte embutida é subset (`AAAAAA+Arial-BoldMT`, Identity-H).** Testei: esse subset específico **contém** os glifos de `novo@email.com` (minúsculas inclusive), então dá para reusar a fonte original e obter saída idêntica. Mas isso é sorte deste documento — outro subset pode não ter. Por isso a estratégia é **tentar a embutida e verificar glifo a glifo**, com fallback.

**3. Base-14 Helvetica-Bold (`hebo`) é metricamente compatível com Arial-Bold** — medido: telefone `54.662` vs real `54.675` (erro 0.01pt); e-mail `155.255` vs real `154.513` (erro 0.5%). É um fallback seguro.

### Estratégia escolhida

**Localização** — âncora por rótulo, em duas camadas:
1. *Primária (estrutural):* varrer blocos; se `line[0]` normalizada (NFKD, sem acento, maiúscula) == rótulo, o valor é `line[1]`.
2. *Fallback (geométrico):* achar o bbox do rótulo e pegar o span mais próximo **abaixo** com sobreposição horizontal, dentro de um limite vertical.

Em ambos, o valor só é aceito se casar com o regex do tipo. Nada é substituído por "parecer um e-mail" solto — a âncora é sempre o rótulo. **Mais de um candidato válido ⇒ erro, com página e coordenadas de cada um, e nenhum PDF gerado.**

**Substituição** — por span, na ordem:
1. `page.add_redact_annot(rect_do_span)` com rect padded só na horizontal e clipado verticalmente para não invadir a linha do rótulo.
2. `page.apply_redactions(images=PDF_REDACT_IMAGE_NONE, graphics=PDF_REDACT_LINE_ART_NONE, text=PDF_REDACT_TEXT_REMOVE)` — remoção real do content stream.
3. `page.insert_text(origin_original, texto_novo, fontname=..., fontsize=ajustado, color=fitz.sRGB_to_pdf(cor_original), render_mode=0)` — **na origin/baseline original**, nunca `insert_textbox` (que reflui).

**Fonte:** `doc.extract_font(xref)` → `fitz.Font(fontbuffer=...)` → `has_glyph()` para **todo** caractere novo. Se passar, insere com `fontbuffer` (saída idêntica). Se faltar qualquer glifo, mapeia o basefont (sem prefixo `AAAAAA+`) para o alias Base-14 correspondente — Arial/Helvetica→`helv`, com bold/italic pelos `flags` do span; Times→`tiro`, Courier→`cour` — e loga o fallback.

**Tamanho:** largura disponível = borda direita da célula (dos `get_drawings()`) − `origin.x` − padding; se a célula não for detectável, cai para o próximo span à direita na mesma faixa vertical. Reduz de `size` original em passos de 0.05pt até caber; **nunca aumenta**. Piso de 4.0pt — se não couber nem no piso, **falha** em vez de estourar a célula.

---

## Arquivos a criar

Raiz: `C:\Users\Administrator\Desktop\pdf_contact_editor\` (fora da vault, conforme sua decisão).

```
pdf_contact_editor/
├── main.py              CLI interativa
├── pdf_editor.py        localizar / medir / redigir / inserir / salvar
├── validators.py        regex e pré-checagens
├── verifier.py          validação pós-processamento
├── requirements.txt     PyMuPDF>=1.24 ; pytest (dev)
├── README.md
├── .gitignore
├── input/               (com download.pdf copiado como exemplo)
├── output/
└── tests/
    ├── conftest.py
    ├── fixtures.py      gera PDFs sintéticos em memória
    ├── test_validators.py
    ├── test_locator.py
    ├── test_replace.py
    └── test_verifier.py
```

### `validators.py`
- `EMAIL_RE` — permissiva mas ancorada: `[\w.+-]+@[\w-]+(\.[\w-]+)+`. Aceita `nome.sobrenome@empresa.com.br`.
- `PHONE_RE` — aceita `(83) 99999-9999`, `(83) 9999-9999`, `83999999999`, `8333333333`; valida por contagem de dígitos (10–11, ou 12–13 com DDI) e não pela pontuação.
- `validate_pdf_path(path)` — existe, é arquivo, extensão `.pdf`, abre no PyMuPDF sem erro, não é criptografado.
- `has_searchable_text(doc)` — soma de texto extraído < limiar (e presença de imagem) ⇒ escaneado. Mensagem exata: `"Este PDF não possui texto pesquisável. É necessário utilizar OCR para processá-lo."`
- `normalize_label(s)` — NFKD + remove acentos + upper + colapsa espaços.

### `pdf_editor.py`
Dataclass `FieldMatch(page_no, label, value, bbox, origin, font, size, flags, color, cell_rect)`.

- `find_field(doc, labels, value_regex)` → lista de `FieldMatch` (estratégia primária + fallback geométrico acima).
- `cell_width_for(page, match)` → usa `get_drawings()` para achar a borda direita da célula; fallback para o próximo span à direita.
- `resolve_font(doc, page, match, new_text)` → `(fontname, fontbuffer|None)` pela regra embedded-first descrita acima.
- `fit_font_size(text, fontname, fontbuffer, max_size, max_width)` → tamanho ajustado ou `None` se não couber no piso.
- `apply_replacements(doc, replacements)` → agrupa por página, adiciona todas as redações, um `apply_redactions()` por página, depois insere os textos.
- `unique_output_path(src)` → `documento_atualizado.pdf`, senão `_1`, `_2`, … (loop até achar livre).
- `save_new(doc, out_path)` → `doc.save(out, garbage=3, deflate=True)` em caminho novo; o original é aberto e nunca salvo por cima.

**Ordem obrigatória:** todas as validações e ambas as localizações acontecem **antes** de qualquer mutação. Se algo falhar, retorna erro e nenhum arquivo é escrito.

### `verifier.py`
`verify(original_path, new_path, old_email, new_email, old_phone, new_phone)` retorna um relatório com:
- contagem de páginas igual;
- `old_email` ausente / `new_email` presente;
- `old_phone` ausente / `new_phone` presente;
- **restante intacto:** multiset de tokens do texto de ambos os PDFs, removidos os 2 valores antigos/novos — os conjuntos têm que bater. Pega qualquer texto perdido por redação acidental.

### `main.py`
Fluxo exatamente na ordem do seu spec: caminho → validações → localizar e **mostrar os valores atuais** → pedir novo e-mail → pedir novo telefone (revalidando input, com repetição em caso de formato inválido) → processar → verificar → imprimir caminho final. Layout do terminal conforme seu exemplo, com `✓` por etapa. Aceita opcionalmente o caminho como `argv[1]`.

### Logging
`logging` em nível INFO para stdout: PDF carregado, nº de páginas, rótulo encontrado + página + bbox, fonte/tamanho resolvidos (e se houve fallback), redação aplicada, resultado da verificação, caminho final. Os valores novos e antigos aparecem porque você pediu ("e-mail encontrado"), mas nada além dos dois campos é logado.

---

## Testes

`tests/fixtures.py` gera PDFs sintéticos com PyMuPDF (rótulo numa linha, valor na de baixo), o que torna a suíte independente de arquivos externos. Casos cobertos, um por item do seu spec:

- e-mail válido/inválido; telefone nos 4 formatos + rejeições;
- PDF inexistente; arquivo não-PDF; PDF corrompido;
- PDF sem texto (só imagem) ⇒ mensagem de OCR;
- rótulo de e-mail ausente ⇒ erro, nenhum output;
- rótulo de telefone ausente ⇒ erro, nenhum output;
- rótulo presente mas valor não casa o regex ⇒ erro;
- **dois candidatos válidos ⇒ erro listando as ocorrências**;
- geração correta: output existe, `verify()` passa em todos os itens;
- **original intacto:** hash SHA-256 do arquivo de entrada antes e depois é idêntico;
- colisão de nome: gera `_1`, depois `_2`;
- texto novo mais longo que a célula ⇒ fonte reduzida e largura final ≤ largura disponível;
- texto absurdamente longo ⇒ falha limpa, sem output.

---

## Verificação end-to-end

```powershell
cd C:\Users\Administrator\Desktop\pdf_contact_editor
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
pytest -q
python main.py input\download.pdf
```

Entrada de teste: `novo@email.com` / `(83) 99999-9999`. Depois do run eu vou:
1. conferir o relatório do `verifier` (todos os itens ✓);
2. reextrair o texto do PDF gerado e confirmar que só as duas linhas mudaram;
3. renderizar original e gerado em PNG (`page.get_pixmap`) e comparar as duas imagens, para provar que logo, bordas, rodapé e demais campos ficaram idênticos — e te mostrar o resultado.

O `download.pdf` original em `Downloads` não é tocado; ele é **copiado** para `input/`.

---

## Fora de escopo (explícito)

Sem OCR nesta versão. Sem alteração de CNPJ, razão social, endereço, datas ou situação cadastral. Nenhuma GUI. Nenhuma nota na vault por enquanto — quando existir repo, entra só o ponteiro.

**Forma de entrega:** aplicação Python de terminal, standalone. Roda com `python main.py` na máquina do CAUE, offline, sem chamada de IA e sem depender do Claude. Eu posso executá-la aqui quando ele pedir, mas isso é conveniência, não requisito.

**Analisador de saúde de CNPJ — projeto separado, adiado (decidido em 2026-09-09).** Ideia: agente que lê o comprovante e aponta divergências. Baseline definida por ele: **comparar o PDF com o que a Receita mostra hoje** (fonte online tipo BrasilAPI / ReceitaWS / CNPJá), campo a campo. Não entra neste projeto — o editor escreve no PDF, o analisador lê e opina; são produtos diferentes. Só começa depois que o editor estiver fechado e testado com PDF real.
