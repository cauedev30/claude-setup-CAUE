---
name: commits-pequenos-um-assunto
description: "Ele quer os commits bem divididos, um assunto por commit, nunca um commit grande juntando tudo"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8b100363-1112-4017-b46f-4710aa7f2fba
  modified: 2026-10-14T00:04:24.290Z
---

Em 2026-10-13, antes do primeiro commit do simulador-adr, ele avisou: "lembre de dividir bem os commits".

**Why:** os repos dele são portfólio, e um histórico legível, com um commit por assunto, mostra o
trabalho melhor que um despejo único.
**How to apply:** separe por assunto (spec, README, cada decisão, estado e log em commits próprios) e
ordene de forma que cada commit fique coerente sozinho (ex.: a spec antes do README que aponta para
ela). Mensagens em pt-BR, no formato `tipo: descrição`. Ver [[commits-repos-caue-autor-unico]] e
[[falar-ptbr-commits-ptbr]].
