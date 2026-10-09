---
name: tier0-chatbot-suporte-geniai
description: Projeto da engenharia GeniAI - chatbot WhatsApp+Chatwoot de Tier 0; ESTADO 15/09 (mais recente, prevalece sobre o resto desta linha) - E3 FECHADO por ele; ADR-022 (menu misto, submenu de 1 nivel, 0 voltar) e ADR-023 (9 = atendente em todo menu, max 8 opcoes, confirmacao 1 sim/2 nao) decididas por ele; maquina de estados da triagem no dominio publicada (commits 5ce0fac e dedd02e, 6 no repo, CI verde, 48 testes); perguntas do FAQ enviadas ao Matheus, resposta pendente; E1/E2 fechados; TUDO PUBLICADO no repo cauedev30/chatbot-suporte-geniai (4 commits: 4622962/1280f37/2ede205/69581f7, CI verde, so cauedev30); D16 (29/08) mudou o desenho para FAQ de menu numerado sem IA + formulario Notion + ticket no envio do link; D17/D18/D19 (07/09) fecharam as tres pendencias que travavam trabalho: ticket canonico no POSTGRES DO BOT com o id no link (o bot NAO escreve no Notion, e isso derrubou uma consequencia da ADR-018), P3 por TEXTO LIVRE no form, e SEM DOCKER/SEM DEPLOY neste repo porque a aplicacao provavelmente vai para OUTRO DEV que ja tem plataforma; DUAS perguntas minhas ficaram SEM resposta em 07/09 (fechar o E3? menu com destino direto ou submenu?) e NAO sao aprovadas por silencio; o bot NAO executa nada (D6); TypeScript e SEM n8n; nao confundir com a Automacao Chatwoot GeniAI
metadata: 
  node_type: memory
  type: project
  originSessionId: 7ec1d930-3c32-4e37-9472-f92f7130c5c3
  modified: 2026-09-15T18:58:53.649Z
---

**Tier 0 - Chatbot de Suporte GeniAI**: chatbot no WhatsApp integrado ao Chatwoot para
pré-atendimento, triagem, resolução autônoma de FAQ e transbordo qualificado. 12 etapas `E1`–`E12`,
**sem data de entrega definida**. Escopo apresentado em 2026-08-21; **`E1` FECHADO 100% em 2026-08-28**
(fechou em 26/08, lista de coleta validada campo a campo em 27/08 e completada pelo `D14` em 28/08);
**o `E2` foi escrito, commitado e PUBLICADO em 28/08, e continua sem uma linha de código de
produto.** ✅ **O repositório deixou de estar vazio:** commit raiz **`4622962`**, **23 arquivos**
(`docs/arquitetura.md`, `docs/modelo-de-dados.md`, `docs/triagem.md`, `docs/adr/ADR-001..015` +
índice, `README.md`, `CHANGELOG.md`, `.env.example`, `.gitignore`). Cópia de trabalho em
`C:/Users/Administrator/Desktop/chatbot-suporte-geniai` (limpa e sincronizada). **`E3` desde 28/08:**
esqueleto em camadas + CI **publicados** (`1280f37`, 34 arquivos, 11/11 testes, teste de arquitetura
do domínio puro, formato `D10`). ✅ **A parte que faltava — deploy/ambientes — SAIU DO ESCOPO pelo
`D19` em 07/09.** ⚠️ **Mas se o `E3` está concluído é martelo dele e ele não bateu** — o roadmap ficou
"em curso" de propósito. Stack decidida (`D15`); o `docs/arquitetura.md` publicado é o guia. **Escrevi tudo local e só commitei depois do aval explícito dele** — repo público, publicar é
ato dele; manter essa ordem. Ver [[commits-repos-caue-autor-unico]].

**✅ SESSÃO 2026-09-14/15 — SUPERSEDE os "sem resposta" abaixo.** Ele respondeu as três adiadas:
**E3 FECHADO** (roadmap ✅); **B1 = `0 — voltar` em todo submenu**; **B2 = um nível só** → ADR-022,
árvore `v4` (Nó 3.1), invariante 7 reescrita — commit **`5ce0fac`**. Ao começar a máquina de estados
achei duas lacunas do "só dígito" e ele decidiu: **`9 — Falar com atendente` em todo menu** (máx. 8
opções por menu) e **confirmação do Nó 2 por `1` sim / `2` não** → ADR-023. **Extensão MINHA,
declarada e não batida:** pós-dica `1 resolveu / 2 não resolveu`. Código TDD em `src/domain/triagem/`:
`maquina.ts` (`iniciar`/`avancar`, função pura) e `catalogo.ts` (tipos + `validarCatalogo`) — commit
**`dedd02e`**, 48/48 testes, CI verde, 6 commits só `cauedev30`. Risco registrado não tratado: estado
guarda índice da opção. **Falta:** renderizar texto dos menus, gravar `evento_triagem`, ligar aos
casos de uso. **Matheus:** ele mandou (15/09) as 6 perguntas do conteúdo do FAQ (problemas mais
frequentes por sistema, resolve com orientação?, texto da orientação, se não resolver, agrupamento em
submenu, o que cai em Outros) — **a resposta vai chegar por ele; ao chegar, passar por
`validarCatalogo`.** O contrato do sistema ouvinte do Notion segue pendente com o Matheus, separado.

**✅ SESSÃO 2026-09-07 — `D17`/`D18`/`D19`, tudo publicado (commit `69581f7`, 4º do repo).** A sessão
abriu com as pendências 1-10 (pedido dele) e ele pediu o recorte: *"me diz exatamente o que eu
preciso esclarecer agora"*. Três dos dez itens travavam trabalho de verdade e fecharam:

- **`D17` — o ticket canônico é a linha `chamado` no Postgres do bot**, com o **id viajando no link
  do formulário**; o Notion recebe **só o formulário preenchido** (ADR-019). ⚠️ **Isso derrubou uma
  consequência escrita da ADR-018** ("o bot ganha uma escrita nova" no Notion): **na Fase 1 o bot não
  escreve no Notion**. A *decisão* da 018 segue intacta, e a correção foi **declarada em ADR nova**,
  nunca editando a antiga. **Dois efeitos de graça:** nenhum terceiro escreve no caminho síncrono
  (o SLA de 3 s passa a depender só do banco local) e o **fallback do Notion fechou sozinho**.
- **`D18` — no `P3`, quem sai é identificado por texto livre no formulário** (nome completo +
  identificação adicional opcional); **quem traduz nome para conta é o humano que executa** (ADR-020).
  Risco aceito: homônimos na mesma unidade obrigam uma volta ao cliente.
- **`D19` — sem Docker, sem empacotamento e sem deploy neste repositório** (ADR-021). **Ele perguntou
  antes de decidir**, eu **argumentei a favor** do Docker (contrato da entrega; Docker ≠ Dokku, dava
  para fechar empacotamento sem decidir hospedagem; testes contra Postgres real) e **ele decidiu
  contra com razão de peso:** a aplicação provavelmente vai para **outro desenvolvedor** que já tem
  plataforma e servidor próprios (*"nem ter o trabalho de manter"*, *"ele que vai decidir em qual
  servidor vai ficar hospedado e qual domínio"*). **Não foi o Docker que foi recusado — foi construir
  algo que seria descartado na chegada.** O ciclo vira **rodar local e publicar no GitHub**, e o
  **`README` § Como rodar virou o contrato da entrega** (com `.nvmrc` novo).

**✅ A PERGUNTA DO MENU FOI RESPONDIDA em 07/09: o menu é MISTO** — algumas opções levam **direto** ao
destino (dica de FAQ, coleta, "Outros") e outras **abrem submenu**. Ele disse *"ambos"*, que era
ambíguo; **eu perguntei qual das duas leituras era em vez de escolher** e ele confirmou *"pode ser a
1"*. ⚠️ **Isso abriu duas sub-perguntas que ELE ADIOU** (*"próxima sessão resolvo isso"*), ambas
decisão dele: **(B1) como se volta de um submenu** — sem saída explícita, quem erra fica preso e a
**invariante 7 quebra**; minha recomendação **não batida** é `0 — voltar` em todo submenu. **(B2)
profundidade** — recomendação **não batida**: um nível só. **⚠️ NADA DE SUBMENU ESTÁ NO REPO:** não
existe ADR-022, a árvore `v3` segue com **menu único** e a invariante 7 não mudou.

**⚠️ FECHAR O `E3`? CONTINUA SEM RESPOSTA em 07/09.** Com o `D19` era a única parte que faltava, mas
**deixei o roadmap como "em curso" de propósito** — fechar etapa é martelo dele. **Não tratar como
aprovado por silêncio.**
**Aberto novo que é VERIFICAÇÃO, não decisão dele:** se o formulário do Notion aceita campo
**pré-preenchido por URL** — sem o id do chamado no form, o sistema ouvinte não faz a junção. E
**testes contra Postgres real sem compose** (banco na máquina, `services: postgres` no CI, ou mock no
`E10`) — **não mexi no CI**, que estava verde.

**⚠️ O QUE O PRODUTO É (`D6`, 26/08) — leia antes de qualquer desenho: o bot NÃO executa nada nos
sistemas dos clientes.** Ele identifica quem fala, descobre o sistema, afunila o sintoma, responde
dúvida conhecida e **entrega o chamado mastigado**. Adicionar/remover atendente e mexer em número
continuam **manuais**, feitos por ele e pelo Matheus. Palavras dele: *"Não é para o bot ter a
permissão de apagar, adicionar alguém ou qualquer que seja a opção."*

**Não é o mesmo projeto que [[chatmultgni-patos-cadastrado]] & cia.** Aquilo é a *Automação Chatwoot
GeniAI* (n8n operacional: provisionar atendente, time, regra). O Tier 0 é produto de software novo,
repo próprio: **`https://github.com/cauedev30/chatbot-suporte-geniai`** — criado 26/08, **público**,
`main`, **4 commits e CI verde** (a linha antiga dizia "vazio" — correto só até 28/08). ✅ **Resolvido pelo `D11` em 27/08:** é
público **de propósito**, fica na **conta pessoal `cauedev30`** e o **Matheus está alinhado**. Não
perguntar de novo.
Clean/Hexagonal com adapters isolando WhatsApp/Chatwoot/Notion, PostgreSQL, Python só para IA.
KPI duro: resposta < 3s.

**Decisões fechadas:**

- **`D1` (21/08) — identificação é SÓ pelo número de telefone.** O escopo escrito pede três fatores
  (número, nome, unidade) — **supersedido, não implemente três fatores.** Nome e unidade vêm da base,
  não são perguntados; servem para confirmar em voz alta e rotear.
- **`D2` (21/08)** — número não reconhecido cai em humano, nunca em autoatendimento.
- **`D3` (24/08) — o suporte sai dos grupos de WhatsApp e vira 1:1 no `+55 83 99995-0223`.** Hoje um
  iPhone participa de todos os grupos das unidades. **É pré-requisito do `D1`:** em grupo não há
  remetente que autentique uma conversa 1:1.
- **`D4` (24/08, CONFIRMADO 25/08) — a stack é TypeScript.** GO está fora. Reavaliado a pedido dele
  quando entregou uma referência interna em Python: **a Fase 1 é determinística e não tem LLM**, que é
  onde mora o Python específico dela; o que mais vale no repo é **neutro de linguagem**; e a
  referência **já separa o LLM num serviço apartado** — defende a fronteira, não o idioma. **Python
  fica reservado ao serviço de IA da Fase 2.** Muda se ele quiser a Fase 2 junto, num serviço só.
- **`D5` (24/08) — n8n está FORA deste projeto** ("n8n limita o projeto"). Decisão dele, mais forte
  que a minha recomendação. **Escopo: só o Tier 0** — a Automação Chatwoot GeniAI segue em n8n.
  Consequência: o bot fala com a API do Chatwoot direto; a lógica dos workflows `20`/`22` precisa ser
  **portada para TS**, herdando a bifurcação Supabase vs. Caminho B e virando casos de teste do `E10`.
  **⚠️ Corrigido pelo `D6`:** esse port **saiu da Fase 1**. A spec dele continua valendo, mas como
  **lista do que o bot precisa coletar**, não como executor.
- **`D6` (26/08) — o bot não executa nada.** Ver acima. Responde definitivamente a pergunta que ele
  havia adiado em 24/08 e **supersede** o achado que eu havia gravado de que o `E7` seria execução.
  **Gatilho que reabriria:** ele decidir que o bot pode executar — e aí volta junto o risco de
  autorização (`D1` autentica mas não autoriza; `P3` não tem rollback no Chatwoot).
- **`D7` (26/08) — cadastro divergente PARA e chama humano.** Se a pessoa corrigir nome ou unidade na
  confirmação em voz alta, o bot interrompe a triagem e marca `cadastro-divergente`. Eu propus o
  contrário (seguir marcando); ele escolheu o corte mais conservador.
- **`D8` (26/08) — escape hatch sempre disponível.** "Falar com atendente" vale em qualquer nó.
- **`D9` (26/08) — o Tier 0 é TAMBÉM peça de portfólio dele.** Documentação vira **entregável de
  primeira classe**: não adiciona etapa, muda **onde** os artefatos do `E2` nascem — em `docs/` dentro
  do repo, não só no Obsidian. **NÃO autoriza inflar a stack** (Kubernetes/microserviços num bot para
  duas pessoas lê como falta de critério, não como avanço).
- **`D10` (26/08) — padrão de commit obrigatório.** Todo commit documenta **o que foi feito** e
  **quais testes foram feitos** (comando + resultado, ou o motivo de não haver), mais o porquê com a
  ADR. Conventional Commits no cabeçalho. **Nenhum commit sem a seção `Testes`; proibido
  `update`/`wip`.** **Aplicar desde o commit 1** — depois é reescrever histórico. Guia completo em
  `Projects/Active/Tier 0 - Padrao de Commits Documentacao e Portfolio.md`.
- **`D11` (27/08) — repo público, conta pessoal, Matheus alinhado.** Fecha as duas divergências de
  26/08 (*"sim"* e *"sim, vai ficar na minha"*). **Consequência única e dura: a anonimização vira
  crítica** — `Unidade A`, `+55 11 90000-0000`, `<ACCOUNT_ID>` em código, teste, fixture, exemplo e
  doc, **desde o commit 1**. Fica anotado sem recobrar: ativo da empresa preso a pessoa física.
- **`D12` (27/08) — lista de coleta `v1` validada por ele campo a campo.** Era rascunho meu desde
  26/08. **`P1`** (qual número, desde quando, o que já tentaram) e **`P3`** (o bot lista os atendentes
  e a pessoa aponta) **aprovados sem mudança**; no **`P2` o e-mail SAI** (*"a gente pode elaborar o
  e-mail"*) — sobra o **nome completo de quem entra**. Em todas, **unidade e quem pediu vêm da base**.
  **Por que importa:** com o `D6`, a ficha é a única coisa que o bot entrega.
- **`D13` (27/08) — o Design Review do `E2` é ele sozinho, por ora** (*"eu e matheus, mas agora vai
  ser eu msm"*). Responde o `TBD` da "equipe técnica líder". **Risco aceito:** revisão de si mesmo não
  pega erro de premissa. **Combinado: eu faço o papel adversarial, ele bate o martelo.**
- **`D7` reconfirmado em 27/08** (*"deixa como ta"*), depois que levantei que o `P2` colide com ele
  quando alguém pede para adicionar em **outra unidade** — o bot não distingue isso de cadastro
  errado. Qualquer unidade diferente da base **para e chama humano**.
- **`D14` (28/08) — o número de quem ENTRA é campo do `P2`** (*"sim, tem que pedir o numero de quem
  ta entrando"*). O `P2` coleta **nome completo + número**; unidade e quem pediu continuam vindo da
  base e o e-mail continua fora (`D12`). **Ganho maior: o `P2` alimenta a base do `E5` sozinho**, no
  formato exato pedido (número internacional + nome + unidade), **sem violar o `D6`** — o bot só
  coleta, quem escreve continuam sendo ele e o Matheus. **Consequência técnica (leitura minha):** esse
  número é **digitado por humano**, ao contrário do número do remetente, que chega **verificado pelo
  WhatsApp** — **normalização E.164 e o 9º dígito viram regra do `E5` e caso de teste do `E10`**,
  exatamente o ponto que a referência interna não resolveu. **Não confundir com recobrança:** o que
  ele adiou em 21/08 foi a interligação do `E5` com a **remoção** (`P3`), que segue adiada.

**`D16` (29/08) — a conversa vira FAQ de MENU NUMERADO, sem IA; ticket por formulário do
Notion.** Palavras dele: *"o bot vai focar agora em mensagem automatica e registrar no ticket, mas
sem ia por agora"* (motivo: gasto de token e tempo de treino de LLM — **"sem IA" já era a Fase 1**,
o que muda é o formato da conversa e o caminho da entrega). Saudação genérica → escolhe o sistema
(`1`/`2`) → lista numerada; camada 1 = FAQ automático, camada 2 = ticket: **o bot cria o ticket JÁ
AO ENVIAR o link do formulário do Notion** (invariante dele: ticket primeiro, humano — ele ou o
Matheus — assume depois). **Perguntas feitas NA HORA e respondidas:** o **Nó 1 continua** (`D7`
mantém gatilho); **P2/P3 também viram formulário** (a lista `v2` vira campos do form); ticket nasce
no envio do link. A notificação "mastigada" **sai do bot** — o **sistema que o Matheus está
fazendo** escuta o Notion e notifica. Guardrail nova sem mecanismo definido: *"escrevendo coisas
suspeitas que fogem muito do padrão"* → humano. ✅ **Revisão EXECUTADA em 29/08 a pedido dele**
(*"faz a revisão"*): árvore `v3`, ADR-016/017/018 (a 017 supersede o CANAL da 009 preservando os
campos), `TicketPort`/`notion` e `AbrirTicket` no esqueleto — commit **`2ede205`**; **os dois
commits foram PUBLICADOS em 29/08 com o aval dele** (3 commits no repo, API confirma só
`cauedev30`, primeiro run do CI verde). **No repo o Matheus não é
nomeado** ("sistema interno separado" — repo público). Abertos: contagem/conteúdo dos menus,
campos/layout do form, **mecânica do `P3` no form** (a lista "aponta quem sai" não existe em form
estático), onde o ticket mora + vínculo do link, contrato do sistema do Matheus, posição da
confirmação (`no2` provisório), "texto suspeito" sem IA, fallback do Notion.

**O `E1` já produziu:** catálogo de sistemas fechado em **dois** (`Disparador`, `Chatwoot`); três
famílias de problemas (`P1` qualidade do número cai → recomendam planilha/template; `P2` adicionar e
`P3` remover atendente); e a **árvore de triagem `v2`, VALIDADA por ele em 26/08** — o bot tem duas
saídas só: respondeu dúvida conhecida, ou entregou o chamado mastigado. Suporte hoje são duas
pessoas: ele e o Matheus, **que ainda não validou nada disso, por escolha dele (adiado em 25/08)**.

**⚠️ ERRO DE MÉTODO A NÃO REPETIR:** entre 24/08 e 26/08 o vault carregou como premissa um achado que
era **inferência minha, nunca fala dele** — *"`P2`/`P3` não são dúvida, são execução"*. Em cima disso
eu escrevi uma spec de port inteira e levantei um risco de autorização que não existia. Ele desfez
com uma frase. **Achado meu que muda o produto tem que ser confirmado com ele antes de qualquer coisa
ser construída em cima.**

**Fatos do `E1` que mudam o desenho:** o histórico de suporte **não está no Chatwoot**, vive no
WhatsApp dentro dos grupos → o `E1` é **entrevista**, não análise de dado, e o **FCR do piloto será
estimativa, não medida**. **"Dial" é termo do vault, não dele** — ele perguntou o que era; não usar a
palavra com ele.

**Lacuna que levantei e ele não endereçou: o canal não existe.** O Tier 0 pressupõe WhatsApp →
Chatwoot, mas o suporte não passa pelo Chatwoot da GeniAI, e ligar esse canal **não está em nenhuma
das 12 etapas**. Migrar o número para um provider **tira ele do app do iPhone** (excludentes).

**Adiados de propósito por ele (não são pendências, não recobrar):** guardrails de dados sensíveis;
interligar o `E5` com o evento de remoção de atendente; e, desde 24/08, o que o bot responde no `P1`,
se ele pode executar `P2`/`P3` sozinho, se a lista de problemas tem cauda, e a data de saída dos
grupos. **Três desses foram resolvidos em 26/08 sem precisar dele:** o texto do `P1` é **conteúdo**
(tabela versionada com `is_active`), não estrutura da árvore; "executa sozinho?" morreu com o `D6`; e
a cauda sai do nó `outro -> humano` **instrumentado**, que descobre a cauda por dado e é o único
caminho realista para o baseline de FCR. Ver [[notas-sem-pendencia-arrastada]].

**Pendência dele em aberto (sem cobrança), estado em 27/08:** a **base de números** do `E5`
(formato: número internacional + nome + unidade) — perguntada em 26/08 e **de novo em 27/08, ainda
não montou**. **Não bloqueia o `E2` e não é para perguntar uma terceira vez.** ✅ **Aliviada em parte
pelo `D14`:** cada `P2` passa a alimentar essa base sozinho, mas **os atendentes que já existem
continuam só na mão dele** — a carga inicial segue sendo dele.


**⚠️ A PERGUNTA DO "FALLBACK" FOI RETIRADA POR ELE EM 28/08, SEM DECISÃO** (*"deixa isso pra la"*).
**Não é escolha da Leitura A.** `D1` e `D2` seguem intocados e o desenho vigente vale **porque já era
o desenho**. **Se o tema voltar, perguntar de novo** — registrar como escolha dele repetiria o erro de
24–26/08. Ver [[inferencia-minha-nao-e-fala-dele]].

**✅ A STACK FOI DECIDIDA em 28/08 (`D15`).** *"Pode prosseguir com as suas recomendações. Eu gostei
das escolhas e é isso. Qualquer coisa a gente muda algo no meio do processo."* — **Fastify** (HTTP),
**Zod** (borda), **PostgreSQL + Drizzle**, **Vitest**, **WhatsApp Cloud API oficial** com inbox
nativo do Chatwoot, e **sem cache e sem fila** na Fase 1. Apresentei cada uma com o **contra** junto
(papel adversarial do `D13`). **A que mais pesa é a do WhatsApp:** número de suporte **único**, e a
alternativa não oficial arrisca **banimento sem plano B**. **Troca futura vira ADR novo que
supersede**, nunca edição do antigo.

**⚠️ Três coisas do `E2` declaradas, NÃO assumidas em silêncio — mencionar na retomada:** (1) o
**`pino`** (log estruturado) entrou **sem passar pela pauta das seis escolhas**, por vir integrado ao
Fastify; (2) **o nome da empresa não aparece no `README`** — chamá-la pelo nome é decisão dele; (3)
escolha de estilo minha: os docs **nomeiam as ferramentas** (WhatsApp, Chatwoot, Notion, n8n,
PostgreSQL) e anonimizam **só dado de cliente**, porque a regra do `D11` enumera unidade, telefone e
`account_id` e nome de ferramenta não está nela. Todas reversíveis com find/replace.

**Portfólio, minha leitura registrada (`D9`):** o **padrão arquitetural NÃO é o diferencial** —
Clean/Hexagonal já está no escopo e é piso. **O diferencial são as ADRs `D1`–`D8`**: o `D1`/`D2` é
autenticação **com modelo de ameaça explícito** (raro em portfólio) e o `D6` **reduziu escopo** — isso
lê como **julgamento**. Somam os **13 casos de teste do `E10` vindos de bugs reais** e ser **produto
real de empresa real**. O `E2` já produz o material: basta nascer em `docs/`.

**Why:** as duas frentes vivem no mesmo Chatwoot e têm nome parecido; confundir faz eu propor n8n
onde ele quer serviço próprio — e desde o `D5` propor n8n aqui é contrariar decisão explícita dele.
O escopo escrito também diverge do decidido no ponto mais sensível do produto (o `E5`), então quem
ler só o escopo implementa a coisa errada.

**⚠️ Precedente que contradiz o `D1`, achado em 2026-08-21 e ainda NÃO conversado com ele:** o projeto
`Consulta Pontual de Clientes n8n` já tentou essa mesma identificação por WhatsApp — decidiu telefone
como chave em 2026-05-06 e **reverteu** em 2026-05-08 para `Unidade` + `Nome`, **sem registrar o
motivo**. Ganhou peso em 24/08: uma hipótese da reversão é "a plataforma de disparo não expõe o
remetente", e o Disparador é agora um dos dois sistemas. Perguntar por quê antes de implementar o `E5`.

**Referência interna (entregue 25/08):** `agente-imobiliario.rar` — agente de WhatsApp em produção
feito por outro dev da GeniAI para um cliente imobiliária. Análise em
`Projects/Active/Analise - Agente Imobiliario como referencia para o Tier 0.md`. **Valida o `D5`** (a
v3 deles eliminou o n8n — a empresa já fez essa migração). **Dois achados que mudam o desenho:** o
"CRECI gate" deles **não é gate** (vive no prompt, o executor de tools não checa nada) → nosso
`D1`/`D2` tem que ser `if` em código no passo 1; e **o 9º dígito não está resolvido lá** (12 e 13
dígitos convivem) → com o `D1` isso recusa gente de verdade. Ele fixou: **extrair desenho, não
código; uso interno com modelo simples; sem acesso ao dev.**

**How to apply:** retomar por `Knowledge/Prompt de Entrada e Retomada - Tier 0 Chatbot de Suporte
GeniAI.md`; a nota do projeto é `Projects/Active/Tier 0 - Chatbot de Suporte GeniAI.md` (ele se refere
a ela como "projeto chatbot") — ler a seção `## Sessão 2026-08-28` PRIMEIRO, ela é a mais recente.
**Ele pediu que a sessão ABRA dizendo qual é o próximo passo**, sem redescobrir nada. Depois de
07/09 esse passo é **ABRIR COM AS DUAS PERGUNTAS QUE FICARAM SEM RESPOSTA** (fechar o `E3`? menu com
destino direto ou submenu?) e só então a lista renumerada de pendências, que está no bloco do prompt
de retomada: dele — estrutura e texto dos menus, campos do formulário, fechar o `E3`; do Matheus —
contrato do sistema ouvinte; verificação (não decisão) — campo pré-preenchido no form do Notion e
testes contra Postgres real; provisórios meus — posição da confirmação, não-identificado sem form,
"texto suspeito" sem IA. **Saíram da lista por estarem fechados:** onde o ticket mora (`D17`),
mecânica do `P3` (`D18`), deploy/ambientes (`D19`) e fallback do Notion (caiu com o `D17`).
Depois, `E4`–`E9`. **Não presumir aprovação por silêncio** — foi assim que a lista de
coleta ficou dois dias parecendo validada em 26/08. Aplica-se aqui o [[um-passo-de-cada-vez]] e o [[inferencia-minha-nao-e-fala-dele]].
