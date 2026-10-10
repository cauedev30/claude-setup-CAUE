# Base de conhecimento fixa: candidato

Fonte única de verdade sobre o candidato. Use apenas o que está aqui (ou o que
o usuário confirmar explicitamente na conversa). Pode reformular, dar ênfase e
reordenar; nunca inventar empregos, datas, formações, certificações,
resultados ou contato.

Quando o usuário informar um novo emprego, skill, certificação ou correção,
edite este arquivo diretamente (seção correspondente) em vez de guardar o dado
só na conversa.

Montada em 09/10/2026 com dados informados pelo próprio Cauê e com o que ele
publicou no LinkedIn e no GitHub (cópia no vault: `Knowledge/Perfil
Profissional - LinkedIn e GitHub.md`). Substitui por completo a base anterior
(Daniel Vieira), a pedido dele.

## Posicionamento (decisão dele)

- **Título:** AI Full Stack Engineer.
- O currículo **inteiro** puxa para esse lado, não só os projetos: título,
  resumo, ordem e redação dos bullets, ordem dos projetos e agrupamento das
  competências. A leitura que deve ficar é "constrói agentes de LLM e o
  produto inteiro em volta deles: back-end, interface, integrações e deploy".
- Varie o título só quando a vaga usar outro nome, e sempre dentro do eixo
  IA aplicada + engenharia full stack (ex.: AI Engineer, Generative AI
  Engineer, Full Stack Engineer com foco em IA).

## Regras de redação (decididas com ele)

- Não citar a marca do cliente final da GeniAI: escreva "rede de franquias de
  saúde". A GeniAI pode ser citada.
- Pipeline de landing pages e painel de deploy ficam fora do currículo.
- Sem travessão no texto corrido: use dois-pontos ou parênteses. Intervalo de
  datas com `--` no LaTeX está ok.
- **Primeira pessoa no currículo inteiro**, inclusive no Resumo Profissional
  ("Sou", "Construo", "Desenvolvo", "Tenho experiência"); nunca terceira pessoa
  ("constrói", "desenvolve", "atua"). Bullets de entrega no passado ("Construí",
  "Automatizei"); prática contínua no presente ("Aplico workflow agêntico").
  Pedido dele em 09/10/2026. Abertura do resumo: "AI Full Stack Engineer,
  construo agentes de LLM..." (sem "Sou"; escolha dele, 09/10/2026).
- Número só com fonte. Os resultados quantificados aprovados são os que estão
  abaixo (triagem 100% automática; cerca de 20 contas no provisionamento). Ele
  mandou deixar assim em 09/10/2026: não acrescente outros números sem ele
  informar.

## Dados pessoais

- **Nome:** Cauê Franco
- **Localização:** João Pessoa, Paraíba, Brasil
- **Formato de trabalho:** presencial, híbrido ou remoto (LinkedIn, 09/10/2026).
  Mudança de cidade: não informado, não afirme.
- **Telefone:** (83) 98746-8188
- **E-mail:** cauefranco01@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/cauefranco01
- **GitHub:** https://github.com/cauedev30 (os projetos abaixo são código
  fechado: não linke repositório)
- **Resumo geral:** AI Full Stack Engineer. Constrói agentes de LLM e o
  produto inteiro em volta deles: back-end, interface, integrações e deploy.
  Hoje na GeniAI como Generative AI Engineer. Desenvolve com workflow agêntico
  como método, não como atalho: fecha um harness em volta do modelo (skills,
  hooks, guardrails, evals e contexto versionado) para entregar sistemas
  observáveis, manuteníveis e prontos para escalar, com cada decisão técnica
  ligada ao planejamento do projeto e a um resultado de negócio.

## Experiência Profissional

Estrutura obrigatória (template.tex): não existe seção Projetos. Os três
projetos que ele escolheu (09/10/2026) aparecem como bullets das experiências
abaixo. Todos são código fechado: não linke repositório.

### GeniAI
- **Cargo:** Generative AI Engineer (efetivado em 07/2026; antes, Especialista
  em Automação, estágio). Decisão dele em 09/10/2026: uma entrada só, porque o
  estágio não tem descrição própria.
- **Período:** 11/2025 a presente (estágio 11/2025 a 07/2026; tempo integral
  desde 07/2026)
- **Local:** João Pessoa, PB (confirmado por ele em 09/10/2026)
- **Atuação:** construção de aplicações com IA aplicada ("eu construo
  aplicações com IA aplicada", fala dele): agentes de LLM e o produto em volta
  deles, de ponta a ponta.
- **Agente de atendimento no WhatsApp:**
  - Agente LLM construído de ponta a ponta: identifica o cliente, abre o
    ticket e responde com grounding em uma base de conhecimento curada.
  - Multimodal: entende áudio e imagem enviados pelo cliente.
  - **Resultado:** a triagem, que era manual, passou a ser 100% automática.
  - Tickets organizados em kanban, com painel de monitoramento e indicadores.
  - **Stack:** back-end em Python, FastAPI e PostgreSQL; front-end em React e
    Next.js; LLM da OpenAI; testes com Pytest e Vitest.
- **Automação de provisionamento no Chatwoot:**
  - Automação idempotente e parametrizada que cria usuário, times, etiquetas,
    regras de roteamento e inboxes em cerca de 20 contas Chatwoot de uma rede
    de franquias de saúde.
  - Confere banco e Chatwoot antes de escrever e registra cada execução.
  - **Stack:** n8n, Supabase (PostgreSQL), APIs REST do Chatwoot, webhooks.
- **Método:** workflow agêntico, com harness em volta do modelo (skills,
  hooks, guardrails, evals e contexto versionado) e cada decisão técnica
  ligada ao planejamento do projeto.

### Desenvolvedor Autônomo / Freelancer
- **Cargo:** Desenvolvedor Full Stack
- **Período:** 07/2026 a presente. Em andamento (confirmado por ele em
  09/10/2026); o mês de início veio do primeiro commit do repo do cliente
  (28/07/2026), não da fala dele: se ele corrigir, troque.
- **Local:** Remoto, João Pessoa, PB (confirmado em 09/10/2026)
- **Site de pedidos para restaurante:**
  - Next.js no edge da Cloudflare (Cloudflare Workers), com painel
    autenticado, organizando os pedidos e otimizando o fluxo de trabalho do
    cliente.
  - Não cite o nome do cliente.
  - **Stack:** Next.js, JavaScript, Cloudflare Workers.

### Fábrica de Software UBTech Office (Unipê)
- **Cargo:** Desenvolvedor Back-end (estágio)
- **Período:** 08/2025 a 11/2025
- **Local:** João Pessoa, PB
- **Atuação** (texto dele, 09/10/2026):
  - Desenvolvimento do back-end de um sistema de gestão operacional para um
    órgão governamental da Paraíba, com Python e Django, centralizando
    informações críticas.
  - Modelagem e estruturação de bancos de dados relacionais com PostgreSQL e
    SQLite3, garantindo integridade, segurança e performance no acesso aos
    dados institucionais.

## Formação Acadêmica
- **Centro Universitário Unipê:** Análise e Desenvolvimento de Sistemas,
  2025 a 2027 (em andamento). Meses não informados: use só os anos
  (`2025 -- 2027`).

## Certificações
- Nenhuma. Decisão dele em 09/10/2026: sem certificação, a seção sai do
  currículo (única exceção à estrutura obrigatória). Volta quando houver.

## Competências Técnicas do Candidato
Tudo abaixo foi publicado por ele no README do GitHub ou no LinkedIn, ou é
usado nos projetos acima.

- **IA aplicada:** LLMs, RAG (Retrieval-Augmented Generation), embeddings e
  bancos de dados vetoriais, agentes e sistemas multiagentes, harness (skills,
  hooks, guardrails, evals, contexto versionado), function calling e tool use,
  MCP (Model Context Protocol), prompt e context engineering, grounding em
  base de conhecimento, evals e controle de custo de tokens, entrada
  multimodal (áudio e imagem), API da OpenAI.
- **Desenvolvimento assistido por IA:** Claude Code com skills e hooks por
  projeto, workflow agêntico, MCP servers para fornecer ferramentas ao agente,
  aprovação humana antes de qualquer ação irreversível, critério de aceite
  executável antes de fechar cada feature, policies (informado por ele em
  09/10/2026).
- **Back-end:** Python, FastAPI, SQLAlchemy, Django (estágio), Flask
  (informado por ele em 09/10/2026), Node.js, APIs REST, webhooks, Clean
  Architecture.
- **Front-end:** TypeScript, JavaScript, React, Next.js.
- **Banco de dados:** PostgreSQL, SQLite (SQLite3, no estágio da UBTech),
  Supabase (Row Level Security), modelagem de bancos relacionais.
- **Automação e integrações:** n8n, Make (informado por ele em 09/10/2026),
  Chatwoot, WhatsApp.
- **DevOps e qualidade:** Docker, Dokku, CI/CD com GitHub Actions, Git e
  GitHub, Cloudflare Workers, Pytest, Vitest, Playwright.

## Idiomas
- Português: nativo
- Inglês: intermediário/avançado (informado por ele em 09/10/2026)
