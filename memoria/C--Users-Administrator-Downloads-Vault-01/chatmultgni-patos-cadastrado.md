---
name: chatmultgni-patos-cadastrado
description: "Cartão de Todos Patos cadastrado no Supabase da automação ChatMultGNI (3 dials, conta 88); Guilherme Florentino e Tallita Morais provisionados como atendentes em 2026-07-23"
metadata: 
  node_type: memory
  type: project
  originSessionId: 01e39052-562f-4711-8ba8-43c16fb28510
  modified: 2026-07-23T19:55:05.044Z
---

Em 2026-07-23, **Cartão de Todos Patos** foi cadastrado no Supabase da automação ChatMultGNI (antes não existia lá). Conta Chatwoot **88**, triagem team **305**, uf **PB**.

**Convenção de modelagem** (igual ao Parauapebas, conta 87): **1 linha em `chatwoot_units` por inbox/dial**. Patos tem 3 dials:
- `cdt_patos_6448` → inbox 177 → unit_id `d38e7237-53e6-42d9-b89a-2dc1f1c61dbd`
- `cdt_patos_4110` → inbox 202 → unit_id `0a12d43f-2e01-4903-b982-efcbfe3e7f5d`
- `cdt_patos_4293` → inbox 225 → unit_id `c737e43c-85bd-479f-b4b5-5c25ba2a7245`

Credenciais em `chatwoot_unit_credentials` (colunas úteis: `unit_id`, `api_token`) usam o **token do Super Admin de Patos** (agent id 374, `contato@cartaodetodospatospb.online`). Se esse token for rotacionado, atualizar as 3 linhas. Ideal futuro: token de serviço dedicado. (Token nunca é gravado em memória/vault.)

**Remoção de atendente** = workflow n8n "22 - Chatwoot GeniAI - Remover Atendente" (id `sw309pp5ENWfdDF1`). Chaveia por `slug` → `account_id` + `triage_team_id` + token do Supabase. Guardrails: e-mail casa com 1 agente, regra ancorada por `assignee_id`, time nunca é Triagem, oversight (SuperAdmin/Gestor) só perde o vínculo com o time (conta preservada). Apagar um team no Chatwoot NÃO apaga contas de membros — só o vínculo.

**Adição de atendente** = workflow n8n "20 - Chatwoot GeniAI - Provisionar Atendente (Real)" (id `ydyg95U7T31ZtkiX`). **Não cria o login/agente** — o agente precisa já existir no Chatwoot (Super Admin) antes de rodar; ele só resolve por e-mail e vincula time pessoal/label/regra/Triagem/inbox. É Manual Trigger — a API pública do n8n não tem endpoint pra disparar execução, só dá pra rodar pela UI (extensão Chrome) ou replicar a lógica via API direta.

**Caminho B (fallback):** quando o Supabase management token (`sbp_`) dá 401 (recorrente — já aconteceu 2x em Patos) e/ou a extensão Chrome não está conectada, dá pra fazer via API direta do Chatwoot com um token admin (usuário fornece na hora), replicando os guardrails/lógica na mão. Usado em 2026-07-23 pra remover Daniel Inácio, Eduarda Germano, Wanessa Kelly e Kamilla Gomes de Patos, **e de novo em 2026-07-23 (mesma data, sessão seguinte) pra provisionar** Guilherme Florentino (agente 478) e Tallita Morais (agente 477) nos 3 dials — time pessoal (403/404), label, regra, Triagem, 3 inboxes, tudo criado via script Node descartável (token só em env var).

**Pendência de auditoria RESOLVIDA no mesmo dia.** O `sbp_` antigo continuava 401ando (2ª vez que isso acontece — esse token parece expirar/rotacionar com frequência); o usuário gerou um Personal Access Token novo em **Account > Access Tokens** do Supabase (não em Organization Settings — essa é a pegadinha, a tela de org não tem token de acesso) e esse funcionou. Com ele, inseridas as 6 linhas de auditoria (request+item por atendente × dial) em `chatwoot_agent_provisioning_requests/items`, com `source: 'caminho_b_api_direta_2026-07-23'` (marcado como manual, não como execução real do `20`, para não poluir a auditoria). Verificado por SELECT. Ver nota do projeto [[../../../../Downloads/Vault_01/Projects/Active/Automação Chatwoot GeniAI]] (seção "Patos (conta 88): cadastro e onboarding via Caminho B").

**Ref do projeto Supabase:** `gnfswfbaovdoojtmnlmi` (nome `geniai-chatwoot-automation`), region `us-west-2`.

**Próximo passo em aberto:** nenhum atendente pendente no momento. Quando o `sbp_` 401ar de novo, pedir ao usuário um token novo em `supabase.com/dashboard/account/tokens` (não nas configurações da organização).
