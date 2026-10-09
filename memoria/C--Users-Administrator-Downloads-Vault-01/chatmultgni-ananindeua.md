---
name: chatmultgni-ananindeua
description: "Ananindeua (conta 81) cadastrada no Supabase da automação ChatMultGNI 2026-07-24 (já operacional no Chatwoot, só faltava registro); Fabrício provisionado; Kethleen e Debora removidas no mesmo dia; workflow 22 tem guardrail evoluída e um bug conhecido"
metadata:
  type: project
  originSessionId: 91525aaf-7f0d-480f-83dd-b1ca3fd916e9
  modified: 2026-08-03T19:24:30.558Z
---

Em 2026-07-24, **Ananindeua** (conta Chatwoot **81**, uf PA) foi cadastrada em `chatwoot_units`/`chatwoot_unit_credentials` no Supabase da automação ChatMultGNI — mesmo padrão de [[chatmultgni-patos-cadastrado]]: a unidade já era plena e operacional no Chatwoot (Super Admin agente 251, Gestora Matilde 357, 10 atendentes, Triagem 184, **e um time extra "Clientes Bloqueios" 185** que espelha a Triagem inteira — achado novo, motivo de negócio não investigado), só nunca tinha sido registrada. 4 dials/inboxes: `cdtananindeuadial01`/163, `cdt_ananindeuapa_dial0810`/213, `cdt_ananindeuapa_dial1618`/209 (achado aberto: estava com zero membros antes desta sessão), `cdt_ananindeuapa_dial1727`/238.

**Duas divergências de padrão desta conta** (não assumir que valem para outras unidades): a automation rule real usa `conversation_updated`+`assignee_id`→`assign_team` (não `message_created`+`team_id`); a conta não usa labels (lista vazia).

Fabrício Augusto (agente 479) provisionado no mesmo dia via Caminho B. Depois, em sessão seguinte (mesmo dia), **Kethleen Dynuei (259) e Debora Mikaelly (260) foram removidas**, uma de cada vez, autorização explícita para cada uma — regra 283/time 190 (Kethleen), regra 280/time 187 (Debora). Nenhuma tinha label nem registro em `chatwoot_agent_provisioning_items` (agentes pré-existentes ao workflow).

**Workflow n8n `22 - Chatwoot GeniAI - Remover Atendente (Real)` (id `sw309pp5ENWfdDF1`) evoluiu desde o plano original de 2026-07-16/20** (48 nodes agora, 4 DELETEs): a guardrail "time com +1 membro aborta" foi refinada — só aborta quando o time **não** foi ancorado pela regra do próprio agente (`time_resolvido_via !== 'regra_id'`). Ancorado por regra, membros extras (Super Admin/Gestor, padrão de oversight) são esperados: o time é apagado mas as contas deles são preservadas, só perdem o vínculo. Sem essa evolução, tanto Kethleen quanto Debora teriam abortado (ambas com Super Admin 251 + Matilde 357 no time pessoal). **Sempre buscar o JSON atual do workflow via API do n8n antes de replicar a lógica — não confiar em planos/notas antigas.**

**Bug do `unit_slug`: CORRIGIDO em 2026-08-03** (autorizado pelo usuário nessa sessão, ver [[chatmultgni-fortaleza]]). A causa real era no node `Supabase - Buscar unidade` (não no `Validar unidade` como registrado antes — esse só processa `rows[0]` do que a query trouxer): fazia `getAll` em `chatwoot_units` com `returnAll: true` e **sem filtro**, ignorando o `unit_slug` digitado em `Entrada`. Fix aplicado via API do n8n (`PUT /api/v1/workflows/{id}`): adicionado `filters.conditions = [{keyName: 'slug', condition: 'eq', keyValue: '={{$json.unit_slug}}'}]`. Ainda não houve uma execução completa que confirme o fix ponta a ponta (ver nota linkada — parou antes por outro motivo), mas o filtro está salvo no workflow publicado.

**Ref do projeto Supabase:** `gnfswfbaovdoojtmnlmi` (`geniai-chatwoot-automation`). Auditoria de remoção vai em `chatwoot_automation_runs` (não em `chatwoot_agent_provisioning_*`, que é só para provisionamento) — check constraint de `status` só aceita `started/success/failed/warning/skipped`, não `completed`.
