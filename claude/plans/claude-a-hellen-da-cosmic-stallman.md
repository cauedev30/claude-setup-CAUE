# Bestie Cookies: ajustes pedidos pela Hellen (2026-09-26)

## Contexto

A Hellen (Bestie Cookies) mandou uma lista de ajustes de texto e visual pro site que está no ar em `bestie-cookies.pedidos-jp.workers.dev`. São trocas de conteúdo, a remoção dos desenhos de cookie do fundo e dois links novos (WhatsApp com mensagem pronta e Google Maps). O código fica em `clientes/Bestie Cookies/site/`, um repo git próprio que hoje está limpo e em dia com `origin/main` (68868f3).

Decisões já tomadas com o Cauê:
- "Marca d'água dos cookies" são as **silhuetas de cookie no fundo** (`CookieBackdrop`). Saem de todas as seções: menu, vídeo, carrossel e Sobre.
- **Commit, push e deploy só quando o Cauê mandar.** Até lá tudo fica local e sem commit.

Caminhos abaixo são relativos a `clientes/Bestie Cookies/site/`.

## Mudanças

### 1. "Menu" no lugar de "Cardápio"
- `components/Menu.js:20`: `<h2>Cardápio</h2>` vira `<h2>Menu</h2>`.
- `app/layout.js:39-43` (aba do navegador e prévia do link): title e openGraph.title viram `Bestie Cookies — Menu`, e a description vira `Menu digital da Bestie Cookies. Monte seu pedido e finalize direto no WhatsApp.`
- Fica como está: o `id="cardapio"`, o `href="#cardapio"` e a rota `/api/cardapio-hoje` (são internos), e os textos do painel `/hoje` (só a Hellen vê).

### 2. Tirar as silhuetas de cookie
- Tirar o `import CookieBackdrop` e o `<CookieBackdrop … />` de `Menu.js`, `Croc.js`, `PhotoCarousel.js` e `Sobre.js`.
- Apagar `components/CookieBackdrop.js`, `components/CookieBackdrop.module.css` e `components/cookieShapes.js`, que ficam sem uso.
- Desfazer o CSS que só existia por causa da camada de silhuetas (adicionado nos commits 6acaa1e e 9bb4e0e):
  - `Menu.module.css`: sai o bloco `.section` e o comentário acima dele. Em `.menu` saem `position: relative; z-index: 1`. Em `Menu.js` a `<section id="cardapio">` perde o `className`.
  - `Croc.module.css`: em `.croc` saem `position: relative; overflow: hidden` e o comentário. Em `.content` saem `position: relative; z-index: 1`.
  - `PhotoCarousel.module.css`: a mesma limpeza em `.section`, `.track` e `.dots`.
  - `Sobre.module.css`: a mesma limpeza em `.sobre` e `.content`.
  - O header é `sticky` com `z-index: 10`, então tirar esses `z-index: 1` não muda nada na sobreposição.
- `README.md`: sai a linha "Desenhos de cookie no fundo" da tabela "Onde mexer" e o item "Os desenhos de fundo são aria-hidden…" da parte de acessibilidade.

### 3. Frase do vídeo (`components/Croc.js:55-57`)
- A legenda "Aperta o play e sente a casquinha estalar e o recheio escorrer." é trocada por **"Um cookie de verdade precisa ser crocante por fora, super macio por dentro e com um sabor irresistível."**
- O kicker "Sem filtro, sem corte" e o título "Dá pra ouvir o croc?" continuam, porque o pedido foi trocar só essa frase.

### 4. Legenda do Kinder (`data/products.js:67-75`)
- A description passa a ser exatamente: "Cookie de chocolate black intenso, com o recheio extremamente cremoso do Kinder Bueno (leite com avelã) e finalizado com pedaços de Kinder Bueno."
- O comentário acima do produto passa a dizer que a descrição veio da Bestie em 2026-09-26 e que o preço (R$ 22,50) continua provisório.
- No `README.md`, em "Pendências com a cliente", a linha do Kinder vira "Preço definitivo do Kinder Bueno (hoje provisório, R$ 22,50)."

### 5. Quadros do final (`components/Sobre.js`)
Constantes no topo do arquivo. O README já aponta o `Sobre.js` como o lugar de "Localização, redes". O formato `wa.me/<número>?text=` é o mesmo do `buildWhatsAppLink` em `lib/cart.js`:
```js
const ADDRESS = "Rua José Faustino Cavalcanti, 717 - Pedro Gondim, João Pessoa - PB, 58031-180";
const MAPS_LINK = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(ADDRESS)}`;
const WHATSAPP_LINK = `https://wa.me/${whatsappNumber}?text=${encodeURIComponent(
  "Olá, vim pelo site e gostaria de saber mais sobre as encomendas."
)}`;
```
- **Localização**: saem "João Pessoa - PB" e o texto solto "Encomendas pelo WhatsApp".
  - Entra o endereço em duas linhas: "Rua José Faustino Cavalcanti, 717" e "Pedro Gondim, João Pessoa - PB, 58031-180". "Pedro Gondim" e "João Pessoa - PB" levam espaço não separável, pra não quebrarem no meio no quadro estreito do desktop.
  - Embaixo do endereço entra o link **"Ver no Maps"** (`MAPS_LINK`, abre em nova aba).
- **Redes sociais**: o link "WhatsApp" vira **"Encomendas pelo WhatsApp"** e aponta pra `WHATSAPP_LINK`. O Instagram continua igual.
- **Horários**: sem mudança.
- Se a Bestie tiver perfil no Google Maps, dá pra trocar depois o link de busca pelo link do perfil. É só mudar o `MAPS_LINK`.

### 6. Descrição do final da página (`components/Sobre.js:14-19`)
- O parágrafo único é trocado pelos três parágrafos que a Hellen mandou, usados exatamente como vieram. O título "Mais que um cookie, um presente." continua.
- `Sobre.module.css`: entra `.content p + p { margin-top: 16px; }`. Hoje os parágrafos têm `margin: 0` e ficariam grudados.
- Um detalhe pra repassar à Hellen se quiser: o último parágrafo repete "transforma" ("se transforma em gesto… que transforma momentos"). O texto entra sem mudança.

## Teste novo: `components/Sobre.test.jsx`

Escrito antes de mexer no `Sobre.js`, e tem que falhar primeiro. Segue o padrão Vitest + Testing Library do `StorePage.test.jsx`.
- O link "Encomendas pelo WhatsApp" tem origin + path igual a `https://wa.me/${whatsappNumber}` (importado de `@/lib/siteConfig`), e o `searchParams.get("text")` é igual à mensagem exata.
- O link "Ver no Maps" tem origin + path igual a `https://www.google.com/maps/search/`, com `api=1` e `query` igual ao endereço exato.

Os testes que já existem não dependem de nenhum texto alterado. Conferi que `StorePage.test.jsx` não depende, e o `/cardápio inteiro/` de `app/hoje/page.test.jsx` é do painel, que não muda.

## Verificação
1. Rodar `npx vitest run` (com o teste novo), `npm run lint` e `npm run build`. Tudo tem que passar.
2. Com `npx next dev -p 3000` rodando, usar o script CDP do `docs/superpowers/plans/2026-09-24-detalhes-visuais.md` (Task 5, Step 2), estendido pra tirar prints em 390px e 1280px de:
   - o título "Menu"
   - o card do Kinder
   - a seção do vídeo
   - o carrossel
   - o Sobre (texto e quadros)

   O que conferir nos prints:
   - nenhuma silhueta em lugar nenhum
   - `document.documentElement.scrollWidth` igual à largura da tela (sem rolagem lateral depois de tirar os `overflow: hidden`)
   - endereço e "Encomendas pelo WhatsApp" quebrando limpo
   - card do Kinder sem desalinhar a grade
3. Abrir os dois links: o WhatsApp tem que abrir com a mensagem preenchida e o Maps tem que cair no endereço certo.
4. Mandar os prints pro Cauê e **parar**, esperando a ordem de publicar.

## Publicação (só quando o Cauê mandar)
- Fazer o commit no repo `clientes/Bestie Cookies/site/` com a identidade local `cauedev30 <cauefranco01@gmail.com>` (já configurada), depois `git push origin main`.
- Rodar `npm run cf:deploy` (worker `bestie-cookies`, sem tocar em `rock-n-cookies` nem no KV `ESTADO_HOJE`) e conferir o site publicado.
- Depois do deploy, atualizar a memória do projeto: silhuetas removidas, "Menu" no título, descrição oficial do Kinder, preço do Kinder ainda pendente.
