---
name: eme-praia-painel-fase-2-proximo
description: "Painel da Eme Praia em 2026-09-15 — Fase 2 no ar (login por senha, não Access); falta trocar a senha fraca e ver o painel num celular"
metadata:
  node_type: memory
  type: project
  originSessionId: 3d7529b1-ae6d-4da2-b1ec-8cd1012d6bbf
  modified: 2026-09-15T14:09:27.822Z
---

Em 2026-09-15 a Fase 2 do painel da Eme Praia foi mesclada em `main` e publicada. Painel em `eme-praia-painel.pedidos-jp.workers.dev`, loja em `eme-praia.pedidos-jp.workers.dev`.

**O login mudou de desenho no meio do caminho.** O Cauê rejeitou o Cloudflare Access (decisão 11 original) porque buscar código no e-mail é atrito pra Mayara no meio do expediente, e pediu senha — o mesmo padrão que ele já roda no painel do Cookeria em `/hoje`. Ficou: senha única em secret do Worker, cookie assinado por HMAC com chave derivada por PBKDF2. A decisão 11 foi reescrita com o que se perde.

**Why:** Duas pendências reais ficaram abertas, e a primeira é de segurança. A senha de produção é `praia`+sequência de teclado — escolhida de improviso, avisada como fraca duas vezes, e o Cauê disse "deixa essa qualquer coisa mudo depois". Como não há rate limiting, o tamanho da senha é a única defesa. A segunda: ninguém abriu o painel num celular de verdade — a sessão não tinha navegador, então só HTML por `curl` foi verificado.

**How to apply:** Ao retomar, ler `docs/runbook-caue.md` — as pendências de lançamento e a seção "O que a Fase 3 tem que resolver antes de começar" estão versionadas lá (o ledger em `.superpowers/sdd/progress.md` é gitignored). Dois fatos que moldam o código: a conta está no **plano gratuito** do Workers (10 ms de CPU), por isso o PBKDF2 está em 5 mil iterações e não 100 mil; e a sacola vive no `localStorage` e nunca consulta disponibilidade, então pedido de tamanho esgotado ainda passa — é o buraco maior, não os 100 ms do overlay. Ver [[eme-praia-repo-isolado]] e [[git-commits-conta-caue]].
