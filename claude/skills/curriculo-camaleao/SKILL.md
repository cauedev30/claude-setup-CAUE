---
name: curriculo-camaleao
description: Use quando o usuário pedir para gerar, adaptar, reescrever ou otimizar um currículo/CV para uma vaga específica, pedir um currículo em LaTeX otimizado para ATS, mencionar "currículo camaleão", ou quiser atualizar o currículo base do candidato (novo emprego, skill, certificação, correção de dado).
---

# Currículo Camaleão

Gera um currículo em LaTeX **totalmente adaptado a uma vaga específica**, a
partir do currículo base do candidato, sem nunca inventar fatos. Só entrega
depois de passar por uma validação ATS obrigatória.

## Arquivos desta skill

- `references/curriculo-base.tex`: **fonte única de conhecimento** sobre o
  candidato (Cauê Franco). É o currículo original aprovado por ele
  (09/10/2026, versão geral). Todo currículo novo parte de uma cópia dele, e
  nenhum fato sobre o candidato existe fora dele.
- `references/template.tex`: **estrutura obrigatória** de todo currículo,
  copiada do currículo "Geral" do Daniel a pedido do Cauê (09/10/2026):
  nome + linha de título, contato, Resumo, Experiência (empresa / Cargo /
  Período / Local + bullets), Competências Técnicas nas 8 categorias fixas,
  Formação, Certificações, Idiomas. Nunca acrescente, remova ou reordene
  seção; o que muda de uma vaga para outra é só o conteúdo. Única exceção:
  sem certificação na base, a seção Certificações sai.
- `references/regras-ats.md`: regras de formatação ATS e o checklist de
  validação obrigatório (seção final).

## Fonte única: o currículo base (decisão do Cauê, 22/10/2026)

Até 22/10/2026 existia um `candidato.md` que acumulava o que ele confirmava
para cada vaga (Dialogflow, Watson, Automation Anywhere, C#, PHP, Java, Power
Platform, Twilio etc.). Esses itens vazavam para os currículos seguintes
como se fossem da base. Ele mandou limpar: "deixa só o currículo original
como fonte única de conhecimento, aí fazemos adaptações de acordo com a vaga".
O arquivo antigo está em backup fora da skill
(`~/Documents/curriculo-camaleao-build/_backup-base/`) e **não deve ser lido
para gerar currículo**.

Daqui em diante:

1. Todo fato sobre o candidato vem do `curriculo-base.tex`.
2. Se a vaga pede algo que não está na base, **pergunte** se ele já usou.
   Se ele confirmar, o item entra **só no currículo daquela vaga** (resumo e
   Competências; vira bullet de experiência só se ele disser onde e como
   usou). **Não grave na base.** A próxima vaga começa de novo do base.
3. A base só muda quando ele pedir explicitamente para atualizar o currículo
   base (emprego novo, certificação, correção de dado). Aí edite o
   `curriculo-base.tex` e mostre o que mudou.
4. **Stack de reserva (22/10/2026):** os blocos de comentário `% STACK DE
   RESERVA` no `curriculo-base.tex` (agente de atendimento na GeniAI e site
   do restaurante no freelance) são fatos confirmados, mas não saem no PDF
   geral. Quando a vaga pedir um desses itens, enriqueça o bullet daquela
   experiência e as Competências com ele, sem perguntar de novo. Sem pedido
   da vaga, fica de fora ("a lógica continua a mesma: se a vaga solicitar,
   você enriquece mais"). O número de testes (397) também pode ser usado.

## Só o que a vaga pede (decisão do Cauê, 22/10/2026)

Item verdadeiro mas fora da vaga **sai**. Nas duas vagas da Build IT ele
questionou "a vaga pede Twilio?" e "a vaga pede isso?" (Copilot Studio,
Power Apps, Dataverse, Power BI). Antes de pôr um bullet, um trecho de
bullet ou uma competência, aponte qual requisito da vaga ele atende. Sem
requisito, corte. Ligação indireta (ex.: Power Automate perto de RPA):
mantenha só a parte ligada e diga isso na entrega. Não repita a mesma
tecnologia em duas categorias de Competências.

**Reaproveitar de outra vaga (23/10/2026):** o que ele confirmou numa vaga
anterior só volta se a vaga atual **pedir** aquele item. Aí você olha a
confirmação ou o currículo anterior para se inspirar. Se a vaga não pede,
não ofereça nem pergunte ("se não pedir, não tem para quê"). Na K2M eu
ofereci Pandas e Polars, confirmados na INDI, sem a vaga pedir, e ele
corrigiu.

## Regras de redação (decididas com o Cauê, valem para todo currículo)

- **"Vibe coding" e "AI Coding" são proibidos (27/10/2026):** nenhuma das
  duas expressões entra em currículo, nem quando a vaga usa o termo ("isso
  não se fala"; "isso não existe"). Para esse requisito, cite as
  ferramentas pelo nome (Claude Code, Cursor, Codex, ChatGPT), sem rótulo
  de categoria em volta.
- **"Prompt engineering" é proibido (28/10/2026):** "isso é muito feio".
  Nunca entra em currículo, nem quando a vaga usa o termo. Para esse
  requisito, escreva em português o que é feito ("criação e teste de
  prompts").
- **Posicionamento:** AI Full Stack Engineer. O currículo inteiro puxa para
  esse lado: título, resumo, ordem e redação dos bullets, competências. A
  leitura que fica é "constrói agentes de LLM e o produto inteiro em volta
  deles: back-end, interface, integrações e deploy". Varie o título só quando
  a vaga usar outro nome, sempre no eixo IA aplicada + engenharia full stack.
- **Primeira pessoa no currículo inteiro**, inclusive no resumo ("construo",
  "desenvolvo", "tenho experiência"); nunca terceira pessoa. Bullets de
  entrega no passado ("Construí"); prática contínua no presente ("Aplico").
  Abertura do resumo: "AI Full Stack Engineer, construo ..." (sem "Sou").
- **Números:** só os que já estão na base (triagem 100% automática; cerca de
  20 contas no provisionamento). Não acrescente outros.
- **Marca do cliente final da GeniAI:** não cite; escreva "rede de franquias
  de saúde". Cliente do freelance também não é citado.
- **Fora do currículo:** pipeline de landing pages e painel de deploy.
- **Projetos são código fechado:** não linke repositório.
- **Sem travessão no texto corrido:** use dois-pontos ou parênteses. Intervalo
  de datas com `--` no LaTeX está ok.
- **Mudança de cidade:** ele não topa. Nunca afirme disponibilidade para
  mudança, mesmo em vaga presencial/híbrida em outra cidade.
- **Frase fixa em Ferramentas e Metodologias:** a linha sempre **termina**
  com `Claude Code: workflow agêntico (harness, guardrails, contexto
  versionado, evals, policies)`, escrita exatamente assim, em toda vaga, com
  ou sem IA (22/10/2026). O resto da categoria vem antes e se adapta à vaga.

## Missão (inegociável)

Para cada vaga, apresente o candidato como a contratação ideal **dentro dos
limites da verdade**: maximize a densidade de keywords relevantes, posicione
cada experiência real na interseção máxima com os requisitos da vaga,
reescreva bullets para evidenciar o que a vaga procura (mesmo que já exista
na base sob outro nome) e priorize as entregas mais próximas do cargo.

**Reestruturar, reordenar, reenquadrar e dar ênfase: sim. Inventar: não.**
Nunca invente empregos, experiências freelance, certificações, formações,
tecnologias ou resultados. Se a vaga pede algo que não está na base, pergunte
(ver "Fonte única"); sem confirmação, omita. Isso vale mesmo sob pressão de
"essa vaga é perfeita, só falta essa uma tecnologia".

## Inputs necessários

Antes de gerar, confirme que você tem:

1. **Descrição completa da vaga:** título, responsabilidades, requisitos
   obrigatórios e desejáveis, stack, senioridade, formato de trabalho,
   salário (se houver).
2. **Info da empresa:** ramo, produto/serviço, cultura, stack conhecida,
   porte, diferenciais.

Se faltar algo relevante para o direcionamento, pergunte antes de gerar.

## Pipeline

### 1. Analisar a vaga
Extraia: hard skills (linguagens, frameworks, bancos, cloud, ferramentas),
variantes do título do cargo, responsabilidades centrais, keywords em
destaque, 2–3 soft skills realmente exigidas, nível de senioridade, idioma da
contratação. Cruze cada requisito com o `curriculo-base.tex` e liste o que
**não** está na base: isso vira pergunta para o Cauê antes de escrever.

### 2. Definir a estratégia de alinhamento
- **Título no topo:** "AI Full Stack Engineer", com o que vem entre
  parênteses adaptado à vaga.
- **Resumo profissional:** 3–4 linhas densas em keywords, com stack principal
  e valor mensurável.
- **Experiências:** mantenha todas as da base; reescreva bullets em
  Contexto → Ação → Resultado (CAR); reordene o bullet mais alinhado para
  primeiro; use os termos exatos da vaga quando forem o mesmo fato da base.
- **Projetos dentro das experiências:** não existe seção Projetos. O agente
  de atendimento e o provisionamento no Chatwoot são bullets da GeniAI; o
  site de pedidos é bullet do freelance.
- **Competências técnicas:** só o que a vaga pede e está na base (ou foi
  confirmado para esta vaga); cada item numa categoria só.
- **Formação:** mantenha a real.

### 3. Redigir o `.tex`
Copie `references/curriculo-base.tex` e adapte só o conteúdo, sem alterar
preâmbulo nem estrutura. Nas palavras do Cauê (09/10/2026): "não sejam
inventadas mentiras, apenas adaptações do meu currículo base para a vaga.
Isso significa alterar palavras-chave e colocar os meus projetos voltados ao
que a vaga solicita." Pode:
- trocar o que vem entre parênteses na linha de título;
- reescrever o resumo e os bullets com os termos exatos da vaga;
- reordenar bullets e dar ênfase ao lado de cada projeto que a vaga pede;
- reordenar e enxugar as competências, priorizando as da vaga;
- incluir o que ele confirmou na conversa **para esta vaga**.

Não pode: acrescentar empresa, cargo, projeto, tecnologia, número ou
resultado que não esteja no `curriculo-base.tex` nem tenha sido confirmado
por ele para esta vaga. Siga `references/regras-ats.md`.

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
   `Caue_Franco_<Empresa>.tex` (sem acento, para o `pdflatex` não tropeçar
   no nome do arquivo; sem o cargo, a pedido do Cauê em 21/10/2026).
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
3. Copie o PDF resultante para `~/Downloads/` renomeado para
   `Cauê_Franco_<Empresa>.pdf`: nome com acento e só a empresa, sem o cargo
   (pedido do Cauê, 21/10/2026). Se já existir um PDF com esse nome (segunda
   vaga na mesma empresa), pergunte antes de sobrescrever.
4. Entregue: caminho do PDF, "Validação ATS aprovada" + nota estimada, e um
   alerta se a nota ficou abaixo de 85 (com a lista dos gaps reais; o
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

## Restrições absolutas

- Não invente dados; tudo vem do `curriculo-base.tex` ou de confirmação
  explícita do usuário para a vaga em questão.
- Não grave na base o que ele confirmou para uma vaga.
- Não invente experiências em outras empresas.
- Não altere datas reais do candidato.
- Não insira texto escondido, branco ou fora da área visível do PDF.
- Não use tabelas, colunas, cabeçalhos, rodapés, linhas decorativas, ícones
  ou cores.
- Não exagere no número de skills listadas; só o que a vaga pede.
- Não use clichês sem comprovação por conquista.
- Nunca pule a etapa de validação ATS.

## Erros comuns

| Erro | Correção |
|---|---|
| Adicionar tecnologia "porque a vaga pede" | Pergunte se ele usou; sem confirmação, omita |
| Gravar na base o que ele confirmou para uma vaga | Fica só no currículo daquela vaga |
| Pôr tecnologia verdadeira que a vaga não pede | Corte; aponte o requisito de cada item |
| Ler o backup do `candidato.md` antigo para gerar | Fonte é só o `curriculo-base.tex` |
| Entregar o `.tex` sem compilar | O produto final é o PDF em `~/Downloads/` |
| Pular a validação ATS | Rode o checklist completo mesmo assim |
| Gerar sem a descrição completa da vaga | Pergunte requisitos/stack/senioridade antes |
| Cores, ícones ou tabelas | Proibido: quebra parsers ATS |

## Apêndice — instalação do Cauê (08/10/2026)

- Skill copiada de `github.com/dv-dev1/claude-setup` (commit `4e94455`).
  A base original do Daniel Vieira está lá, se um dia for preciso.
- 09/10/2026: a base passou a ser do Cauê Franco (substituição completa, a
  pedido dele).
- 09/10/2026: o `template.tex` passou a reproduzir exatamente a estrutura do
  PDF `Daniel_Vieira_Geral_Engenheiro_IA_Automacao_n8n.pdf` ("deixa esse
  currículo como base obrigatória; o que vai mudar são as informações").
- 22/10/2026: `candidato.md` removido; `curriculo-base.tex` virou a fonte
  única (ver "Fonte única").
- Cuidado no `template.tex`: uma linha terminada em `\\` seguida de outra que
  começa com `[` quebra a compilação ("Missing number"), porque o LaTeX lê
  `\\[...]` como espaçamento. Só acontece com os placeholders entre colchetes;
  ao preencher, nenhuma linha deve começar com `[`.
