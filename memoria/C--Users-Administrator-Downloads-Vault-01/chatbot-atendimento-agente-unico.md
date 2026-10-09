---
name: chatbot-atendimento-agente-unico
description: "Nova versão do bot de suporte (23/09) — UM agente LLM, repo novo público cauedev30/chatbot-atendimento-geniai, um amigo dele vai codar junto; spec em inglês commitada (de3d25c); NÃO registrar no vault até ele fechar; esquecer o repo antigo por enquanto"
metadata:
  node_type: memory
  type: project
  originSessionId: 09c34963-37c6-482c-8ade-c56b48e45547
  modified: 2026-09-23T15:06:26.849Z
---

Em 2026-09-23 ele trocou o desenho do Tier 0 ([[tier0-chatbot-suporte-geniai]]) por **um agente LLM só**,
supersedendo o menu numerado + formulário do Notion. Repo NOVO: `https://github.com/cauedev30/chatbot-atendimento-geniai`
(público, clone em `repo/` do workspace), **um amigo dele vai trabalhar junto**. Spec:
`docs/specs/2026-09-23-single-agent-support-bot-design.md`, commit `de3d25c` (só cauedev30), docs em inglês.

Decisões dele no brainstorming: agente substitui menu e form; kanban DENTRO do projeto (não o Dashboard de
Suporte, não Chatwoot); 5 colunas nessa ordem (Resolvido pelo bot, Aguardando humano, Em atendimento,
Resolvido por humano, Sem resposta); lista fechada de categorias + Outros; 1 tentativa só com FAQ; login
ÚNICO compartilhado; LLM neutra, escolhida por teste comparativo (DeepSeek V4.1 Flash é candidato, ~US$3/1000
tickets); abordagem "trilhos no código, LLM intérprete"; bot do CHATWOOT porque o número NÃO usa API oficial
(derruba a Cloud API do desenho antigo); confirmação de cadastro mantida; SEM filtro de dado pessoal no prompt.

**WORKSPACE (23/09, pedido dele):** `Vault_01/workspace-chatbot-atendimento-geniai`, no padrão
`dv-dev1/workspace-standard` (clone em `Desktop/workspace-standard`). É a fonte do projeto agora:
AGENTS.md, current-state.md, 13 decisões em `decisions/`, código em `repo/` (clone ignorado). Ao retomar,
abrir a sessão NESSA pasta. Check: `python ".../workspace.py" check .` (python3 aqui é stub da Store).
O clone do Desktop foi APAGADO a pedido dele (23/09); o único clone é `repo/` do workspace. O workspace
fica SÓ LOCAL, sem remoto (decisão dele), e sem commit ainda. Obsidian: ele NÃO quer excluir `repo/` da indexação.

**Why:** ele disse "esquece o antigo por enquanto" e "não registra na vault ainda, só depois que tiver fechado".
**How to apply:** não trazer código/ADRs do repo antigo sem ele pedir; não escrever no vault sobre isso até ele
dizer que fechou; próximos passos são revisão da spec por ele e depois o plano de implementação.
