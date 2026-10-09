# Base de conhecimento fixa — candidato

Fonte única de verdade sobre o candidato. Use apenas o que está aqui (ou o que
o usuário confirmar explicitamente na conversa). Pode reformular, dar ênfase e
reordenar — nunca inventar empregos, datas, formações, certificações,
resultados ou contato.

Quando o usuário informar um novo emprego, skill, certificação ou correção,
edite este arquivo diretamente (seção correspondente) em vez de guardar o dado
só na conversa.

- **Nome:** Daniel Vieira
- **Localização:** João Pessoa, Paraíba, Brasil
- **Disponibilidade geográfica:** aberto a mudança para São Paulo e a atuação
  presencial ou híbrida na cidade. (Confirmado pelo candidato em 02/09/2026.)
- **E-mail:** danielvmacedog1@gmail.com
- **LinkedIn:** www.linkedin.com/in/dv-dev
- **GitHub:** https://github.com/dv-dev1 (confirmado em 07/09/2026)
  - Projeto público de destaque: `agentgraph` — motor de grafo de agentes em
    Python com checkpointing em SQLite, aprovação humana (human-in-the-loop),
    retomada por `thread_id`, trilha de auditoria por passo, testes em Pytest e
    CI no GitHub Actions. Zero dependências no motor.
  - Outros repositórios públicos: `emporio-da-musica-agent` (agente de
    atendimento com tool calling sobre SQLite e BM25), `technovinho-projeto`
    (backend FastAPI com Alembic e Docker), `vox` (ditado local em Go).
- **Telefone:** (não informado; se o usuário não fornecer, omita ou peça)
- **Resumo geral:** Engenheiro de IA Aplicada e desenvolvedor Full Stack.
  Constrói agentes de IA, pipelines RAG e automações que rodam em produção.
  Atua na Smartspace com soluções de IA conversacional e aplicações full stack
  em Python, TypeScript, React e Next.js, integrando APIs REST e MCP servers.
  Foco em sistemas de IA viáveis de operar em escala, não protótipos caros.

## Experiência Profissional

### Desenvolvedor Autônomo / Freelancer — Projetos Independentes em ETL, IA Aplicada e Desenvolvimento Full Stack
- **Período:** dezembro/2024 — presente
- **Local:** Remote / João Pessoa, PB
- **Atuação:** projetos independentes em paralelo ao trabalho, com foco em
  pipelines de dados, ETL, integrações sistêmicas e soluções de IA aplicada
  para clientes e cenários reais de produto.
- **Principais atribuições:**
  - Construção de pipelines de dados e automações de ETL para integração entre
    fontes de dados, APIs e sistemas de negócio.
  - Desenvolvimento de aplicações web full stack
  - Desenvolvimento de APIs e serviços back-end com NestJS (TypeScript) em
    freelances para clientes.
  - Deploy de aplicações em AWS.
  - Deploy e manutenção de aplicações em VPS.
  - Deploy de aplicações em Cloudflare Workers.
  - Integração com APIs da Meta (WhatsApp Business API e Graph API) via
    OAuth 2 para autenticação delegada.
    (VPS, Cloudflare Workers e APIs da Meta: uso em projeto real confirmado
    pelo candidato em 03/09/2026. OAuth 2 confirmado em 08/09/2026.)
  - Construção de automações e fluxos de IA
  - Implementação de agentes e pipelines RAG
  - Integrações de APIs e sistemas
  - Prototipagem e entrega de soluções com stack moderna

> Regra especial: use esta experiência **só** com tecnologias e atribuições já
> comprovadas em outro lugar da base (trabalho atual + estágios + stack já
> documentada). Nunca some uma tecnologia nova aqui só porque a vaga pede.

### Smartspace — Engenheiro de IA e Dados / ETL & Data Engineer
- **Período:** novembro/2025 — presente
- **Local:** João Pessoa, PB
- **Atuação:** end-to-end em produtos de IA conversacional, agentes corporativos,
  pipelines de dados e desenvolvimento full stack; construção de relatórios,
  dashboards e soluções de dados para clientes corporativos.
- **Principais entregas:**
  - Desenvolvimento de agentes corporativos no Microsoft Copilot Studio,
    conectando inteligência artificial aos processos e sistemas de negócio
    via Power Automate, Dataverse, Microsoft Graph e Microsoft 365, com uso
    do ecossistema Microsoft Teams na Smartspace.
    (Uso do ecossistema Microsoft Teams confirmado pelo candidato em 03/09/2026.)
  - Automações e integrações em Power Automate conectando agentes, dados e
    sistemas corporativos, reduzindo tarefas manuais e acelerando jornadas
    de negócio.
  - Estratégias de grounding, prompt engineering e controle de alucinações
    para agentes de IA, garantindo respostas alinhadas a bases de
    conhecimento corporativas.
  - Criação e manutenção de testes automatizados com Pytest para agentes de IA
    e integrações: testes unitários e end-to-end garantindo qualidade e
    estabilidade das entregas.
  - Construção de relatórios e dashboards em Power BI para clientes como
    Banco do Nordeste e Real Hospital Português, transformando dados brutos
    em insights acionáveis para decisão de negócio.
  - Pipeline design-to-bot: plugin de Figma sobre o design system da empresa
    converte protótipo em JSON estruturado; App Builder transforma JSON em
    bot de produção no Botpress; chat embutido emula WhatsApp para validação
    durante a construção. Redução de 80% no ciclo de engenharia do bot.
    Projeto apresentado no TechUpdate.
  - Migração do fluxo de agendamento de exames de um cliente hospitalar de
    grande porte: saiu de fluxo em n8n para agente em código, com harness
    fechado em volta do modelo (policies, hooks e guardrails). Antes da
    migração o agente alucinava e o usuário abandonava a jornada antes de
    concluir a marcação. Depois, as marcações concluídas passaram de cerca
    de 120 para cerca de 230, nos primeiros meses após a migração, e seguem
    subindo conforme agente e harness evoluem.
    (Confirmado pelo candidato em 02/09/2026. Três travas obrigatórias:
    1. Há NDA. Em qualquer material público — LinkedIn, currículo, post —
    escrever "hospital de grande porte" e NUNCA nomear o cliente.
    2. A métrica é VOLUME DE MARCAÇÕES CONCLUÍDAS, não acurácia. Nunca
    escrever "92% de acurácia" nem qualquer variação com a palavra acurácia.
    3. O período das medições ainda não foi confirmado pelo candidato.
    Escrever sempre "nos primeiros meses após a migração", nunca inventar
    janela de tempo, e nunca dizer que o ganho está estabilizado.)
  - Workspace de desenvolvimento para projetos Botpress com hooks de
    inicialização e skills que codificam padrão arquitetural e regras de
    negócio internas; geração assistida por LLM passou a seguir o padrão
    existente por construção, aumentando produtividade e reduzindo retrabalho.
  - Agentes e fluxos conversacionais em Botpress, Typebot e Microsoft Copilot
    Studio, com uso intensivo de LLMs, RAG e grounding, foco em escalabilidade,
    UX e governança.
  - Modelagem de dados, Row Level Security policies e edge functions no
    Supabase (Postgres) para aplicações Next.js, garantindo segurança e
    performance no data layer de agentes e produtos digitais.
  - Deploy contínuo de aplicações Next.js na Vercel, gerenciando ambientes de
    preview e produção com workflow disciplinado de GitHub (branching, pull
    requests, CI/CD básico e code review).
  - Integrações com APIs REST, webhooks e MCP servers.
  - Desenvolvimento de uma API própria no padrão API Gateway, centralizando e
    roteando chamadas para diferentes scripts em PHP usados na construção de
    bots, servindo como ponto único de entrada para esses serviços.
    (Confirmado pelo candidato em 02/09/2026. É uma API própria seguindo o
    padrão arquitetural API Gateway, NÃO o serviço gerenciado AWS API Gateway
    — nunca escrever "AWS API Gateway" a partir deste item.)
  - Uso de AWS Lambda (funções serverless), Amazon RDS e DynamoDB em produção.
    (Confirmado pelo candidato em 02/09/2026.)
  - Infraestrutura como Código (IaC) com AWS CloudFormation e Terraform.
    (Confirmado pelo candidato em 02/09/2026.)
  - Containers Docker em produção, fora da AWS — não em Amazon ECS.
    (Confirmado pelo candidato em 02/09/2026. Nunca escrever "ECS" a partir
    deste item.)
  - Resolução de gargalos de performance e integração com serviços em
    Node.js.
  - Integrações com mensageria e filas (RabbitMQ, Kafka) para comunicação
    assíncrona entre microsserviços e agentes de IA.
  - Scripts em PHP para rotinas de banco de dados.
  - Aplicações e serviços em Python, TypeScript, React e Next.js, com estilização
    em Tailwind CSS e consumo/integração de APIs GraphQL. (Confirmado pelo
    candidato em 08/09/2026.)
  - Workflow de uso de LLMs organizado por vaults e workspaces com skills,
    hooks e guardrails por projeto, incluindo ambiente de produção travado
    como read-only para evitar alterações indesejadas.
  - Orquestração de fluxos de agentes de IA com LangChain e LangGraph.
  - Uso de Langflow para criação e visualização de fluxos de agentes de IA.
    (Confirmado pelo candidato em 08/09/2026.)
  - Integração com modelos Gemini via Google Vertex AI.
  - Noções de observabilidade com Grafana para acompanhamento de aplicações
    de IA.
  - Desenvolvimento de aplicações mobile com React Native para Android e iOS.
  - Contribuição em arquiteturas de microsserviços e microfrontends.
  - Aplicação de Domain-Driven Design (DDD) na modelagem de domínios e na
    organização de serviços e regras de negócio.
  - Testes end-to-end (E2E) com Cypress.

### Inteligentte Lab — Estagiário em IA Aplicada e Automação | Agentes, RAG e Integrações
- **Período:** julho/2025 — novembro/2025
- **Local:** João Pessoa, PB
- **Atuação:** estágio na frente de IA aplicada do grupo Agência Quinze |
  Inteligentte Lab, com foco em arquitetura de agentes e produto digital.
- **Principais entregas:**
  - Redução de 99,3% no custo por consulta de agente de IA sobre catálogo de
    2.000+ produtos: substituiu envio de 600 mil tokens por consulta por
    pipeline RAG com Pinecone. Custo caiu de US$ 6,00 para US$ 0,04; com
    mesmo orçamento diário, agente passou de 3 para 500 clientes atendidos.
  - Agentes de IA para distribuição automática de informação e suporte
    contextual sobre bases documentais, com arquitetura RAG.
  - Melhoria de 70% nos fluxos de comunicação e suporte de produto digital.
  - Utilização de Supabase (Postgres) como data layer para agentes de IA,
    com modelagem de dados e segurança em Row Level Security.
  - Deploy de aplicações Next.js na Vercel e versionamento com Git/GitHub
    durante o desenvolvimento dos produtos de IA.
  - Construção de APIs REST em FastAPI para agentes de IA e integrações
    sistêmicas, consumidas por front-end e outros serviços.
  - Integrações com n8n, APIs REST e webhooks.

### Agência Quinze — Estagiário em Automação e Agentes de IA
- **Período:** julho/2025 — novembro/2025
- **Local:** João Pessoa, PB
- **Atuação:** estágio na frente de automação e inteligência operacional do
  grupo, junto ao time de Marketing.
- **Principais entregas:**
  - Fluxos de automação em Make e n8n para eliminar tarefas repetitivas.
  - Agentes de IA autônomos para resolução de demandas internas recorrentes.
  - Integração de dados entre CRM, ferramentas de Marketing e ClickUp via
    APIs REST e webhooks.
  - Monitoramento de saúde dos fluxos (logs e tratamento de erros).
  - Atuação consultiva com times de operações e marketing.

## Formação Acadêmica
- **Unipê — Centro Universitário de João Pessoa:** Curso Superior de
  Tecnologia (CST), Análise e Desenvolvimento de Sistemas — 2025/2026.
- **UNIESP Centro Universitário:** Processamento de Dados e Tecnologia de
  Processamento de Dados — agosto/2023 a novembro/2023.

## Certificações
- Claude Code in Action
- AWS Educate Introduction to Generative AI (Amazon Web Services) — ago/2025

## Competências Técnicas do Candidato
- **IA Aplicada e Agentes Corporativos:** Agentes de IA, RAG (Retrieval-Augmented
  Generation), bancos vetoriais (Pinecone, pgvector via Supabase Postgres —
  confirmado pelo candidato em 08/09/2026), LLMs (GPT, Claude, Gemini, Mistral),
  LangChain, LangGraph, Langflow (confirmado 08/09/2026), Google Vertex AI (integração com Gemini), Microsoft
  Copilot Studio, Microsoft Power Platform (Power Automate, Dataverse),
  Microsoft Graph, Microsoft 365, Azure (familiaridade), Botpress, Typebot, n8n,
  MCP servers, prompt/context engineering, grounding, controle de custo por token,
  Claude Code com skills e hooks.
- **Back-end e Full Stack:** JavaScript, TypeScript, HTML5, CSS3, Python, SQL, XML,
  MySQL (uso em projeto real confirmado pelo candidato em 03/09/2026),
  PHP (scripts para rotinas de banco de dados),
  FastAPI, Node.js, Express, NestJS (TypeScript; usado em freelances),
  React, React Native, Next.js, Tailwind CSS, GraphQL (confirmado 08/09/2026), Oracle Database,
  SQL Server, Supabase (Postgres, Row Level Security, edge functions), MongoDB,
  ElasticSearch, APIs REST, autenticação JWT, OAuth 2, webhooks, integrações sistêmicas,
  microsserviços, microfrontends, Domain-Driven Design (DDD),
  mensageria e filas (RabbitMQ, Kafka), deploy em nuvem (Vercel, AWS), APIs da Meta (WhatsApp Business API,
  Graph API; projeto real confirmado 03/09/2026). Java 17 e Spring
  Boot: familiaridade/estudo, sem experiência profissional em produção.
- **Testes e Qualidade:** Pytest, Cypress (testes E2E), testes unitários,
  testes end-to-end.
- **DevOps e Infra:** Docker, Kubernetes (noções), Grafana (noções), Git, GitHub, Cloudflare Workers (projeto real confirmado 03/09/2026), deploy em VPS (projeto real confirmado 03/09/2026),
  (branching, pull requests, preview/production environments, CI/CD básico),
  AWS: AWS Lambda, Amazon RDS e DynamoDB em produção; Infraestrutura como
  Código (IaC) com AWS CloudFormation e Terraform; deploy de aplicações como
  desenvolvedor autônomo; AWS Educate — IA Generativa. Docker em produção
  (fora da AWS). Padrão arquitetural API Gateway via API própria (não o
  serviço AWS API Gateway). Serviços gerenciados AWS específicos (AWS API
  Gateway, ECS, SQS, SNS, S3, Secrets Manager): familiaridade em estudo,
  sem uso comprovado.
- **Ferramentas:** Power BI, Figma (plugin/JSON), Make, ClickUp, CRM.
- **Metodologias:** Scrum, Kanban.
- **Data Science e Estatística:** noções acadêmicas vistas na grade dos cursos
  técnicos (Unipê — Análise e Desenvolvimento de Sistemas; UNIESP —
  Processamento de Dados). Familiaridade em estudo, sem projeto profissional
  de Data Science/Estatística formal. (Confirmado pelo candidato em
  08/09/2026.)

## Idiomas
- Português: Nativo
- Inglês: leitura, compreensão e escrita técnica em nível avançado (C1) —
  documentação, papers, código e comunicação escrita no dia a dia. Conversação
  em nível intermediário (B1–B2): sustenta uma conversa técnica, com fluidez
  ainda em desenvolvimento. (Confirmado pelo candidato em 01/09/2026; substitui
  as duas linhas conflitantes que existiam antes.)
