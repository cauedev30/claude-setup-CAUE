---
name: chatmultgni-ze-andre
description: "ChatMultGNI (Automação Chatwoot GeniAI) — conta 105 \"Ze Andre\", não é cliente CDT; Mirla provisionada 2026-08-06 igual aos outros, mas atendentes 'agent' nessa conta nunca recebem conversa (só admins)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4894bc6a-19ac-4930-b671-5027e4015234
  modified: 2026-08-06T20:45:27.685Z
---

Conta 105 no Chatwoot é literalmente chamada "Ze Andre" — é o nome do cliente (negócio de
lançamento/mentoria, regras existentes falam de "PMN"), não uma unidade CDT. A atendente provisionada
nesta conta é a **Mirla** (agente 481, `mirla.zeandre@geniai.app`), não "Zé André" — esse é o sufixo do
nome de todos os atendentes da conta (`{Nome} Zé André`).

**Esta conta NÃO usa o padrão Triagem→time pessoal.** Nenhum dos 6 atendentes existentes (nem a Mirla,
no estado final) tem time pessoal ou automation rule de roteamento — todos são só membros dos 4 inboxes
(256, 257, 258, 266), no pool de auto-assignment nativo do Chatwoot. A Triagem (375) existe como time mas
tem só 3 conversas em toda a história da conta — não é usada de verdade.

**2026-08-06:** Mirla provisionada via Caminho B, retomando uma sessão anterior que caiu (notebook do
usuário descarregou) — o usuário Chatwoot dela já existia sem vínculo com a conta 105; o usuário linkou
pela própria UI. Build inicial tentou o padrão CDT (Triagem + time pessoal 408 + regra 490), mas
conferência com dados reais (a pedido do usuário) mostrou que isso não corresponde a como a conta roteia
de verdade. **Decisão final: desfeito tudo (regra e time apagados, removida da Triagem) — Mirla ficou
idêntica aos outros 6, só membro dos inboxes.** Nome dela salvo como `"Mirla ZÉ ANDRE"` (fora do padrão
"Nome Sobrenome Zé André" dos outros) e senha — ambos definidos pelo próprio usuário de propósito,
confirmado, não são erro.

**Não recriar time pessoal/regra/Triagem pra esta conta sem o usuário pedir de novo** — seria mudança de
conta inteira (afeta os 6 atendentes atuais), não só dela.

**PENDÊNCIA CRÍTICA, não resolvida:** conferido o histórico real de conversas por atendente
(`POST /conversations/filter` por `assignee_id`) — Pedro Maia (admin) 587, Rafael Borges (admin) 112,
**Beatriz, Lucas e Marcos (os 3 "agent", igual à Mirla) — 0 cada.** Nenhum atendente comum nesta conta
jamais recebeu uma conversa, só os administradores. Isso significa que **deixar a Mirla "igual aos
outros" não garante que ela vá receber trabalho** — motivo real não identificado (suspeita: o "Central
Gateway Bot", agente 397, webhook por inbox, decide fora das Automation Rules nativas). Não investigado
a fundo. **Antes de considerar o caso da Mirla resolvido, investigar por que Beatriz/Lucas/Marcos nunca
receberam nada.**

**Notas técnicas de API (Chatwoot self-hosted 4.1.1, diferente da 4.11.4 das contas CDT):** membros de
inbox usam `POST /accounts/{id}/inbox_members` com `{inbox_id, user_ids}` (não `POST /inboxes/{id}/members`,
404). Membros de time: `POST /teams/{id}/team_members` **adiciona** à lista (não substitui); pra
**remover**, `DELETE /teams/{id}/team_members` com `user_ids` de quem deve **sair** — remove exatamente
os IDs enviados, não "define a lista final" como nas contas CDT. Confundir isso já causou um incidente
real nesta sessão (corrigido na hora, sem dano — Triagem não estava ligada a nenhuma automação ativa).

Detalhes completos: nota do projeto [[Projects/Active/Automação Chatwoot GeniAI]] (seção "Zé André
(conta 105)") e dev log [[Dev Logs/2026-08-06 - Automação Chatwoot GeniAI Zé André Provisionamento Mirla]]
na vault.
