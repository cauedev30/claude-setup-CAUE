---
name: curriculo-camaleao
description: Use quando o usuário pedir para gerar, adaptar, reescrever ou otimizar um currículo/CV para uma vaga específica, pedir um currículo em LaTeX otimizado para ATS, mencionar "currículo camaleão", ou quiser atualizar a base de conhecimento do candidato (novo emprego, skill, certificação, correção de dado).
---

# Currículo Camaleão

Gera um currículo em LaTeX **totalmente adaptado a uma vaga específica**, a
partir de uma base de conhecimento fixa e verídica do candidato — sem nunca
inventar fatos — e só entrega depois de passar por uma validação ATS
obrigatória.

## Arquivos desta skill

- `references/candidato.md` — base de conhecimento fixa do candidato (Daniel
  Vieira). Fonte única de verdade. Edite este arquivo quando o usuário
  informar um emprego, skill ou certificação nova, ou corrigir um dado —
  nunca guarde esse tipo de atualização só na conversa.
- `references/template.tex` — preâmbulo e esqueleto LaTeX compatível com ATS.
  Use sem alterar a estrutura; preencha só as seções de conteúdo.
- `references/regras-ats.md` — regras de formatação ATS e o checklist de
  validação obrigatório (seção final).

## Missão (inegociável)

Para cada vaga, apresente o candidato como a contratação ideal **dentro dos
limites da verdade**: maximize a densidade de keywords relevantes, posicione
cada experiência real na interseção máxima com os requisitos da vaga,
reescreva bullets para evidenciar o que a vaga procura — mesmo que já exista
no perfil sob outro nome — e priorize as entregas mais próximas do cargo.

**Reestruturar, reordenar, reenquadrar e dar ênfase: sim. Inventar: não.**
Nunca invente empregos em outras empresas, experiências freelance,
certificações, formações ou resultados. Na experiência autônoma, use *só*
tecnologias e atribuições já comprovadas em outro lugar da base — se a vaga
pede uma tecnologia que não existe em nenhum lugar do perfil real, omita ou
trate como "familiaridade em estudo" quando plausível; nunca como experiência
profissional consolidada. Isso vale mesmo sob pressão de "essa vaga é
perfeita, só falta essa uma tecnologia" — a resposta continua sendo omitir ou
sinalizar como familiaridade, não inventar.

## Inputs necessários

Antes de gerar, confirme que você tem:

1. **Descrição completa da vaga** — título, responsabilidades, requisitos
   obrigatórios e desejáveis, stack, senioridade, formato de trabalho,
   salário (se houver).
2. **Info da empresa** — ramo, produto/serviço, cultura, stack conhecida,
   porte, diferenciais.

Se faltar algo relevante para o direcionamento, pergunte antes de gerar —
gerar sem isso produz um currículo genérico, o oposto do objetivo da skill.

## Pipeline

### 1. Analisar a vaga
Extraia: hard skills (linguagens, frameworks, bancos, cloud, ferramentas),
variantes do título do cargo, responsabilidades centrais, keywords em
destaque, 2–3 soft skills realmente exigidas, nível de senioridade, idioma da
contratação.

### 2. Definir a estratégia de alinhamento
- **Título no topo:** escolha uma variação do cargo que encaixe vaga +
  experiência real (ex.: "Engenheiro de IA Aplicada", "Desenvolvedor Full
  Stack").
- **Resumo profissional:** 3–4 linhas densas em keywords, com stack principal
  e valor mensurável.
- **Experiências:** mantenha todas as reais; reescreva bullets em
  Contexto → Ação → Resultado (CAR); reordene o bullet mais alinhado para
  primeiro; troque termos genéricos pelos termos exatos da vaga quando fizer
  sentido (ex.: "vector database" → cite "Pinecone" junto com "banco
  vetorial"); em vagas mais sênior, puxe liderança técnica/arquitetura/escala,
  em vagas mais hands-on, puxe entrega/integração/stack.
- **Experiência autônoma como complemento estratégico:** se uma tecnologia da
  vaga não aparece nas experiências Smartspace/Inteligentte/Quinze, verifique
  se faz sentido nos projetos independentes — só adicione se já existir na
  base real.
- **Competências técnicas:** só o que está na vaga ou é justificável pela
  experiência real; agrupe por categorias compatíveis com a vaga.
- **Formação/certificações:** mantenha as reais, reordene priorizando o que é
  mais próximo da vaga.

### 3. Redigir o `.tex`
Preencha `references/template.tex` sem alterar o preâmbulo/estrutura. Siga
as regras de formatação e conteúdo em `references/regras-ats.md`.

### 4. Validar (obrigatório, nunca pule)
Rode o checklist completo da seção "Validação ATS obrigatória" de
`references/regras-ats.md`: keywords, estrutura ATS, conteúdo, e score
estimado 0–100. **Score < 85 → revise e reescreva antes de avançar.**

### 5. Entregar em 3 etapas

**Etapa 1 — Geração**, nesta ordem:
1. Análise rápida da vaga (2–4 bullets): keywords principais, cargo-alvo,
   senioridade, idioma escolhido.
2. Escolhas estratégicas (3–5 bullets): o que foi adaptado.
3. Código LaTeX completo.

**Etapa 2 — Validação:** mostre os três checklists preenchidos, o score
estimado com justificativa, e as correções feitas após a validação (se
houve).

**Etapa 3 — Entrega final (PDF, não o `.tex` cru):**
1. Salve o `.tex` em `~/Documents/curriculo-camaleao-build/` com nome
   `Daniel_Vieira_<Empresa>_<Cargo>.tex`.
2. Compile com `pdflatex` (TeX Live; se não existir: no Mac, `brew install
   --cask basictex`; no Fedora, `sudo dnf install texlive-scheme-medium`). Instale packages sob demanda;
   rode duas vezes para resolver referências.
   **No Windows (máquina do Cauê):** MiKTeX 25.12 já instalado (escopo
   usuário, 08/10/2026) com instalação automática de pacotes ligada
   (`[MPM]AutoInstall=1`). Se `pdflatex` não for achado no PATH da sessão,
   use o caminho completo
   `"$LOCALAPPDATA/Programs/MiKTeX/miktex/bin/x64/pdflatex.exe"`. Rode com
   `-interaction=nonstopmode`. O aviso "security risk: running with elevated
   privileges" é inofensivo.
3. Copie o PDF resultante para `~/Downloads/` com o mesmo nome base.
4. Entregue: caminho do PDF, "Validação ATS aprovada" + nota estimada, e um
   alerta se a nota ficou abaixo de 85 (com a lista dos gaps reais — o
   usuário decide se envia assim mesmo).
5. Mencione `.docx` como alternativa só se a plataforma for Workday ou outro
   ATS legado.

Por padrão, o código LaTeX só aparece no chat na Etapa 1/2 se o usuário pedir
para revisar; do contrário, trabalhe o `.tex` direto no arquivo e mostre só
validação + entrega.

## Idioma do currículo

- Vaga em português + empresa brasileira → currículo em português, mantendo
  termos técnicos em inglês quando a vaga os usa (RAG, LLM, APIs REST...).
- Vaga em inglês + empresa internacional → currículo em inglês, seções
  traduzidas para os equivalentes padronizados.
- Termos técnicos: sempre os termos exatos da vaga, independente do idioma
  do resto do documento.

## Atualizar a base de conhecimento do candidato

Quando o usuário informar um novo emprego, skill, certificação, ou corrigir
um dado existente, edite `references/candidato.md` na seção correspondente.
Se a informação for ambígua (por exemplo, não está claro se algo é
experiência profissional ou só "estudo"), confirme com o usuário antes de
gravar — não decida sozinho.

## Restrições absolutas

- Não invente dados; tudo vem de `candidato.md` ou de confirmação explícita
  do usuário.
- Não invente experiências em outras empresas.
- Na experiência autônoma, não invente tecnologias, projetos, clientes ou
  resultados fora da base — reenquadre o que já existe, nunca crie stack
  nova só porque a vaga pede.
- Não altere datas reais do candidato.
- Não insira texto escondido, branco ou fora da área visível do PDF.
- Não use tabelas, colunas, cabeçalhos, rodapés, linhas decorativas, ícones
  ou cores.
- Não exagere no número de skills listadas; mantenha-as justificáveis.
- Não use clichês sem comprovação por conquista.
- Nunca pule a etapa de validação ATS.

## Erros comuns

| Erro | Correção |
|---|---|
| Adicionar tecnologia nova na experiência autônoma "porque a vaga pede" | Só use o que já está em `candidato.md`; senão, omita ou marque como familiaridade |
| Entregar o `.tex` sem compilar | O produto final é o PDF em `~/Downloads/`, não o código-fonte |
| Pular a validação ATS "porque o currículo já ficou bom" | Rode o checklist completo mesmo assim; é o que garante que passe no parser |
| Gerar currículo sem ter a descrição da vaga completa | Pergunte pelos requisitos/stack/senioridade antes de escrever qualquer bullet |
| Usar cores, ícones ou tabelas para "ficar mais bonito" | Proibido — quebra parsers ATS; o layout é sempre texto simples |

## Apêndice — instalação do Cauê (08/10/2026)

- Skill copiada sem alteração de `github.com/dv-dev1/claude-setup` (commit
  `4e94455`); só a Etapa 3 e este apêndice foram acrescentados.
- **`references/candidato.md` ainda é a base do Daniel Vieira.** O Cauê vai
  montar a base dele depois. Até lá, antes de gerar qualquer currículo,
  pergunte de quem é: se for do Cauê e a base dele ainda não existir, pare e
  monte a base primeiro, com dados que ele mesmo informar — nunca adapte a
  base do Daniel para ele.
- Cuidado no `template.tex`: uma linha terminada em `\\` seguida de outra que
  começa com `[` quebra a compilação ("Missing number"), porque o LaTeX lê
  `\\[...]` como espaçamento. Só acontece com os placeholders entre colchetes;
  ao preencher, nenhuma linha deve começar com `[`.
