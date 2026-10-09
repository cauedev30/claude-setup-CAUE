# Painel de controle da Bestie Cookies (`/hoje`)

## Contexto

A Bestie quer controlar o cardápio pelo celular: abrir e fechar o dia e marcar
um cookie como indisponível quando acaba. O Rock n' Cookies já tem isso em
produção (`/hoje` da Karen, Cloudflare Workers + KV), e a ideia é trazer a mesma
lógica. Hoje o site da Bestie é 100% estático, sem nenhum código de servidor, e
ainda não foi pro ar. Hospedagem decidida: **Cloudflare, igual ao Rock** (mesma
conta `pedidos-jp`, o wrangler já está logado nesta máquina). A Vercel sai do
plano.

Projeto: `clientes/Bestie Cookies/site/` (repo próprio, `cauedev30/bestie-cookies-LP`).
Referência: `Desktop/cookie_n_rock-new` (branch `cloudflare-migracao`, a que está no ar).

## Regras que vêm do Rock (mesma lógica)

- **O toque dela põe o site no ar, não o relógio.** "Abrir o dia" carimba a hora
  com o relógio do servidor. A abertura só vale no mesmo dia local (UTC−3 fixo,
  João Pessoa). Na virada da meia-noite o site volta sozinho pro modo referência.
  Nada roda à meia-noite: a regra é aplicada toda vez que alguém lê o estado.
- **Modo referência** (dia fechado ou expirado): o cardápio aparece inteiro, com
  um aviso de loja fechada. Ninguém aparece como indisponível. Dá pra montar a
  sacola, mas **não dá pra finalizar no WhatsApp**.
- **Modo ao vivo**: os cookies indisponíveis ficam apagados, com uma pílula
  "indisponível hoje" no lugar do botão, e descem pro fim da grade. A grade tem
  uma categoria só, então não precisa da seção "Sabores do Dia" do Rock.
- **"Abrir o dia" mantém a lista de indisponíveis do dia anterior.** É o momento
  dela revisar a lista.
- **Nenhum toque tem confirmação.** Todo toque mostra "salvo" ou "não salvou ·
  toca de novo". A atualização é otimista e as gravações vão numa fila, uma por vez.
- **Qualquer falha cai pro lado honesto (referência).** Isso vale pra KV vazio,
  JSON corrompido e fetch que falha.
- **Uma coisa que o Rock não trata e a Bestie vai tratar:** um cookie que está
  na sacola (salva no localStorage) e depois fica indisponível.
  - Na gaveta, o item ganha a marca "indisponível hoje".
  - O "Prosseguir" dá lugar ao aviso "Tira da sacola o que está indisponível
    hoje pra continuar".
  - Se o cliente já estiver na etapa "Seus dados", a gaveta volta pra sacola.
    Isso segue a mesma regra do fechamento da loja no meio do pedido.
  - No card, quem está indisponível perde o stepper. Assim pedido com cookie
    esgotado nunca chega no WhatsApp.

## Arquitetura

```
/hoje (página cliente) --GET/POST--> /api/hoje (confere o cookie de sessão) --> KV ESTADO_HOJE, chave "estado-hoje"
                       --POST------> /api/hoje/login (confere PAINEL_SENHA, grava o cookie)
/ (continua estático) --GET a cada 45s, no-store--> /api/cardapio-hoje (público) --> resolveAvailability()
```

Estado guardado: `{ dayOpen: bool, openedAt: ISO|null, unavailable: string[] }`,
com os `id` de `data/products.js`. **Os ids viram contrato:** renomear um cookie
nunca pode trocar o id dele.

Os nomes de função e de campo seguem a convenção da Bestie: identificadores em
inglês (`useCart`, `firstMissingField`), comentários e textos de tela em
português. A lógica do Rock é portada e renomeada, não colada.

## Arquivos

### Infra Cloudflare (espelho do Rock)
- `package.json`:
  - Dependência `@opennextjs/cloudflare` ^1.20.1 e devDependency `wrangler` ^4.112.0.
  - Scripts: `build` passa a ser `next build --webpack` (o Turbopack quebrou em
    runtime no Windows no Rock), mais `cf:build`, `cf:preview` e `cf:deploy`.
- `wrangler.jsonc` (novo):
  - `name: "bestie-cookies"`, flags `nodejs_compat` e `global_fetch_strictly_public`.
  - `assets`, `images` (Header e Footer usam `next/image`) e `kv_namespaces`
    com o binding `ESTADO_HOJE`.
  - O id do KV fica como placeholder até o passo de deploy.
- `open-next.config.ts` (novo): `defineCloudflareConfig()` sem nada extra.
- `next.config.mjs`: acrescentar `initOpenNextCloudflareForDev()`.
- `.gitignore`: acrescentar `.dev.vars`, `/.open-next/` e `/.wrangler/`.
  O `eslint.config.mjs` passa a ignorar as duas pastas.
- `.dev.vars` (fora do git): `NEXTJS_ENV=development` e `PAINEL_SENHA=<senha de dev>`.
- `app/layout.js`: `metadataBase` passa a usar `NEXT_PUBLIC_SITE_URL` ou,
  sem ela, a URL do `workers.dev`. Sem a Vercel, o fallback automático some.

### Lógica pura (portada do Rock, com testes)
| Bestie (novo) | Vem de (Rock) | Conteúdo |
|---|---|---|
| `lib/storeState.js` | `src/lib/estadoHoje.js` | `readState(kv)` e `saveState(kv, state)`, com normalização e fallback pro estado padrão fechado |
| `lib/dayActions.js` | `src/lib/acoesHoje.js` | `applyAction(state, action, now)`, com as ações `open`, `close` e `toggle` |
| `lib/availability.js` | `src/lib/disponibilidade.js` | `localDate`, `sameLocalDay`, `resolveAvailability` (`live` ou `reference`), `readPanel` (`isLive`, `expired`, `openedAt`) e `sortByAvailability(products, availability)` |
| `lib/session.js` | `src/lib/sessao.js` | `SESSION_COOKIE`, `constantTimeEqual` e `sessionToken(password)` (SHA-256 com o prefixo `bestie-cookies:`) |
| `lib/auth.js` | `src/lib/auth.js` | `checkPassword`, `currentSessionToken` e `isAuthenticated`, via `getCloudflareContext` e `cookies()` |

### Rotas
- `app/api/hoje/route.js`: GET e POST protegidos, retornam 401 sem sessão,
  `force-dynamic` e `no-store`. O POST lê o estado, aplica a ação e grava.
- `app/api/hoje/login/route.js`: POST `{ password }`. Grava o cookie `HttpOnly`,
  `secure`, `sameSite: lax`, com validade de 1 ano.
- `app/api/cardapio-hoje/route.js`: GET público, devolve `{ mode, unavailable }`
  com `no-store`.
- Antes de escrever as rotas, ler os guias de route handlers, cookies e
  `dynamic` em `node_modules/next/dist/docs/` (é o que pede o `AGENTS.md`).

### Painel `/hoje`
- `app/hoje/layout.js`: metadata `robots: noindex`.
- `app/hoje/page.js`: porta a estrutura de `src/app/hoje/page.jsx` do Rock.
  - Tela de senha.
  - Cartão do dia: data, status (no ar desde HH:MM / expirou em dd/mm / fora do
    ar) e o botão "Abrir o dia" / "Fechar o dia".
  - Lista dos 8 cookies com o interruptor "disponível" / "indisponível".
  - Bloco "O cliente está vendo agora".
  - Toast de salvo ou erro.
  - Fila otimista via `useRef(Promise)`.
- `app/hoje/hoje.module.css`: identidade Bestie, não a do Rock.
  - Usa os tokens de `globals.css` (`--color-marrom-escuro`, `--color-bege`,
    `--color-creme`, `--color-dourado`, `--shadow-hard`) e as fontes
    `--font-display` e `--font-ui`.
  - Coluna única de até 430px. `prefers-reduced-motion` desliga as transições.
- Os textos falam em "cookies", não em "sabores".

### Cardápio público
- `lib/useAvailability.js` (novo, `"use client"`):
  - Porta o `DisponibilidadeContext` do Rock como hook simples, igual ao `useCart`.
  - Faz o fetch na montagem e depois a cada 45s, com `no-store`.
  - Se uma leitura falhar, mantém o último estado bom.
  - Devolve `{ mode, unavailable, loaded }`, começando em `reference`.
- `components/StorePage.js`: chama `useAvailability()` e passa o resultado por
  props, que é o padrão da Bestie (hoje tudo desce do StorePage).
- `components/Menu.js`:
  - Ordena com `sortByAvailability`.
  - Passa `unavailable` pro card.
  - Mostra o aviso de loja fechada no topo do cardápio, só quando
    `loaded && mode === "reference"`.
- `components/ProductCard.js` + `.module.css`:
  - O estado `unavailable` apaga o card: imagem e descrição com opacidade e
    grayscale, e a pílula "indisponível hoje" no lugar do botão e do stepper.
- `components/StoreClosedNotice.js` + `.module.css` (novo): o aviso de loja
  fechada no estilo da Bestie. Texto: "No momento estamos fechados. Os cookies
  do dia a gente confirma quando a loja abre — de terça a sábado, das 14h às 18h."
- `lib/siteConfig.js`: novo `openingHours` (dias e horário). `Sobre.js` e o
  aviso passam a ler dali, pra horário ficar num lugar só.
- `components/CartDrawer.js` + `.module.css`:
  - Recebe `storeOpen` e `unavailable`.
  - `currentStep` é forçado pra `"cart"` quando a sacola está vazia, a loja
    está fechada ou há item indisponível.
  - O "Prosseguir" dá lugar ao aviso certo. Loja fechada tem prioridade.
  - Item indisponível ganha a marca "indisponível hoje" e o "+" dele some.
  - "Limpar sacola" e "Remover" continuam funcionando.

### Testes (Vitest, junto dos arquivos, como já é na Bestie)
- Portar e adaptar os testes do Rock:
  - `estadoHoje.test.js` → `lib/storeState.test.js`, com KV falso num `Map`.
  - `acoesHoje.test.js` → `lib/dayActions.test.js`.
  - `disponibilidade.test.js` → `lib/availability.test.js`, incluindo a
    armadilha das 21h e a virada da meia-noite.
  - `sessao.test.js` → `lib/session.test.js`.
  - `DisponibilidadeContext.test.jsx` → `lib/useAvailability.test.jsx`.
  - `PainelHoje.test.jsx` → `app/hoje/page.test.jsx`, fingindo só o `Date`.
- Novos:
  - Card indisponível.
  - Aviso de loja fechada.
  - Gaveta bloqueada por loja fechada e por item indisponível, inclusive a
    volta da etapa "Seus dados" pra sacola.
- Ajustar os testes que já existem:
  - `CartDrawer.test.jsx` passa `storeOpen` e `unavailable`.
  - `StorePage.test.jsx` mocka o `fetch` de `/api/cardapio-hoje` como `live`
    no `beforeEach`. Sem isso, o checkout fica bloqueado e os testes de pedido quebram.
- Cuidado já anotado na Bestie: fake timers junto com `userEvent.click`
  travam. Por isso, fake timers só no teste do hook (sem userEvent) e no
  painel (`toFake: ['Date']`).

### Documentação
- `README.md`:
  - A seção de deploy passa a falar de Cloudflare: comandos, KV, secret e as
    armadilhas do webpack e do `workerd.exe`.
  - Nova seção "Painel /hoje": como a dona usa, como trocar a senha
    (`wrangler secret put PAINEL_SENHA`) e o que o cliente vê em cada modo.
  - A tabela "onde editar" ganha o horário.
- **A senha não entra em arquivo nenhum versionado.** O Rock tem a senha em
  texto no `ESTADO.md`; esse hábito não vem junto.
- Salvar este plano em `docs/superpowers/plans/2026-09-25-painel-hoje.md`,
  como nas rodadas anteriores.

## Ordem de execução

1. Criar a branch `painel-hoje` no repo do site. Commits como
   `cauedev30 <cauefranco01@gmail.com>`.
2. Infra Cloudflare e `.dev.vars`. Conferir que `npm run dev` sobe e que o KV
   local responde.
3. Lógica pura com testes (TDD), depois rotas, depois painel, depois cardápio e
   gaveta, depois ajuste dos testes antigos.
4. Atualizar o README e salvar o plano em `docs/`.
5. **Deploy, só com o teu ok**, porque põe o site no ar:
   - `wrangler kv namespace create ESTADO_HOJE` e colocar o id no `wrangler.jsonc`.
   - `wrangler secret put PAINEL_SENHA`, com uma senha gerada que eu te passo
     aqui no chat.
   - Rodar `npm run cf:deploy`.
   - Merge na `main` e push.

## Verificação

- `npm test` todo verde, `npm run lint` limpo e `npm run build` (webpack) sem erro.
- `npm run dev` + navegador:
  - `/hoje` sem sessão pede senha. Senha errada mostra "senha incorreta".
  - Com a senha certa, o painel carrega.
  - "Abrir o dia" faz o `/` mostrar o cardápio ao vivo em até 45s (ou num reload).
  - Desligar um cookie apaga o card, manda ele pro fim da grade e troca o botão
    pela pílula.
  - Com esse cookie na sacola, o "Prosseguir" fica bloqueado com o aviso.
  - "Fechar o dia" mostra o aviso de loja fechada, e a gaveta não deixa finalizar.
  - Testar no celular pelo IP da rede (`npx next dev -H 0.0.0.0`).
- `npm run cf:preview` roda o worker local com KV antes do deploy.
- Depois do deploy, na URL `workers.dev`:
  - Login e toques funcionando.
  - A mudança chega no celular (no Rock levou uns 15s).
  - Um pedido de teste chega no WhatsApp.
  - A prévia do link aparece no WhatsApp.

## Aviso operacional pra passar pra Bestie

Com o painel no ar, **o site só aceita pedido depois que ela toca "Abrir o dia"**,
e isso vale todo dia. Se ela esquecer, o cliente vê "estamos fechados". É a mesma
regra do Rock.
