---
name: chatmultgni-parnamirim
description: Conta 113 CDT PARNAMIRIM RN, 8 atendentes (7 em 2026-08-17 + Lincon Emanuel em 2026-08-19); só falta o inbox/dial
metadata: 
  node_type: memory
  type: project
  originSessionId: f886722c-9fb6-439a-acb1-552e4cb7442a
  modified: 2026-08-19T15:39:19.154Z
---

Cliente **Cartão de Todos Parnamirim (RN)** = conta **113** `CDT PARNAMIRIM RN`, criada do zero em 2026-08-14 e **montada em 2026-08-17**: 7 atendentes (users **488–494**, role `agent`), time `triagem` (**412**), 7 times pessoais (**413–419**) e 8 automation rules ativas (**503–509** + **510**). **2026-08-19: 8º atendente, Lincon Emanuel (user 496, sem o segundo "L")**, adicionado por API direta pelo mesmo padrão — time pessoal **420**, regra **511**, membro da Triagem 412. Super Admin: user **486**, `superadmincdtparnamirimrn@geniai.online`, `administrator` e **`type: SuperAdmin`** (tem o Console de Super Admin). **A senha do 486 não é a padrão do app; peça a ele.** **Gestora = Daiane da Silva (491)**, membro de todos os times pessoais (incluindo o do Lincon); **Super Admin 486 e bot 397 em todos os times**. E-mails dos atendentes são **sem o sufixo `rn`** (`...cdtparnamirim@geniai.online`), ao contrário do 486 — escolha explícita dele.

**Caminho repetível para novo acesso (usado em 19/08):** Platform Token do Chatwoot está hardcoded em `conciliation-team-creator-main/src/pages/Index.tsx:55`; usar `GET /platform/api/v1/users/486` com ele para pegar o admin token (access_token do 486, nunca se perde); depois `GET /accounts/113/agents` antes de criar (dedupe), criar agente via Platform API, time pessoal com a Daiane dentro, regra `conversation_updated`+`assignee_id`→`assign_team` sem `inbox_id`, e adicionar na Triagem 412 lendo a lista atual antes (o endpoint substitui, não soma). **Não usar o app `conciliation-team-creator`** — ele cria um Gestor sintético hardcoded que não existe no padrão real desta conta.

**Gotcha do Supabase (19/08):** um Personal Access Token `sbp_` pode autenticar OK na Management API (`GET /v1/projects`) e mesmo assim falhar com `28P01 password authentication failed` no endpoint de SQL (`POST /database/query`) — **mesmo padrão já visto em [[chatmultgni-patos-cadastrado]]**. A conta 113 **continua fora do Supabase**; não adianta tentar puxar o token do Chatwoot de lá.

**O único bloqueio que sobra é o inbox/dial da unidade**, que vem do fornecedor: sem ele a conta não atende ninguém e as regras não processam nada. A conta segue **fora do Supabase** (workflows `20`/`22` não rodam nela) e sem labels nem time `clientes bloqueios`.

**Why:** o app `conciliation-team-creator` não serviu para times/automações — hardcoda os membros (agente + SA + Gestor) sem o bot e exige um inbox que não existe. Tudo saiu por API. Duas escolhas deliberadas nas regras, para ninguém "corrigir" depois: as 7 pessoais **não têm condição de `inbox_id`** (assim já valem pro dial que vier) e a 510 usa `status equal_to open` porque o Chatwoot exige ao menos uma condição.

**Gotcha do platform token:** ele **não alcança os users 488–494** (`401 Non permissible resource`) — quem os criou foi o console `/super_admin`, não o Platform App. Só o 486 é alcançável. O escopo não é "a conta 113", é "o que este Platform App criou": não dá pra recuperar o `access_token` deles nem mexer no `ui_settings` (o "Enter para enviar" ficou sem setar nos 7). Auditoria de 17/08: os 7 `confirmed`, role `agent`, sem custom role — **logam hoje**; conta sem label, sem canned response e **nada testado ponta a ponta**.

**How to apply:** ao retomar, **pergunte o estado atual** — não trate o provisionamento como pendente, ele está feito ([[notas-sem-pendencia-arrastada]]). Antes de criar qualquer usuário, **leia `GET /accounts/113/agents` primeiro**: em 17/08 ele já tinha criado os 7 no console e isso evitou sete duplicados. Para conceder Console de Super Admin a alguém: é o campo `type` do usuário (STI `SuperAdmin < User`); a Platform API responde **200 e descarta o campo**, e o select `Type` do console vem vazio — só sai com o **usuário** rodando 3 linhas no DevTools dele (`document.getElementById('user_type')` + `new Option('SuperAdmin','SuperAdmin')`) e clicando "Update User"; **o `javascript_tool` do Claude é bloqueado nessa ação, não insista**. Ver [[consulta-por-api-nao-navegador]] e [[um-passo-de-cada-vez]].
