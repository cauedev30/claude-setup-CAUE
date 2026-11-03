# Pré-sombra no Chatwoot do JP Sul e o Jev real (etapas 10 e 11)

## Contexto

A sombra ao vivo precisa de um servidor (T2), e o Cauê não tem acesso a um. A saída é a
**pré-sombra**: um comando, rodado na máquina do Cauê, que lê pela API do Chatwoot as conversas dos
últimos 3 dias da inbox do JP Sul e as passa, mensagem a mensagem, pelo mesmo caminho do serviço, em
modo sombra. O resultado é o que o agente teria decidido em cada turno, ao lado do que o atendente
respondeu de verdade. Decidido com o Cauê em 2026-10-29: as conversas entram **cruzadas com a carteira
em CSV** (pelo telefone, como na produção), e as sugestões aceitas valem (o áudio e o redator ficam de
fora até a retenção da OpenAI; a revisão de uma amostra pelo Cauê como critério).

A ordem fica **pré-sombra primeiro (etapa 10), com o Jev falso**, porque o token do Chatwoot chega
antes da chave da Vercel; a etapa 10 já testa a leitura, o cruzamento, os gates e a janela. A **etapa
11** liga o Jev real pela API HTTP da Vercel (`POST /v1/evaluate`, T10) e roda a pré-sombra de novo,
agora com laudos que servem para calibrar.

**O que não prova:** o caminho ao vivo (webhook, rajada concorrente, atendente digitando junto). A
sombra ao vivo continua sendo a etapa seguinte quando houver servidor.

## Spec

**Entra:**
- leitura **só GET** do Chatwoot: as conversas da inbox com atividade nos últimos N dias (padrão 3) e
  as mensagens de cada uma;
- a carteira importada de um CSV pelo `importar_carteira` que já existe; a conversa sem cobrança ativa
  para o telefone é ignorada, como no webhook (`sem_cobranca`);
- a reprodução em ordem de tempo, com relógio falso, pelo `receber_evento` e pelo `Trabalhador`:
  rajada, janela, humano na conversa e teto como na produção;
- o modo **sombra**: só o Jev 1 e 2 rodam; nada de redator, Jev 3, link, Pix ou envio;
- um relatório agregado, sem dado pessoal (é o que o Claude lê), e uma **folha de revisão** local
  para o Cauê, com as mensagens mascaradas e uma coluna para o veredito.

**Fica de fora:** o áudio (fica "não ouvido": a transcrição usa a OpenAI, e a retenção não foi
confirmada); o redator (não roda em sombra); qualquer escrita no Chatwoot (o turno usa o
`ChatwootFalso`); a recusa do modo ativo (não muda nesta etapa).

**LGPD e dados:**
- o token do Chatwoot é de um usuário de agente só da inbox do JP Sul, em
  `secrets/chatwoot.local.json` (`url`, `conta`, `inbox`, `token`); a chave da Vercel em
  `secrets/vercel.local.json`;
- o banco SQLite, a folha e o CSV ficam em `pre-sombra/` no workspace, fora do git (`.gitignore`);
- o Claude só lê o relatório agregado; a folha é do Cauê;
- o Jev real vai com `zeroDataRetention: true` e `only: ["typesafe-ai"]` (D12).

**Critério de "passou" (sugestão aceita):** o Cauê revisa 50 turnos da folha; nenhuma decisão
perigosa (cobrar quem disse que já pagou, deixar passar golpe, jurídico ou retenção, prometer
condição fora da política). O resto vira ajuste de limiar ou de pergunta do Jev.

## Plano

Regras de sempre: subagente **Sonnet 5.5, esforço high**, com o ok do Cauê (subagente, não teammate:
tarefas fechadas, ninguém conversa); revisão **Opus** uma vez no fim de cada etapa; conferência curta
só na correção que mexer em estado da conversa; commit local em pt-BR com o autor `cauedev30`; push só
com o ok. As tarefas 10.1 a 10.3 vão num subagente só (mesma área, lê o código uma vez).

### Etapa 10 — Pré-sombra

**10.1 Leitura do Chatwoot** — `src/agente/reproducao/chatwoot_leitura.py` (novo)
- `ChatwootLeitura(url, conta, token)`: `conversas(inbox_id, desde) -> list[ConversaLida]`
  (id, telefone do contato, criada e última atividade), paginando `GET /conversations?inbox_id&status=all&page`
  até a atividade passar de `desde`; `mensagens(conversa_id) -> list[dict]`, paginando
  `GET /conversations/{id}/messages?before=`.
- A classe não tem método de escrita; o teste confere que só sai GET.
- *A confirmar com o Chatwoot real:* os campos do payload (o `message_type` numérico, o tipo do
  remetente, o telefone em `meta.sender`). O teste usa payloads do formato documentado.
- Testes: `httpx.MockTransport`, paginação, corte pela data, conversa sem telefone.
- Pronto quando: a leitura devolve as mensagens em ordem e nunca faz pedido que não seja GET.

**10.2 Adaptador para o webhook** — no mesmo módulo
- `para_evento(mensagem, conversa) -> dict`: a mensagem da API no formato do `message_created`
  (`message_type` 0/1/3 → incoming/outgoing/template, `sender.type`, `conversation.id`, anexos), para
  reusar `ler_evento` e `receber_evento` (`api/chatwoot_webhook.py`) sem caminho novo.
- Testes: incoming, outgoing do atendente (vira HUMANO), nota privada e atividade ignoradas, áudio com
  anexo.
- Pronto quando: as mensagens de uma conversa de exemplo viram os mesmos registros que o webhook grava.

**10.3 A reprodução** — `src/agente/reproducao/reproduzir.py` (novo)
- `reproduzir(leitura, carteira_csv, desde, banco, politica, config, jev=None) -> RelatorioReproducao`:
  migra o banco SQLite, importa a carteira (`carteira/importar.py`), junta os eventos das conversas
  em ordem de `created_at` e, antes de cada um, roda o `Trabalhador.rodar_uma_vez` (`turno/fila.py`)
  com o relógio no tempo do evento; no fim, avança a rajada e roda o que sobrou.
- Dependências do turno: `Modo.SOMBRA`, `ChatwootFalso`, `CTNFalso`, `PixFalso`, sem transcritor, e o
  Jev recebido (o `JevFalso()` por padrão).
- `RelatorioReproducao`: conversas lidas, cruzadas com a carteira, mensagens, turnos por resultado,
  por ação e por gatilho, adiados pela janela, erros por tipo. Sem texto nem telefone.
- Testes: uma conversa de exemplo do começo ao fim; telefone fora da carteira; atendente na conversa;
  mensagem fora da janela; o Chatwoot falso não recebe nada.
- Pronto quando: a reprodução de exemplo grava os turnos em sombra e o relatório bate com eles.

**10.4 Folha de revisão** — `src/agente/reproducao/folha.py` (novo)
- `escrever_folha(sessao, caminho, amostra=50)`: um bloco por turno, sorteado com semente fixa, com a
  mensagem do cliente (`logs.mascarar`), a decisão (ação, anexos ou gatilho, números previstos) e a
  resposta seguinte do atendente (mascarada), mais `Veredito: ok | errado | perigoso` e `Nota:`.
- Testes: a máscara do telefone e do CPF; a amostra respeita a semente.

**10.5 Comando** — `src/agente/cli.py`
- `agente reproduzir --carteira CSV --dias 3 --saida PASTA`, com o Chatwoot pelas variáveis
  `AGENTE_CHATWOOT_*` que já existem; imprime o relatório agregado e o caminho da folha.
- `.gitignore` do workspace ganha `pre-sombra/`. README: uma seção curta.
- Pronto quando: o comando roda contra o `MockTransport` no teste e a suíte e o ruff passam.

**PARADA 10:** rodar com o token real e o Jev falso. O Claude lê o relatório agregado e ajusta o
adaptador ao payload real, se preciso. O Cauê confere se as conversas cruzadas são mesmo as de
cobrança. Revisão Opus da etapa.

### Etapa 11 — Jev real (T10)

**11.1 Cliente** — `src/agente/integracoes/jev.py`
- `JevVercel(chave, url="https://ai-gateway.vercel.sh/v1", timeout)`: `avaliar(perguntas, estado)`
  manda um `POST /evaluate` com todas as perguntas do batch (`boolean` ou `choice`, com `criteria`), o
  `estado` como objeto e o `providerOptions` da LGPD; devolve um `Laudo` por pergunta, na ordem;
  a falha, o status não 2xx e a resposta fora das opções levantam `JevIndisponivel`; `origem =
  "typesafe-ai/jev"`.
- *Decisão em aberto:* a semântica da probabilidade de cada laudo frente ao `ContratoJev` (a
  arquitetura pede conferir); o timeout do cliente fica abaixo do `jev_timeout_ms`.
- Testes: herdar `ContratoJev` com `MockTransport`; um teste real marcado, pulado sem a chave.

**11.2 Ligar** — `config.py` e `api/principal.py`
- `AGENTE_JEV_API_KEY` (e `AGENTE_JEV_URL`): com a chave, `montar_dependencias` usa o `JevVercel`;
  sem, o falso. A recusa do modo ativo fica como está, até a calibração.
- `agente reproduzir` e `agente simular` aceitam o Jev real pela mesma variável.

**11.3 Rodar com o Jev real**
- `agente simular tests/conversas` com o Jev real (os acertos por pergunta mostram a distância dos
  limiares) e a pré-sombra de novo.

**PARADA 11:** o Cauê revisa os 50 turnos da folha pelo critério acima. Revisão Opus da etapa.
Atualizar a T10 em `integracoes.md` e `duvidas.md`.

### O que o Cauê precisa trazer
- o CSV da carteira do JP Sul, em `pre-sombra/` (antes da 10.5 rodar de verdade);
- `secrets/chatwoot.local.json` com o token do usuário restrito à inbox;
- `secrets/vercel.local.json` com a `AI_GATEWAY_API_KEY` (antes da 11.3).

### Depois da aprovação
- a spec vai para `specs/2026-10-29-pre-sombra.md`, e as etapas 10 e 11, com o checklist, para
  `specs/planos/2026-10-22-plano-implementacao.md`;
- o Claude pede o ok para mandar a 10.1 a 10.3 ao subagente.

## Verificação
- `python -m uv run pytest`, `ruff check .` e `ruff format --check .` dentro de `repo/`;
- teste ponta a ponta do `reproduzir` com conversas de exemplo no `MockTransport`, conferindo que o
  `ChatwootFalso` não recebeu nada e que só saiu GET;
- PARADA 10 e 11 com os dados reais, lendo só o relatório agregado.

## Checklist
- [ ] 10.1 Leitura do Chatwoot (só GET)
- [ ] 10.2 Adaptador para o webhook
- [ ] 10.3 A reprodução
- [ ] 10.4 Folha de revisão
- [ ] 10.5 Comando `agente reproduzir`
- [ ] PARADA 10 (token real, Jev falso, revisão Opus)
- [ ] 11.1 Cliente `JevVercel`
- [ ] 11.2 Ligar pela `AGENTE_JEV_API_KEY`
- [ ] 11.3 Simulação e pré-sombra com o Jev real
- [ ] PARADA 11 (revisão dos 50 turnos pelo Cauê, revisão Opus)
