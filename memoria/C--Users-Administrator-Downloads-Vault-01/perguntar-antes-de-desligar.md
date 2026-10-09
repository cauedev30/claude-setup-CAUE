---
name: perguntar-antes-de-desligar
description: "Perguntar antes de desativar, desligar ou remover qualquer coisa em infraestrutura do usuário, mesmo sendo reversível"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de4536cf-46cb-45fd-9a18-03b1b380581d
  modified: 2026-08-17T20:18:10.388Z
---

Pedido explícito em 2026-08-17, durante o deploy da LP de Petrolina: **perguntar antes de desativar ou desligar qualquer coisa** — monitor, modo manutenção, domínio, app. Vale mesmo quando a ação é reversível e mesmo quando ela é o próprio objetivo da tarefa.

**Why:** ele estava com a Meta esperando o site subir para dar continuidade a uma verificação. Eu já tinha derrubado o site removendo um domínio sem validar o deploy antes, e cliquei "desligar monitor" no painel sem avisar. Nesse contexto, qualquer desligamento não anunciado vira risco de um problema que ele não consegue prever nem explicar para terceiros.

**How to apply:** antes de `maintenance`, "desligar monitor", "remover domínio", parar container ou qualquer equivalente, descrever o que vai ser desligado, por quê e como reverter — e esperar o ok. Se algo já foi desligado antes do pedido chegar, contar de imediato em vez de deixar ele descobrir. Isso NÃO impede agir: é anunciar e confirmar, não travar. Ver [[um-passo-de-cada-vez]] e [[painel-dokku-mcp-deploy-lps]].
