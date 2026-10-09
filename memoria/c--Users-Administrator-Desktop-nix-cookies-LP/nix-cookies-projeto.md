---
name: nix-cookies-projeto
description: "Estado do projeto NIX Cookies (LP cardápio + WhatsApp) — repo, stack, pendências"
metadata: 
  node_type: memory
  type: project
  originSessionId: a9ede3f9-4c7d-4b4e-897a-7d30d06b64eb
  modified: 2026-07-24T03:02:28.179Z
---

LP da NIX Cookies (cookeria em João Pessoa, cliente do Cauê): cardápio → sacola → pedido pronto no WhatsApp (`wa.me/5583998463113`).

- Código em `clientes/NIX-Cookie/site/` (git próprio, aninhado) → https://github.com/cauedev30/nix-cookies-LP (repo renomeado de `nix-cookies`)
- Stack fixada pelo Cauê: Next.js 16 App Router, JS puro sem TS, CSS Modules, zero deps de runtime extras, Vitest
- Deploy: Vercel (não Cloudflare/OpenNext como planejado antes), no ar em https://nix-cookies.vercel.app/, auto-deploy a cada push na `main`
- Commits nesse repo devem usar `cauefranco01@gmail.com` (configurado local via `git config user.email`) — plano Hobby do Vercel bloqueia deploy automático se o autor do commit não tiver acesso ao projeto (repo privado); e-mail interno da empresa não tem acesso
- Dev sobe em :3001 (porta 3000 ocupada pela LP da Cassiano Veículos)
- Pendência (2026-07-24): preço real do Red Velvet (R$ 15 placeholder em `lib/menu.js`)
- O workspace raiz `nix-cookies-LP/` é o MazyOS do Cauê — **não** commitar no repo do cliente

**Why:** próxima sessão continua ajustes; esses ponteiros evitam redescobrir o setup.
**How to apply:** ao retomar, ler o CLAUDE.md de `clientes/NIX-Cookie/` e conferir pendências antes de codar.
