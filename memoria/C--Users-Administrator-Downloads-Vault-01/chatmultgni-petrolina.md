---
name: chatmultgni-petrolina
description: "CDT Petrolina no Chatwoot é a conta 112; SA 482 é só agent, bot 397 é o único administrator, e o Platform App não alcança a conta"
metadata: 
  node_type: memory
  type: project
  originSessionId: f9981b5f-29a6-4878-8bce-66a9c6b5d6eb
  modified: 2026-08-28T02:36:45.111Z
---

CDT Petrolina = conta **112** (`CDT Petrolina`, criada 2026-08-11), instância `appchatfvk.geniai.online`.
Não confundir com a LP `saudepetrolinape.online` ([[lp-petrolina-cdt]]) — projetos diferentes, mesmo cliente.

Estado em 2026-08-27: conta praticamente vazia — zero times (nem `triagem`), zero inboxes, zero labels,
zero automation rules. Só dois usuários: **482** (`contato@saudepetrolinape.online`, "Super Admin CDT
Petrolina", `type: SuperAdmin` mas papel **`agent`** na conta) e **397** (`Central Gateway Bot`,
**`administrator`** — o único admin da conta).

**Why:** o token do 482 parece o certo pelo nome e não é. `type: SuperAdmin` dá o console `/super_admin`,
mas quem autoriza escrita de conta é o papel no `account_user`. Com o 482 dá 200 em `/agents`, `/teams`,
`/labels`, `/canned_responses` e **401 em `/automation_rules` e `/webhooks`**.

**How to apply:** para escrever na 112, usar o `access_token` do bot 397 (visível em
`/super_admin/access_tokens`, linha `User #397`, token id 461). O Platform Token do
`conciliation-team-creator` **não serve aqui**: a 112 foi criada fora daquele Platform App, então dá
`401 Non permissible resource` na conta, no usuário 482, no bot 397 e no
`POST /platform/api/v1/accounts/112/account_users` (testado). Isso é o oposto da 113/114, que o app criou
e portanto alcança. Ver [[adicionar-acesso-chatwoot-playbook]].

Achados de rota do console (build 4.11.4): `/super_admin/access_tokens` e `/super_admin/platform_apps`
**existem**; `/super_admin/account_users` dá 404 — não dá para mudar papel de conta pelo console.

## FEITO em 2026-08-27 — 6 acessos provisionados e conferidos por API

SA **482 promovido a `administrator`** (era `agent`) — a partir daqui o token dele já serve, não precisa
mais do bot 397 para escrever. Agentes criados, todos `confirmed`, role `agent`, enter-to-send ligado:
**501 Gestor, 502 Joice, 503 Kelly, 504 Samara, 505 Gerriane, 506 Viviane**, e-mails
`{slug}cdtpetrolinape@geniai.online` (o gestor é `gestao`, não `gestor`), nome `{Nome} CDT PETROLINA`,
display name só o primeiro nome. Times: **424 `triagem`** (os 6 + 482 + 397) e pessoais **425-429**
`atendimentos {nome}` (atendente + 482 + 397 + gestor 501). Regras **515-520**: `Triagem - entrada`
(`conversation_created` + `status open` -> 424) e `Atendimentos {Nome}` (`conversation_updated` +
`assignee_id` -> time pessoal), **sem condição de `inbox_id`**, molde da 113 copiado campo a campo.

**O inbox apareceu no meio da sessão:** **273 `cdt_petrolina_dial0011`** (`Channel::Api`,
`enable_auto_assignment: false`), que estava ausente na primeira leitura. Os 8 foram somados como
membros dele. **Nada testado ponta a ponta** — zero conversas até agora.

O gestor 501 entrou como `agent`, não `administrator` — enxerga todo mundo por estar dentro de todos os
times, igual à Daiane 491 na 113. Se ele pedir gestor administrador, é um `PATCH /agents/501`.

**Gotcha da rede dele (pode voltar):** um FortiGate (`FG6H0ETB20904108`) estava fazendo inspeção de TLS só em
`appchatfvk.geniai.online` e `managern8neditorfvk.geniai.online` — GitHub/Google/Supabase passavam
limpos. O schannel do curl recusa o handshake (`SEC_E_UNTRUSTED_ROOT`, `http:000`), então **nenhuma
requisição chega ao servidor** e não há risco de escrita pela metade. Ele disse que resolve ao chegar
em casa. **Nunca contornar com `-k`** — seria entregar o token de admin em texto claro ao aparelho.
Diagnóstico rápido: `openssl s_client -connect appchatfvk.geniai.online:443 | openssl x509 -noout
-issuer` — Let's Encrypt = ok, Fortinet = rede errada. Ver [[consulta-por-api-nao-navegador]].
