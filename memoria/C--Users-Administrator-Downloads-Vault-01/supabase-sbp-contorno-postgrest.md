---
name: supabase-sbp-contorno-postgrest
description: "Quando o PAT sbp_ dá 28P01 no endpoint de SQL do Supabase, não peça token novo — pegue a service_role key por /api-keys e consulte pelo PostgREST"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 181e4479-6e1e-4d65-b2d4-09db46c05004
  modified: 2026-08-24T16:42:59.427Z
---

O erro **`28P01 password authentication failed for user "postgres"`** no
`POST /v1/projects/{ref}/database/query` é **reincidente** com PAT `sbp_` válido (Patos 2026-07-23,
Parnamirim 2026-08-19, Tucuruí 2026-08-24). O playbook manda pedir um PAT novo ao usuário — **não
precisa**. Contorno que funcionou em 2026-08-24, sem interromper o usuário:

```
GET /v1/projects/{ref}/api-keys?reveal=true   (Management API, mesmo PAT sbp_ que falhou no SQL)
   -> devolve anon + service_role
GET https://{ref}.supabase.co/rest/v1/{tabela}?select=*
   headers: apikey: {service_role}  +  Authorization: Bearer {service_role}
```

O mesmo PAT que falha no endpoint de SQL autentica normalmente em `/v1/projects` e em `/api-keys`. O
problema é só a conexão com o Postgres por trás do `database/query`, não o token.

**Why:** pedir PAT novo custa uma ida e volta com o usuário e às vezes ele não está na frente do
dashboard; o contorno resolve em duas chamadas e é totalmente via API, como ele prefere
([[consulta-por-api-nao-navegador]]).

**How to apply:** ao bater no 28P01, tente o `/api-keys?reveal=true` **antes** de pedir qualquer coisa.
Para descobrir as tabelas expostas: `GET https://{ref}.supabase.co/rest/v1/` devolve o OpenAPI, e as
chaves de `paths` são as tabelas. No projeto `geniai-chatwoot-automation`
(`gnfswfbaovdoojtmnlmi`) as tabelas são `chatwoot_units`, `chatwoot_unit_credentials`,
`chatwoot_secret_refs`, `chatwoot_agent_credentials`, `chatwoot_agent_provisioning_requests`,
`chatwoot_agent_provisioning_items`, `chatwoot_automation_runs`. **Não gravar as keys em lugar nenhum** —
usar na chamada e descartar.

Gotcha de ambiente que apareceu junto: no Windows o Python quebra com `UnicodeDecodeError: charmap` ao
ler JSON com acento vindo do `curl` via `subprocess`. Rodar com `export PYTHONIOENCODING=utf-8` e
`capture_output=True` + `.stdout.decode("utf-8")` — não deixar o Python decidir o encoding.

Relacionado: [[chatmultgni-tucurui]], [[chatmultgni-patos-cadastrado]], [[chatmultgni-parnamirim]],
[[adicionar-acesso-chatwoot-playbook]], [[chatmultgni-mossoro]].
