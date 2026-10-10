# Regras de formatação ATS e validação obrigatória

## Formato e estrutura

- **Saída:** código LaTeX compilável, gerando PDF pesquisável (texto
  selecionável).
- **Proibido:** headers, footers, tabelas, colunas, linhas decorativas,
  sombreamento, cores de fonte diferentes de preto, ícones, símbolos além do
  bullet simples, texto escondido/branco.
- **Fonte:** preta, tamanho 10pt, sem serifas exageradas (`lmodern`).
- **Seções padronizadas** (ou equivalentes em inglês), sempre nesta ordem e
  sem seção extra: Resumo Profissional, Experiência Profissional,
  Competências Técnicas, Formação Acadêmica, Certificações, Idiomas. É a
  estrutura obrigatória do `template.tex`.
- **Contato no corpo do documento**, nunca em header/footer.
- **Datas:** sempre `MM/AAAA` ou `Mês/AAAA` (ex.: `11/2025 -- Presente`),
  consistentes no documento inteiro. Evite datas por extenso sem numeral.
- **Cargos e empresas:** em linhas distintas e facilmente parseáveis; evite
  blocos de texto corrido.
- **Bullets:** apenas `\item` simples, sem sub-bullets complexos.
- **Keyword matching:** insira as keywords da vaga naturalmente, sobretudo em
  Resumo, Experiência e Competências. Use forma extensa + sigla quando
  relevante (ex.: "Retrieval-Augmented Generation (RAG)"). Não abrevie a
  menos que a própria vaga abrevie. Evite clichês não mensuráveis
  ("proativo", "dinâmico", "team player").
- **Margens:** ~1,8 cm. **Espaçamento:** simples, `\parskip` pequeno.
- **Modelo base:** `template.tex` deste diretório, sem alterar a estrutura —
  só as seções de conteúdo.

## Regras de conteúdo

- **Veracidade absoluta:** nenhum fato inventado; tudo vem de
  `candidato.md` ou de confirmação explícita do usuário na conversa.
- **Quantifique:** prefira bullets com números — percentuais, tempo
  economizado, custo reduzido, clientes atendidos, tokens, produtos,
  usuários.
- **Primeira pessoa no documento inteiro**, inclusive no Resumo
  Profissional ("Sou", "Construo", "Desenvolvo"); nunca terceira pessoa
  ("constrói", "desenvolve", "atua").
- **Verbos de ação** no início de cada bullet (Desenvolvi, Arquitetei,
  Reduzi, Otimizei, Liderei, Padronizei, Integrei...).
- **Foco em resultado mensurável**, não em tarefa executada.
- **Densidade de keywords:** maior no Resumo Profissional; nas Experiências,
  keywords em contexto de uso real.
- **Evite genéricos:** toda skill listada deve ser verificável; toda soft
  skill deve vir demonstrada por uma conquista, não afirmada.

## Validação ATS obrigatória (nunca pule esta etapa)

Depois de gerar o `.tex` e **antes** de compilar o PDF final, rode esta
validação cruzada por completo:

1. **Checklist de keywords** — liste as hard skills, títulos de cargo e
   tecnologias de destaque da vaga; marque quais aparecem no currículo e em
   qual seção. Todas as relevantes devem estar presentes.
2. **Checklist de estrutura ATS:**
   - [ ] Sem header, footer, tabela, coluna, linha decorativa, sombreamento,
     cor de fonte diferente de preto, ícone ou símbolo além de bullet.
   - [ ] Contato no corpo do documento.
   - [ ] Seções com nomes padronizados.
   - [ ] Datas em `MM/AAAA` ou `Mês/AAAA`, consistentes.
   - [ ] Cargos, empresas e datas em linhas distintas e parseáveis.
   - [ ] PDF pesquisável (LaTeX compilável).
3. **Checklist de conteúdo:**
   - [ ] Todos os fatos vêm da base de conhecimento real.
   - [ ] Resumo com 3–4 linhas e alta densidade de keywords.
   - [ ] Bullets em Contexto → Ação → Resultado (CAR).
   - [ ] Resultados quantificados sempre que possível.
   - [ ] Verbos de ação no início dos bullets.
   - [ ] Primeira pessoa no documento inteiro, inclusive no Resumo.
   - [ ] Sem clichês genéricos sem comprovação.
4. **Scoring estimado (0–100):**
   - 50% overlap de hard skills/tecnologias exigidas.
   - 25% alinhamento de responsabilidades e senioridade.
   - 15% estrutura ATS (formato, parseabilidade, seções).
   - 10% quantificação e impacto.
   - **Nota < 85 → revise e reescreva antes de avançar.** Não compile/entregue
     nesse estado.
5. Só gere/copie o PDF final depois que a validação estiver aprovada.
