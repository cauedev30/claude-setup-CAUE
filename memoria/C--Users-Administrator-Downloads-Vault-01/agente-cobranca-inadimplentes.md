---
name: agente-cobranca-inadimplentes
description: Agente de cobrança da GeniAI para inadimplentes do Cartão de Todos; em spec; isolado em workspace-agente-inadimplencia; Python e teto de 3 decididos em 2026-10-19
metadata:
  node_type: memory
  type: project
  originSessionId: 7f4e80a6-bb7a-4318-940c-3603400cb948
  modified: 2026-10-19T14:03:26.627Z
---

Os nomes "agente de inadimplência", "agente de cobrança" e "inadimplentes CDT" são o mesmo projeto. Desde 2026-10-19 o projeto vive ISOLADO em `Vault_01/workspace-agente-inadimplencia/` (pedido dele: "registra tudo por lá"). Abra a sessão lá; a spec com decisões e dúvidas é `specs/2026-10-15-agente-inadimplencia.md`. A nota do vault `Projects/Active/Agente de Cobrança - Inadimplentes CDT.md` é só ponteiro. Repo: `cauedev30/agente-inadimplencia-geniai` (PÚBLICO, clonado em `repo/`).

- Está em spec (Plan Mode); repo criado mas vazio, sem código. O desenho de referência é `Downloads/arquitetura agente inadimplente com jev.excalidraw` (Jev 1/2/3, com o LLM só redigindo).
- 2026-10-19, decisões dele:
  - **stack em Python**, mesmo com outros projetos em Go; Go só se surgir gargalo. Não reabrir.
  - **teto de 3 mensagens**; a 4ª vai para o canal externo da franquia.
  - **primeira franquia: CDT João Pessoa Sul**, em uso real (não é teste); fora da janela o agente não responde nada (custo).
  - 2026-10-20: Pix pela API do banco do CDT (D22); webchat como canal do atendimento humano em avaliação (gestor vê em 21/10), ver repo docs/ideia-webchat.md.
- A nota pedida em 2026-10-16 não chegou a ser gravada: a sessão acabou no ExitPlanMode. Ela só foi criada em 2026-10-19.

**Why:** ele vai continuar a spec em várias sessões, e o que foi decidido antes se perdeu uma vez.

**How to apply:** abra o workspace, siga as dúvidas abertas uma por vez e registre cada decisão nela na hora. Relacionado: [[chatbot-atendimento-agente-unico]] e [[inferencia-minha-nao-e-fala-dele]].
