---
name: um-passo-de-cada-vez
description: "Cauê trabalha um caso de cada vez e não quer que Claude misture clientes/problemas na mesma execução — achou algo adjacente, reporta e registra, não conserta junto"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 397005d7-8a32-4d4d-9d5b-0c9530902c6d
---

Quando ele pede uma coisa, faça só aquela coisa. Se você descobrir um problema adjacente no caminho —
mesmo que seja fácil de corrigir e esteja logo ali — **reporte e registre, mas não corrija junto sem
ele mandar.**

**Why:** ele disse explicitamente "vamos lá, um passo de cada vez", "vamos trabalhar só na Maíra por
enquanto" e "não quero que fique nenhuma pendência ou que misture os clientes e os casos". Em
2026-07-15, na [[Projects/Active/Automação Chatwoot GeniAI]], eu ofereci corrigir o cadastro errado do
Supabase na mesma tacada do provisionamento da Maira e ele recusou a pergunta — queria a Maira fechada
primeiro, o cadastro depois. Ele lida com ~20 clientes no mesmo Chatwoot/n8n; misturar casos é como o
trabalho vira confusão e risco.

**How to apply:** ache, meça, reporte, registre no vault como pendência com as saídas possíveis — e pare.
Deixe a decisão com ele. Ele decide rápido quando você traz dado em vez de opção vaga (a pergunta "quais
inboxes estão vivos?" virou decisão dele em um minuto porque eu trouxe a tabela de última atividade).
Ele valoriza quando você sinaliza o adjacente — só não quer que você aja nele.
Ver também [[notas-sem-pendencia-arrastada]].
