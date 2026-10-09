---
name: eme-praia-deploy-automatico
description: Eme Praia publica sozinha na Cloudflare a cada push na main (GitHub Actions desde 2026-10-02)
metadata:
  node_type: memory
  type: project
  originSessionId: 3b6f9aa8-c3a9-4d9d-b9da-ce0d0a60000a
  modified: 2026-10-03T16:17:25.956Z
---

Desde 2026-10-02, todo push na `main` do repo `cauedev30/eme-praia-LP` roda
`.github/workflows/deploy.yml`: testes, build e `wrangler deploy` da loja (o
painel só quando o push mexe nele). Não rodar `npm run deploy` à mão depois
do push: acompanhar com `gh run watch` e conferir o site.

**Why:** o Cauê não quer publicar manualmente. Push = produção em ~3 min,
então nada vai pra `main` sem ele querer no ar.

**How to apply:** "salva/sobe" → commit + push e acompanhar o run. Guardar sem
publicar → outra branch. Migration do D1 continua manual, antes do push.
O token do secret `CLOUDFLARE_API_TOKEN` foi colado no chat em 2026-10-02.
Recomendei trocar (Roll) e em 2026-10-03 o Cauê decidiu não trocar — não
insistir. Se o deploy falhar com erro de auth, o token foi trocado ou apagado
na Cloudflare sem atualizar o secret.

Relacionado: [[eme-praia-repo-isolado]], [[git-commits-conta-caue]]
