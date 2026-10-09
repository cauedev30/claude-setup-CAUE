---
name: chatmultgni-fortaleza
description: "Fortaleza (CE, conta Chatwoot 85): Eduarda Freitas removida com sucesso em 2026-08-03 via workflow 22. Fortaleza agora está cadastrada em chatwoot_units. Dois bugs do workflow 22 corrigidos nessa sessão (unit_slug sem filtro; regex de acento corrompido)."
metadata:
  node_type: memory
  type: project
  originSessionId: dab0f713-0ffb-49ed-ade7-639480b3febf
  modified: 2026-08-03T20:18:09.463Z
---

Em 2026-08-03, **Eduarda Freitas** (`eduardafreitascdtfortalezace@geniai.online`, agent_id 321) foi removida com sucesso da conta Chatwoot de **Fortaleza (CE), conta 85**, via `22 - Chatwoot GeniAI - Remover Atendente (Real)` (id `sw309pp5ENWfdDF1`). Confirmado ponta a ponta direto na API do Chatwoot depois da execução: agente 321, regra 328 (`atribuir time`) e time 255 (`atendimentos eduarda freitas cdt fortaleza ce`) não existem mais; label não existia (nada a apagar); Gestor CDT Fortaleza CE (362, estava no time dela por oversight) preservado, só perdeu o vínculo; Triagem (247) intocada.

**Fortaleza agora está cadastrada em `chatwoot_units`/`chatwoot_unit_credentials`** (não estava antes, ver histórico desta sessão): `slug='cdt_fortaleza'`, `unidade_nome='CDT Fortaleza CE'`, `local='Fortaleza'`, `uf='CE'`, `account_id=85`, `inbox_id=205` (único inbox: `cdt_fortalezace_dial0333`), `triage_team_id=247`. Token em `chatwoot_unit_credentials` é o do agente **"Super Admin CDT Fortaleza CE"** (`gestaocdtfortalezace@geniai.online`, id 290, role `administrator`/`SuperAdmin`) — **não** o do "Gestor CDT Fortaleza CE" (362), que só tem role `agent` e leva 401 em `automation_rules`/deletes. Regra geral confirmada: o token cadastrado sempre precisa ser de uma conta com role `administrator` no Chatwoot, não só quem "parece" gestor pelo nome.

**Dois bugs reais do workflow 22 corrigidos nesta sessão** (agora publicados, valem para todas as unidades):
1. `unit_slug` sem filtro — já documentado em [[chatmultgni-ananindeua]].
2. **Novo**: as funções `slug()` em `Resolver regra e time por ID` e `Resolver label` tinham um regex de remoção de acento corrompido (`/[Ì€-Í¯]/`, mojibake de `/[̀-ͯ]/` — bytes UTF-8 do range Unicode reinterpretados como cp1252). Isso quebrava o JS na hora de parsear o código (SyntaxError em tempo de parse, não de execução), travando a automação assim que chegava nesses nodes — bug pré-existente, já estava assim na primeiríssima leitura do workflow via API nesta sessão, não fui eu que introduzi. Corrigido para `/[̀-ͯ]/g` (escape explícito, evita corrupção de novo em round-trips futuros).

**Achado sem importância prática**: os `DELETE` do Chatwoot (regra/time/agente) retornam corpo vazio, e o node HTTP Request do n8n reporta isso como `FALHOU: "Invalid JSON in response body"` no resumo — **mas a operação funciona normalmente** (confirmado consultando a API do Chatwoot depois: os 3 recursos realmente sumiram). Não é um bug real, é só o texto do resumo sendo enganoso. Vale saber pra não se assustar da próxima vez.

Workflow foi deixado limpo no final: `confirmar` resetado para `false`, filtro do `unit_slug` correto, regex corrigido.
