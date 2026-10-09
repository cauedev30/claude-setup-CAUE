---
name: rock-n-cookies-project
description: "Landing page da cookeria Rock n' Cookies — onde o código vive, stack, estado e pendências"
metadata: 
  node_type: memory
  type: project
  originSessionId: 647cbbd5-8535-48bd-ac81-83211f5a77dc
---

Landing page da **Rock n' Cookies** (cookeria; conceito: cada cookie é um astro do rock, com sabor + catchphrase; venda pelo WhatsApp via link `wa.me`, sem backend).

**O código vive em `C:\Users\Administrator\Desktop\cookie_n_rock-new`** (repo próprio: https://github.com/cauedev30/cookie_n_rock-new). **NÃO** é a pasta da sessão `rock_n_cookies` — essa é o template MazyOS e tem uma cópia **abandonada** em `site/` que deve ser ignorada.

Stack: Next.js 16 (App Router, JS) + CSS Modules/tokens + Vitest (29 testes). Identidade: creme/laranja/turquesa/pink/amarelo, contornos pretos estilo adesivo, fontes Anton/Hanken/DM Mono/Bagel Fat One, sem emojis. Cardápio real (15 cookies) em `src/data/produtos.js`.

Handoff detalhado versionado no próprio repo em `ESTADO.md`. Pendências: (1) PNGs dos personagens em `public/cookies/<id>.png`; (2) número real do WhatsApp em `src/config.js`; (3) deploy na Vercel; (4) seções galeria/avaliações/localização.
