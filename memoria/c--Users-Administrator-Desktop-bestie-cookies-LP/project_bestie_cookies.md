---
name: project-bestie-cookies
description: "Bestie Cookies client project — digital cardápio with WhatsApp checkout, live and tested"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4970577f-6e28-4820-bb6b-9f623b733afa
  modified: 2026-10-12T02:49:42.622Z
---

Bestie Cookies is a cookie shop in João Pessoa - PB that takes orders only via WhatsApp. Cauê built them a digital cardápio (menu) landing page: browse cookies → build a cart → "Finalizar no WhatsApp" opens `wa.me` with the order pre-filled. No backend, no login, no payment — cart persists in `localStorage`.

Code lives at `clientes/Bestie Cookies/site/` as its own standalone git repo (separate from the parent MazyOS/business-memory repo), pushed to `github.com/cauedev30/bestie-cookies-LP`. See [[feedback-git-identity]] for the commit identity rule that applies here.

WhatsApp number `558387178205` — the checkout flow was tested live and confirmed working end-to-end (Cauê confirmed "encaminhou certinho pro whatsapp"), so the earlier concern about a possibly-missing leading "9" is resolved; the number as stored in `lib/siteConfig.js` is correct.

**Why this matters:** this was flagged multiple times during build as an unverified risk since it's the core business function of the site; now confirmed live, so no further checking needed unless the client reports issues.

**How to apply:** Next step (as of the last session) was deciding on deploy — plan was to deploy on Vercel (import the GitHub repo directly) rather than the originally-specified Cloudflare Workers/OpenNext target, since Vercel is simpler for Next.js and the production build was verified clean. Domain: no custom domain purchased yet — default `*.vercel.app` link unless Cauê registers one and points it at Vercel.

**Update 2026-09-23:** Bestie came back ~1 month later wanting the site for real. Refinement round started: exact brand colors #644604 (brown) / #E7E0D1 (beige), new real photos (WhatsApp images in `clientes/Bestie Cookies/cookies/`), header nav removed, cards restyled after the Rock n' Cookies site (`Desktop/cookie_n_rock-new`, Cauê's other client) — 2 per row on mobile, hard shadow, price pill. Open: Kinder cookie photo arrived but product isn't on the menu; no new Chocolate Chip photo.

**Status 2026-09-24:** refinement round pushed to GitHub (commits 9c66bab visual, 71adce0 two-step cart with "Seus dados" form: name/address/payment required, WhatsApp message includes them). Still open: Kinder Bueno description + price (provisional R$22,50, not on official menu); whether to rename "Romeu & Julieta" to "Romeo & Juliet" as on the official menu; deploy (Vercel) not done yet.

**Status 2026-09-25:** "detalhes visuais" round merged to main and pushed (head faca0d6): brown reverted to #5A3B25 (Cauê found #644604 ugly), cookie silhouettes on menu/video/carousel/Sobre (footer left plain on request), glow on the card button instead of a visible "adicionado" toast, photo carousel below the video, tab icon + OG preview, and delivery/pickup choice in "Seus dados" (address only for delivery). README now documents the project. Open: Kinder Bueno info, new Chocolate Chip photo, Romeu & Julieta naming, Vercel deploy + check WhatsApp link preview live.
(Hi-res carousel photo 4 arrived and was pushed 2026-09-25, head 166bbd9.)

**Update 2026-09-25 (later):** owner panel `/hoje` built on local branch `painel-hoje` (commits 7850fae, 2d541fe), ported from Rock n' Cookies. Hosting switched from Vercel to **Cloudflare Workers + KV** (same account as Rock, `pedidos-jp`), Next bumped to 16.3.6 (16.2.x had critical RCE). **Deployed 2026-09-25** at https://bestie-cookies.pedidos-jp.workers.dev (worker `bestie-cookies`, KV `bestie-cookies-estado-hoje` id cbee06fb…), merged to main and pushed (head 68868f3). The Cloudflare account is shared with Rock n' Cookies: worker `rock-n-cookies` and KV titled `ESTADO_HOJE` belong to Rock — never touch or reuse them (Cauê explicitly warned). `@opennextjs/cloudflare` needs `esbuild` hoisted (devDep 0.28.1). Rock is still on Next 16.2.10 (vulnerable range) — suggested upgrading it. Local dev password lives only in the gitignored `.dev.vars`. The site repo needs local `git config user.name/email` or the identity hook blocks commits.

**Update 2026-09-26:** Hellen's change round committed, pushed (a07a94a) and **deployed** to bestie-cookies.pedidos-jp.workers.dev (version 887469b7) on Cauê's order — he gives the go for commit/push/deploy himself ("eu vou ordenar"). Production panel password (`PAINEL_SENHA` secret) was reset to one Cauê chose; it's not stored anywhere in the repo. Changes: "Cardápio" → "Menu" (heading, tab title, OG title; `/hoje` panel and `#cardapio` id untouched); cookie silhouettes removed everywhere (CookieBackdrop/cookieShapes deleted — "marca d'água dos cookies" meant these); new video caption; official Kinder description (price R$22,50 still provisional); Sobre with new 3-paragraph text, full address (Rua José Faustino Cavalcanti, 717 - Pedro Gondim, 58031-180) + "Ver no Maps", "Encomendas pelo WhatsApp" link with prefilled message; closed-store notice now just "No momento estamos fechados. Terça a sábado, das 14h às 18h." Second round deployed 2026-09-27 (08b7ad5, version 6cabcffc): Kinder R$25,90 (no longer provisional), optional "Complemento" field on delivery, pickup shows store address + "Ver no Maps" (address/mapsLink now in `lib/siteConfig.js`), WhatsApp order header "Bestie Cookies Co.", new closed-store texts, and **disabled cookies are greyed + sorted last even when the store is closed** (changed the old "reference = nobody unavailable" rule on Hellen's request); panel list also sorts disabled last. In PowerShell 5.1, commit messages with double quotes break — use `git commit -F <file>`.

**Update 2026-09-29:** third Hellen round ("tirar o tudo claro do primeiro impacto") pushed + deployed (9596b4f, version 3c0ef773): header is now solid marrom-escuro with a creme logo variant (`public/logo/bestie-logo-header-creme.png`, footer and /hoje keep the brown logo), and the "Menu" title is a brown label with creme text + gold hard shadow (gold underline hidden there). Deploy gotcha: a running `next dev` spawns workerd that locks `.open-next`, making `cf:deploy` fail with EPERM — deploy from a fresh `git clone` of the repo in the scratchpad (npm ci + cf:deploy) instead of killing the user's dev server.

**Update 2026-10-06:** "Romeu & Julieta" renamed to "Romeo & Juliet" on Hellen's request (name only; id `bestie-romeu-e-julieta-cookie` and image filename kept). Committed 60d1e36 and deployed (version e3db6ea5) on Cauê's explicit order, pushed to GitHub same day. Auto mode blocks `cf:deploy` until Cauê confirms in the chat. The identity hook also misreads a quoted `cd "…Bestie Cookies…"` path, so run git commands from the site dir without a `cd`.

**Update 2026-10-10:** "Bestie Kinder Bueno Cookie" renamed to "Bestie Black Bueno Cookie" (id `bestie-kinder-bueno-cookie` kept, like the Romeo & Juliet rename), committed, pushed and deployed (2342ca5, version 793a392b). Description still mentions "Kinder Bueno" twice.

**Update 2026-10-10 (later):** new cookie "Bestie Arretado Cookie" (paçoca, R$22,50, id `bestie-arretado-cookie`, photo `public/cookies/arretado.jpg`) committed, pushed and deployed (e254e98, version fca24a65). Menu now has 9 cookies; two tests hardcode the available count (StorePage.test.jsx "Adicionar" buttons, app/hoje/page.test.jsx "N cookies") and must change whenever a cookie is added/removed.

**Update 2026-10-11:** removed the `/hoje` panel footnote ("Na virada da meia-noite a loja fecha sozinha…") and its `.footnote` CSS. Committed, pushed and deployed on Cauê's order (ecfd54d, version a134335a); live chunk verified without the phrase.
