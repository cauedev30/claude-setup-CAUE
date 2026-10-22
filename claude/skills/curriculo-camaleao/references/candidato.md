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

- **Frase obrigatória em Ferramentas e Metodologias** (pedido dele em
  21/10/2026, vale para todo currículo daqui em diante): a categoria sempre
  começa com `Claude Code: workflow agêntico`, escrito assim. O resto da
  categoria se adapta à vaga; essa frase nunca sai, mesmo em vaga sem IA.

## Dados pessoais

- **Nome:** Cauê Franco
- **Localização:** João Pessoa, Paraíba, Brasil
- **Formato de trabalho:** presencial, híbrido ou remoto (LinkedIn, 09/10/2026).
  Mudança de cidade: **não topa** (disse em 21/10/2026, na vaga da
  Volkswagen, híbrida em SP), mas pode querer tentar vagas assim mesmo. Nunca
  afirme disponibilidade para mudança.
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
  - Tickets organizados em kanban, com painel de monitoramento e indicadores
    por unidade e categoria (nota do vault `Projects/Active/Chatbot de
    Atendimento GeniAI.md`).
  - **Stack:** back-end em Python, FastAPI e PostgreSQL; front-end em React e
    Next.js; LLM da OpenAI; testes com Pytest e Vitest.
  - Os testes em Pytest incluem **testes unitários** (confirmado por ele em
    21/10/2026, vaga da Agnes): pode escrever "testes unitários".
  - **Evals e controle de custo de tokens** foram feitos neste agente
    (confirmado por ele em 21/10/2026, vaga da ORYS).
  - **Prevenção de prompt injection e proteção de dados (LGPD)** neste agente
    (confirmado por ele em 21/10/2026, vaga da Volkswagen): pode virar
    bullet da GeniAI. Não detalhou a técnica: não invente qual.
  - **Observabilidade com Langfuse** neste agente (21/10/2026): tracing e
    sessions, dashboards e custo por modelo/tokens. Scores/evaluations,
    datasets/experiments e Prompt Management do Langfuse ele **não** marcou:
    não escreva. LLM-as-a-Judge, OpenTelemetry, LiteLLM e Kubernetes também
    não.
- **Automação de provisionamento no Chatwoot:**
  - Automação idempotente e parametrizada que cria usuário, times, etiquetas,
    regras de roteamento e inboxes em cerca de 20 contas Chatwoot de uma rede
    de franquias de saúde.
  - Confere banco e Chatwoot antes de escrever e registra cada execução.
  - **Stack:** n8n, Supabase (PostgreSQL), APIs REST do Chatwoot, webhooks.
- **Treino/fine-tuning de modelo com Hugging Face** (informado por ele em
  21/10/2026, para a vaga da HNM Systems): fez treino/fine-tuning de modelo
  no trabalho da GeniAI usando a biblioteca `transformers` do Hugging Face.
  Ele não disse qual modelo, para quê, nem se foi para produção: não
  acrescente isso sem ele informar. PyTorch e TensorFlow ele **não** marcou:
  não escreva.
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
  multimodal (áudio e imagem), API da OpenAI, Hugging Face Transformers e
  fine-tuning de modelo (21/10/2026, ver GeniAI), LangChain e LangGraph
  (confirmou uso em 21/10/2026, contexto não informado: só Competências,
  não bullet), Langfuse (tracing, sessions, dashboards e custo por modelo,
  no agente da GeniAI).
- **Desenvolvimento assistido por IA:** Claude Code com skills e hooks por
  projeto, workflow agêntico, MCP servers para fornecer ferramentas ao agente,
  aprovação humana antes de qualquer ação irreversível, critério de aceite
  executável antes de fechar cada feature, policies (informado por ele em
  09/10/2026).
- **Back-end:** Python, FastAPI, SQLAlchemy, Django (estágio), Flask
  (informado por ele em 09/10/2026), Node.js, APIs REST, webhooks, Clean
  Architecture.
- **C# / .NET e SQL Server** (confirmou uso em 21/10/2026, vaga da AuthSoft;
  contexto, se trabalho ou estudo, não informado): só Competências, nunca
  bullet de experiência. **WinForms ele não marcou**: não escreva.
- **PHP, MySQL e Linux** (confirmou uso em 21/10/2026, vaga do JOTA;
  contexto não informado): só Competências, nunca bullet. WordPress não foi
  confirmado: não escreva.
- **Java** (confirmou em 22/10/2026, vaga da Lanlink; contexto não
  informado): só Competências e resumo, nunca bullet. Visual Basic ele **não**
  marcou, e não tem certificado de curso de Java/SQL: não escreva.
- **Laravel e Design Patterns** (confirmou uso em 21/10/2026, vaga da Beta;
  contexto não informado): só Competências e resumo, nunca bullet.
  **PHPUnit e a versão do PHP (8+) ele não marcou**: não escreva.
- **Angular e princípios SOLID** (confirmou uso em 21/10/2026, vaga da Sofis;
  contexto não informado): só Competências e resumo, nunca bullet.
  HTML e CSS: não marcou na vaga da Sofis, mas **confirmou na da Coderockr
  (21/10/2026)**: pode escrever.
- **GitHub (branching, issues, pull requests), TDD, Clean Code e Redis**
  (confirmou em 21/10/2026, vaga da Coderockr; contexto não informado): só
  Competências e resumo, nunca bullet. Redis é o banco não relacional que ele
  usou.
- **Pipeline RAG completo** (ingestão, chunking, embeddings e busca vetorial)
  e **mensageria / cloud** (confirmou em 21/10/2026, vaga da Volkswagen; não
  disse onde, nem qual fila ou qual cloud): só Competências e resumo, de
  forma genérica ("mensageria", "cloud"), sem citar SQS, AWS etc.
- **Banco não relacional** (confirmou uso em 21/10/2026, vaga da Agnes; não
  disse qual nem onde): escreva só "bancos não relacionais (NoSQL)" em
  Competências, sem citar MongoDB, Redis etc. Microsserviços ele **não**
  marcou: não escreva.
- **Front-end:** TypeScript, JavaScript, React, Next.js.
- **Banco de dados:** PostgreSQL, SQL Server (ver C#/.NET acima), SQLite
  (SQLite3, no estágio da UBTech),
  Supabase (Row Level Security), modelagem de bancos relacionais.
- **Automação e integrações:** n8n, Make (informado por ele em 09/10/2026),
  Chatwoot, WhatsApp.
- **DevOps e qualidade:** Docker, Dokku, CI/CD com GitHub Actions, Git e
  GitHub, Cloudflare Workers, Pytest, Vitest, Playwright.

- **Análise de dados** (informado por ele em 10/10/2026, para a vaga da ADR
  Empreendimentos):
  - SQL para consultas e relatórios (JOINs, agregações, GROUP BY).
  - Excel (fórmulas, PROCV, tabelas dinâmicas).
  - Python para análise de dados. 21/10/2026 (vaga da Engineering Brasil):
    confirmou que já usou **Pandas** e **NumPy**. Contexto (trabalho ou
    estudo) não informado: entram em Competências e no resumo, não como
    bullet de experiência. **Scikit-learn ele não marcou**: não escreva, nem
    afirme modelo de ML clássico (previsão, classificação, anomalia).
  - Power BI: estudou, sem projeto real. A pedido dele, entra nas
    competências como "Power BI", sem o rótulo "familiaridade em estudo", e
    pode aparecer no resumo como "estudei Power BI". Nunca como bullet de
    experiência nem no título.

## Idiomas
- Português: nativo
- Inglês: intermediário/avançado (informado por ele em 09/10/2026)
