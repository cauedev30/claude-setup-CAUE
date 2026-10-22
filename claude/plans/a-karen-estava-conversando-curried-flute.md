# Spec — Tema de Halloween da Rock n' Cookies

## Contexto

A Karen pediu sugestão de tema de Halloween pro site. O Cauê queria o site escuro, com roxo; ela
falou em cores de Halloween. A marca já tem metade do caminho: o laranja retrô é a cor primária e o
`--purple` (#7A3FCC) já existe pela tarja "Edição de Halloween". O cardápio tem a categoria
`halloween` (Ghost Bite, Ozzy) e o cartão de mensagem de Halloween (`config.cartao`).

Objetivo: durante a temporada, a loja (`/`) fica com cara de noite de Halloween e empurra os
especiais da temporada, sem perder o estilo adesivo, e volta ao normal com uma troca de config.
Prazo real: hoje é 20/10, o Halloween é dia 31. Escopo enxuto, no ar rápido.

## Decisões fechadas com o Cauê (20/10)

- **Paleta "Noite de Halloween":** fundo roxo quase preto, laranja da marca como principal, roxo de
  apoio, verde-limo no lugar do turquesa, pink rebaixado. **Cards continuam claros** (adesivo em
  parede escura), contorno e sombra dura pretos como hoje.
- **Halloween no topo:** os Especiais de Halloween sobem pro começo do cardápio na temporada.
- **Faixa de temporada** no formato do `AvisoDesconto`.
- **Desligar é manual:** uma chave em `src/config.js` + deploy (mesmo padrão de `config.cartao.ativo`).
  Sem data cravada.
- **Artes:** o Cauê vai mandar e dizer onde cada uma entra. Ficam fora desta spec; entram como etapa
  própria quando chegarem, sem travar o resto.

## Desenho

### 1. A chave
`config.temporada` em `src/config.js` (ex.: `'halloween'` ou `null`). Fonte única: o tema visual, a
ordem das categorias e a faixa leem daqui. Desligar = `null` + deploy.

### 2. O tema visual (só a loja)
- Escopo no route group `(loja)`: `src/app/(loja)/layout.jsx` ganha um wrapper com
  `data-tema="halloween"`. **O painel `/hoje` não muda** (é a ferramenta da Karen e vive fora do
  `(loja)`).
- Por token, não por componente: os acentos são reatribuídos sob `[data-tema="halloween"]` em
  `globals.css` (`--turq` → limo, `--pink` → roxo/pink rebaixado).
- **Armadilha:** `--ink` é texto E contorno, e `--cream` é fundo E cor de texto/preenchimento sobre
  escuro (ex.: `BarraPedido`). Inverter os dois quebra o adesivo. Por isso fundo e texto sobre fundo
  ganham tokens próprios (`--fundo`, `--sobre-fundo`, nomes a fechar no plano), usados só onde o
  texto encosta direto no fundo: body, Header, título/eyebrow/sub do Cardapio, Hero, Sobre, Carrossel
  (bolinhas), Footer (hoje já é `--ink`; precisa se separar do fundo escuro).
- Superfícies que ficam claras: ProductCard, CartDrawer/FormDadosCliente, ArteCartao, pílulas
  amarelas de seção e preço.
- Pontos a conferir olhando, não no CSS: logo (`logo-horizontal.png` tem contorno preto e pode sumir
  no escuro), contraste do texto sobre o fundo (meta 4,5:1), Sobre e `AvisoReferencia` (hoje
  turquesa, viram limo), overscroll do body (fundo creme aparecendo; `body:has([data-tema])` resolve).

### 3. Halloween no topo
Com a temporada ligada, `halloween` vira a primeira categoria: na vitrine (loja fechada) e dentro de
Sabores do Dia (loja aberta). A ordem hoje vem de `CATEGORIAS` em `src/data/produtos.js`, lida por
`Cardapio.jsx`, `separarSaboresDoDia` (`src/lib/disponibilidade.js`), `ProductCard` e `/hoje`.
Decisão em aberto pro plano: reordenar só na loja (função tipo `ordemCategorias(temporada)` usada
pelo Cardapio e por `separarSaboresDoDia`) ou mudar a ordem em todo lugar, painel incluso.
Recomendação: só na loja, pra não mexer na tela que a Karen já sabe usar.

### 4. Faixa de temporada
Componente novo no estilo do `AvisoDesconto`/`AvisoReferencia`, no topo do cardápio, em roxo
(`--purple`, texto papel, 5,5:1). Aparece com `config.temporada === 'halloween'`. Ordem: desconto
(se houver) → temporada → aviso de horário. **Texto a fechar com a Karen** — sem data, já que o
desligar é manual (ex.: "Edição de Halloween: Ghost Bite e Ozzy só nesta temporada").

### Fora do escopo
Decoração em SVG (morcego, teia), fonte de terror, neblina animada, mudar o painel `/hoje`, og:image
temática. Regra de sempre: sem emoji.

## Testes que mudam
- `__tests__/produtos.test.js` e `__tests__/Cardapio.test.jsx` travam a ordem
  Tradicional → Recheados → Especiais → Halloween: ganham o caso com temporada ligada.
- Testes novos: faixa aparece/some pela chave; wrapper com `data-tema` só na loja; `/hoje` sem tema.
- jsdom não faz layout: a parte visual se confere renderizada (Chrome headless com
  `/api/cardapio-hoje` falsificado, truque do ESTADO), celular 390px e desktop 1280px, loja aberta e
  fechada.

## Próximos passos (depois de aprovada esta spec)
1. Salvar a spec em `docs/superpowers/specs/2026-10-20-tema-halloween-design.md`.
2. Escrever o plano completo (etapas e tarefas, interfaces, testes, "pronto quando", checklist) em
   `docs/superpowers/plans/2026-10-20-tema-halloween.md` e passar pro Cauê aprovar.
3. Só então implementar. Subir com a loja fechada ou avisando a Karen; deploy só com o aval do Cauê.
4. Artes: etapa extra quando o Cauê mandar e disser onde cada uma fica.
