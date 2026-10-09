---
name: chatmultgni-tucurui
description: "Tucuruí é a conta 15 do Chatwoot GeniAI; provisionamento oficial funciona, mas o cadastro aponta pro inbox errado e o time pessoal nasce sem supervisão"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5286aeae-0acd-4928-93ee-a45333d73341
  modified: 2026-08-24T00:00:00.000Z
---

CDT Tucuruí = conta **15**, `unit_slug` `cdt_tucurui`, triagem **30**. Inboxes vivos: **207** (principal)
e **227**. O cadastro no Supabase aponta pro inbox **98**, que não é o vivo — então todo agente novo
precisa ser adicionado à mão aos 207 e 227 depois do workflow (`POST /accounts/15/inbox_members` com a
lista completa: atuais + novo). **Ofereci corrigir o `inbox_id` em 2026-08-12 e ele preferiu não mexer** —
não reabrir sem ele pedir.

Provisionados pelo workflow `20`: **Moziane Dos Santos** em 2026-08-12 (agente 483, time 409, label 122,
regra 497) e **Ingrid Vitória** em 2026-08-14 (agente 485, time 411, label 124, regra 501). Nos dois casos
**ele criou o login no Super Admin antes** — o `20` não cria agente. Ele escolhe a grafia do `agent_name`
(que batiza time/label/regra permanentemente) **igual ao `available_name` do Chatwoot** — foi assim nas
duas; perguntar mesmo assim, não deduzir do e-mail. Os dois padrões de e-mail convivem na conta
(`...cdttucurui@` e `...cdttucuruipa@`); não "corrigir".

**Supervisão: ele quer a gestão dentro do time pessoal** — "a gestão tem que ver" (2026-08-14). O membro
certo aqui é o **37 `Gestão CDT Tucurui PA`** (administrator), presente em todos os times pessoais antigos
da conta; o `48 Vanessa Oliveira` aparece em 4 dos 8 e não nos mais recentes — não incluir sem perguntar.
**O workflow `20` nunca adiciona oversight** (409, 410 e 411 nasceram sem); é lacuna do workflow, não da
conta. O 409 da Moziane continua sem — não mexer, é outro caso.

**Prova funcional (2026-08-12):** o padrão de regra que o workflow cria (`message_created` + `team_id` +
`outgoing` + `assignee_id` → `assign_team`) **funciona em produção na conta 15** — Geovana 5/5 conversas no
time pessoal, Maira 2/3. Não repetir a ressalva "validação só estrutural" para o mecanismo; ela vale
apenas para o atendente novo até a primeira conversa cair. Nesta conta atendente comum recebe conversa
(diferente da conta 105), mas quem entrou recente recebe pouco. **Aqui não há alinhamento pós-execução**
(diferente de Mossoró/Ananindeua/Fortaleza, que usam `conversation_updated`).

**Sessão 2026-08-24 (Caminho B, sem o workflow `20`):** provisionadas **Leyliane Da Silva** (agente 497,
time 421, regra 512) e **Beatriz Vilena** (agente 498, time 422, regra 513), as duas com a gestão 37 no
time pessoal e nos inboxes 207/227. Ele escreveu "Laysiane" na hora de liberar o acesso e, questionado,
confirmou que o certo era "Leyliane" (foi engano de digitação dele) — **vale segurar a liberação e
perguntar quando a grafia divergir da que batizou o e-mail**, que é permanente. E **removida a
Rosana (49)**: 59 conversas vivas redistribuídas entre Leyliane/Beatriz/Maira/Vitória Lourane (19/19/18/18
de carga final), time 32 e regras 53 e 59 apagados, agente removido só da conta 15 (login preservado na
instância). O `DELETE /agents/{id}` já tira a pessoa de todos os times e inboxes sozinho — não precisa
limpar um a um antes.

**A conta não resolve conversa — `all_count` de "open" não é fila.** A Rosana tinha **1.316 abertas e só
59 com atividade nos últimos 7 dias**; a Daiana tem 1.135 abertas com 913 paradas há mais de 30 dias. Ao
avaliar remoção, medir **staleness**, não o total: filtro `last_activity_at` + `days_before` devolve as
**paradas** há mais de X dias, então a fila viva é `all_count - days_before(7)`, ou paginar o
`/conversations/filter` e cortar por `last_activity_at` no cliente (mais exato: o `days_before` deu 64 e a
contagem real foi 59). Ele escolheu redistribuir **só as vivas** e deixar o acúmulo antigo sem dono.

**Regra órfã não tratada (achada em 2026-08-24, ele não mandou corrigir):** a regra **60 `DISPARO VITORIA`**
está **ativa** com gatilho `content = "FALAR COM BEATRIZ"` apontando para `assign_agent 217` e
`assign_team 33` — **os dois não existem mais na conta**. Nome de uma pessoa, gatilho de outra, destino
inexistente. Isso **bloqueia criar o DISPARO da Beatriz nova (498)**: o gatilho colide. Se ele pedir o
DISPARO dela, decidir antes o que fazer com a 60. Não reabrir sem ele pedir ([[um-passo-de-cada-vez]]).

Fatos operacionais que economizam tempo:

- **A regra `DISPARO {NOME}` ele quase sempre acaba querendo — mas pergunte.** É a rota de campanha
  (`content equal_to "FALAR COM {NOME}"` → `assign_agent` + `assign_team`), pula a Triagem. Moziane (498)
  e Ingrid (502). Na Ingrid ele **recusou na primeira oferta e pediu na hora de mandar o acesso pro
  cliente** — o gatilho da decisão é a liberação, não o provisionamento. Clonar as válidas (498, 59, 58,
  63), que não têm trava de inbox; primeiro nome só. Igualdade **exata**: o template tem que mandar o
  texto sem sobra.
- **Antes de liberar acesso ele pede auditoria** (fez nas duas): login `confirmed`/role/custom role,
  inboxes vivos com `enable_auto_assignment` e o agente dentro, nenhuma outra regra mencionando o id,
  Triagem + time pessoal. Rodar sem ele pedir quando a pergunta for "posso mandar pro cliente?".
- **Disparo do workflow pela UI: `Ctrl+Enter`** — clicar em "Execute workflow" não disparou em 2026-08-12.
  E execução bem-sucedida do `20` não aparece em `GET /executions`, só as que falham — conferir sempre no
  Chatwoot/Supabase.
- **`POST /teams/{id}/team_members` soma à lista, não substitui.** E **`GET` do mesmo endpoint devolve
  array puro, sem envelope `payload`** — diferente de `/labels` e `/automation_rules`. Parsear com
  `resp.payload || []` dá falso negativo de "time vazio" (errei assim em 2026-08-14).
- **`POST /conversations/filter` devolve 25 por página.** O total está em `meta.all_count`, não em
  `payload.length` — errei assim em 2026-08-14 (reportei 25 conversas da Geovana quando eram 26). Paginar
  até vir menos de 25, ou usar o `meta.all_count`. Vale para qualquer contagem de conversa.
- **Antes de remover um atendente, checar as conversas abertas dele.** Na Geovana eram 26 vivas; apagar
  time+agente deixaria tudo sem dono. **Ele quis redistribuir entre as mais leves** — decidiu em um minuto
  quando levei a tabela de carga real por atendente, não a pergunta solta. Reatribuir é
  `POST /conversations/{id}/assignments` duas vezes (`assignee_id`, depois `team_id`).
- **PAT `sbp_` deu 28P01 de novo em 2026-08-24 — e não precisou pedir token novo.** Contorno em
  [[supabase-sbp-contorno-postgrest]]: pegar a service_role key em `/v1/projects/{ref}/api-keys?reveal=true`
  e consultar pelo PostgREST. Duas chamadas, sem interromper ele.
- **O projeto Supabase pausava sozinho** (2026-08-03 e 2026-08-12); ele decidiu em 12/08 deixá-lo ativo de
  propósito e em **2026-08-14 estava `ACTIVE_HEALTHY` na chegada** — a decisão pegou. Se pausar de novo é
  regressão. O n8n reporta como "incorrect host (domain)", diagnóstico enganoso; o real é status
  `INACTIVE`. Reativar via `POST /v1/projects/{ref}/restore`, pedindo autorização.

Relacionado: [[chatmultgni-ananindeua]], [[chatmultgni-fortaleza]], [[chatmultgni-patos]],
[[chatmultgni-ze-andre]], [[um-passo-de-cada-vez]], [[notas-sem-pendencia-arrastada]],
[[consulta-por-api-nao-navegador]], [[supabase-sbp-contorno-postgrest]].
