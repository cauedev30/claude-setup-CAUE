# Sabores do Dia + rename "Sem recheio" → "Tradicional"

## Contexto

Pedido do Cauê e da Karen: quando a loja está aberta, todo cookie disponível
hoje sobe pra uma seção nova no topo do cardápio, "Sabores do Dia". As
categorias originais continuam lá embaixo, só com os indisponíveis (apagados,
visual `.fora` que já existe). Como as categorias se misturam na seção nova,
cada card ganha uma tag dizendo de onde veio (Tradicional / Recheado /
Especial), no mesmo vocabulário da tarja "Novidade".

Decisões fechadas com o Cauê:
- "Sem recheio" vira **"Tradicional"** em todo lugar visível (site e painel
  `/hoje`). O id interno `'sem-recheio'` fica — está em 4 produtos, testes e
  ESTADO; só o rótulo muda.
- Tag de categoria pousa no **canto inferior esquerdo da foto**, reta. Novidade
  segue no topo direito (torta), sticker do astro no topo esquerdo. O Speculoos
  leva Novidade + Especial ao mesmo tempo.
- Loja fechada (modo referência): **layout de hoje**, três seções cheias, sem
  Sabores do Dia, ninguém apagado. O site não afirma o que não sabe.

Defaults que assumi (sem perguntar, são consequência do pedido):
- Seção de categoria sem nenhum indisponível **não renderiza** (heading sem card
  embaixo não ajuda ninguém). Com tudo desligado, Sabores do Dia some e as três
  seções voltam cheias e apagadas.
- Tag de categoria **não aparece** nas seções apagadas — lá o heading já diz.
- Ordem dentro de Sabores do Dia: tradicional → recheado → especial, e dentro
  de cada uma a ordem do array `produtos.js` (Speculoos continua abrindo os
  Especiais por posição no catálogo, como a Karen pediu).

## Como funciona hoje (o que muda)

- `src/components/Cardapio.jsx` filtra 3 arrays no módulo e renderiza 3 seções
  hardcoded, cada uma passando por `ordenarPorDisponibilidade` (partição
  estável em `src/lib/disponibilidade.js:64-70`).
- `src/components/ProductCard.jsx:33-37` calcula `foraHoje` e mostra a tarja
  `badge` só quando não está fora. `.imgWrap` já é `position: relative;
  overflow: hidden` (`ProductCard.module.css:122-130`).
- `src/app/hoje/page.jsx:8-12` tem seu próprio `GRUPOS` com "Sem recheio".
- `__tests__/Cardapio.test.jsx` lê a ordem via `getAllByRole('heading', {level: 3})`
  filtrado por listas de nomes; trava Speculoos abrindo Especiais e a Novidade
  sumindo quando ele está fora.

## Arquitetura da mudança

### 1. Fonte única de categorias — `src/data/produtos.js`

Antes do array `produtos`:

```js
// Ordem de exibição e rótulos das categorias — fonte única pro cardápio, a
// seção "Sabores do Dia", a tag do card e o painel /hoje. O id 'sem-recheio'
// fica como está; só o que a pessoa lê mudou pra "Tradicional".
export const CATEGORIAS = [
  { id: 'sem-recheio', titulo: 'Tradicional', tag: 'Tradicional' },
  { id: 'recheado',    titulo: 'Recheados',   tag: 'Recheado' },
  { id: 'especial',    titulo: 'Especiais',   tag: 'Especial' },
];
```

Atualizar o comentário de cabeçalho do arquivo (linha 2) pra citar CATEGORIAS.

### 2. Lógica pura — `src/lib/disponibilidade.js`

`separarSaboresDoDia(produtos, { modo, indisponiveis })` **substitui**
`ordenarPorDisponibilidade` (remover a função, o import no Cardapio e os 4
testes dela — código morto não fica).

```js
import { CATEGORIAS } from '@/data/produtos';

// Divide o catálogo entre "Sabores do Dia" e o que sobra em cada seção de
// categoria. Ao vivo: disponíveis vão todos pra saboresDoDia, na ordem das
// CATEGORIAS e, dentro de cada uma, na ordem do catálogo; porCategoria fica só
// com os indisponíveis. Em referência não existe "hoje": saboresDoDia vazio e
// porCategoria é o catálogo inteiro.
export function separarSaboresDoDia(produtos, { modo, indisponiveis }) {
  const aoVivo = modo === 'ao-vivo';
  const foraDoAr = new Set(aoVivo ? indisponiveis : []);
  const saboresDoDia = [];
  const porCategoria = {};
  for (const { id } of CATEGORIAS) {
    const daCategoria = produtos.filter((p) => p.categoria === id);
    if (!aoVivo) { porCategoria[id] = daCategoria; continue; }
    saboresDoDia.push(...daCategoria.filter((p) => !foraDoAr.has(p.id)));
    porCategoria[id] = daCategoria.filter((p) => foraDoAr.has(p.id));
  }
  return { saboresDoDia, porCategoria };
}
```

Retorno: `{ saboresDoDia: Produto[], porCategoria: { 'sem-recheio': [], recheado: [], especial: [] } }`.
Ordem entre categorias vem de `CATEGORIAS`, não do array de entrada (teste
força isso com fixture embaralhada).

### 3. Vitrine — `src/components/Cardapio.jsx`

Some os 3 arrays de módulo. Cada seção vira `<section aria-labelledby>` com o
`h3` recebendo `id` — vira `role="region"` com nome acessível, o que os testes
usam pra isolar seção sem `data-testid`.

```jsx
const { saboresDoDia, porCategoria } = separarSaboresDoDia(produtos, { modo, indisponiveis });
...
<AvisoReferencia />

{saboresDoDia.length > 0 && (
  <section aria-labelledby="grupo-sabores-do-dia">
    <h3 id="grupo-sabores-do-dia" className={`${styles.grupo} ${styles.grupoDia}`}>Sabores do Dia</h3>
    <div className={styles.grid}>
      {saboresDoDia.map((p) => <ProductCard key={p.id} produto={p} mostrarCategoria />)}
    </div>
  </section>
)}

{CATEGORIAS.map(({ id, titulo }) => {
  const lista = porCategoria[id];
  if (lista.length === 0) return null;
  return (
    <section key={id} aria-labelledby={`grupo-${id}`}>
      <h3 id={`grupo-${id}`} className={styles.grupo}>{titulo}</h3>
      <div className={styles.grid}>
        {lista.map((p) => <ProductCard key={p.id} produto={p} />)}
      </div>
    </section>
  );
})}
```

Comentários em pt-BR explicando o porquê (só ao vivo; seção vazia some). Sem
`useMemo` — 20 itens. Card que troca de seção remonta; único estado local é
`semSticker`, irrelevante.

`src/components/Cardapio.module.css`, depois de `.grupo`:

```css
/* "Sabores do Dia" é a seção que manda com a loja aberta — pink pra se
   destacar dos rótulos de categoria (amarelo) sem inventar cor nova. */
.grupoDia { background: var(--pink); }
```

### 4. Card — `src/components/ProductCard.jsx` + `.module.css`

- Prop nova: `ProductCard({ produto, mostrarCategoria = false })`.
- `const tagCategoria = mostrarCategoria ? CATEGORIAS.find((c) => c.id === produto.categoria)?.tag : null;`
- Último filho de `.imgWrap` (por cima da `<Image fill>`):
  `{tagCategoria && <span className={styles.categoriaTag}>{tagCategoria}</span>}`
- Comentário: só em Sabores do Dia, onde as categorias se misturam; nas seções
  de categoria seria redundante com o heading. Não depende de `foraHoje` — a
  grade de baixo nunca passa a prop.
- `BADGES` e regra do sticker (`categoria !== 'especial'`) intocados.

CSS, depois do bloco `.badge` (espelha os tamanhos dele; fundo `--paper` e não
amarelo porque duas pílulas amarelas na mesma foto do Speculoos brigariam):

```css
.categoriaTag {
  position: absolute; left: 6px; bottom: 6px; z-index: 2;
  background: var(--paper); color: var(--ink);
  font-family: var(--font-mono); font-weight: 700; text-transform: uppercase;
  letter-spacing: 0.08em; font-size: 0.58rem; line-height: 1;
  padding: 0.28rem 0.55rem; border-radius: 999px;
  border: 2px solid var(--ink); box-shadow: var(--shadow-hard-sm);
}
@media (min-width: 640px) {
  .categoriaTag { left: 8px; bottom: 8px; letter-spacing: 0.1em; font-size: 0.66rem; padding: 0.32rem 0.68rem; }
}
```

### 5. Painel — `src/app/hoje/page.jsx`

Apagar `GRUPOS` (linhas 8-12), importar `{ produtos, CATEGORIAS }`, e no loop
da linha 233 usar `CATEGORIAS.map((grupo) => ... key={grupo.id} ...
grupo.titulo ... p.categoria === grupo.id)`. Nada mais muda (a lista
`indisponiveis` guarda ids de produto).

## Ordem de execução (TDD — teste vermelho antes de cada passo)

1. **`__tests__/produtos.test.js`** — `describe('CATEGORIAS')`: ids na ordem
   exata `['sem-recheio','recheado','especial']`; conjunto de ids == conjunto
   de `produtos.map(p => p.categoria)`; nenhum `titulo`/`tag` casa
   `/sem recheio/i`; `titulo` de `sem-recheio` é `'Tradicional'`. → Implementar
   `CATEGORIAS`.

2. **`__tests__/disponibilidade.test.js`** — `describe('separarSaboresDoDia')`
   com fixture fora de ordem de categoria (`cure/especial, freddie/recheado,
   hendrix/sem-recheio, elvis/recheado`):
   - ao vivo, nada fora → `saboresDoDia` `['hendrix','freddie','elvis','cure']`, `porCategoria` tudo `[]`
   - ao vivo, `['freddie','cure']` fora → `saboresDoDia` `['hendrix','elvis']`; `porCategoria.recheado` `['freddie']`, `.especial` `['cure']`
   - ao vivo, todos fora → `saboresDoDia` `[]`, `porCategoria` completo em ordem de catálogo
   - referência com lista velha `['freddie']` → `saboresDoDia` `[]`; `porCategoria` = catálogo inteiro
   - não muta o array de entrada
   → Implementar a função (manter `ordenarPorDisponibilidade` até o passo 4).

3. **`__tests__/ProductCard.test.jsx`** — adicionar `categoria: 'recheado'` ao
   fixture; `describe('ProductCard — tag de categoria')`: com `mostrarCategoria`
   → `getByText('Recheado')`; sem a prop → null; `categoria: 'sem-recheio'` com
   a prop → `'Tradicional'`; prop + `badge: 'mais-vendido'` → os dois textos
   presentes. → Implementar prop + JSX + `.categoriaTag`.

4. **`__tests__/Cardapio.test.jsx`** — reescrever. Helpers:
   ```js
   import { render, screen, within } from '@testing-library/react';
   const TRADICIONAIS = ['Hendrix','Lennon','Sabrina','Michael'];
   const RECHEADOS = ['Freddie','Elvis','Lana','Rita','Ritaleena','Bon Jovi','Slash','Bowie','Ozzy','Avril','Bob'];
   const ESPECIAIS = ['Speculoos','The Cure','Lovesong','Blondie Bueno','Johnny Crunch'];
   const CATALOGO = [...TRADICIONAIS, ...RECHEADOS, ...ESPECIAIS];
   const secao = (nome) => screen.queryByRole('region', { name: nome });
   function nomesNaSecao(nome) {
     return within(screen.getByRole('region', { name: nome }))
       .getAllByRole('article')
       .map((a) => within(a).getByRole('heading', { level: 3 }).firstChild.textContent);
   }
   const cardDe = (nome) => screen.getByRole('heading', { level: 3, name: new RegExp(`^${nome}`) }).closest('article');
   ```
   Casos:
   - ao vivo, nada fora → `nomesNaSecao('Sabores do Dia')` == `CATALOGO`; `secao('Tradicional'|'Recheados'|'Especiais')` null
   - ao vivo, `['elvis','lennon','lovesong']` fora → Sabores do Dia = CATALOGO sem os três; `'Tradicional'` `['Lennon']`, `'Recheados'` `['Elvis']`, `'Especiais'` `['Lovesong']`; 3 `indisponível hoje`, nenhum dentro de Sabores do Dia
   - ao vivo, só `['elvis']` fora → só `secao('Recheados')` existe embaixo
   - ao vivo, todos os 20 fora → `secao('Sabores do Dia')` null; três seções cheias
   - tag em cada card de Sabores do Dia: `'Tradicional'` ×4, `'Recheado'` ×11, `'Especial'` ×5 (via `within`)
   - tag ausente na seção apagada: com `['elvis']` fora, `within(secao('Recheados')).queryByText('Recheado')` null
   - Speculoos ligado → `cardDe('Speculoos')` tem `'Novidade'` e `'Especial'`; índice em Sabores do Dia == `TRADICIONAIS.length + RECHEADOS.length`
   - Speculoos desligado → `nomesNaSecao('Especiais')` `['Speculoos']`; sem `'Novidade'`; sem `'Especial'` no card
   - referência com lista velha `['elvis','ozzy']` → sem Sabores do Dia; três seções == listas originais; sem `indisponível hoje`; sem tag `'Recheado'`
   - Novidade fica em referência (mantido)
   - rename: heading `'Tradicional'` existe; `queryByText(/sem recheio/i)` null
   → Implementar `Cardapio.jsx` + `.grupoDia`. Depois **remover**
   `ordenarPorDisponibilidade`, seu `describe` e o import no teste.

5. **`src/app/hoje/page.jsx`** — trocar `GRUPOS` por `CATEGORIAS`. Sem teste
   novo (não existe teste da página; o rótulo é travado pelo teste de dado).

6. **`ESTADO.md`**:
   - Seção "Cardápio (20 cookies)": "Sem recheio" → "Tradicional (id interno
     `sem-recheio`, mantido de propósito)"; ordem vem de `CATEGORIAS`; o
     parágrafo do Speculoos passa a descrever a regra nova (ligado abre os
     Especiais **dentro de Sabores do Dia**; desligado cai apagado lá embaixo).
   - Bloco novo "Layout do cardápio ao vivo vs referência" com a regra, a
     função `separarSaboresDoDia`, a remoção de `ordenarPorDisponibilidade`, a
     prop `mostrarCategoria`.
   - Entrada "Da sessão de 2026-09-15" em Feito, com as decisões e a nota de que
     o **pulo do primeiro load** (página pinta referência, reorganiza quando o
     fetch chega) ficou mais visível — fora de escopo, resposta principiada
     continua "estado inicial vindo do servidor".
   - Atualizar contagem de testes em "Como rodar".

## Pontos exatos de contato (verificados nos arquivos)

- `__tests__/disponibilidade.test.js:2` — tirar `ordenarPorDisponibilidade` do
  import e apagar o `describe` das linhas 115-137.
- `__tests__/ProductCard.test.jsx:8-11` — o fixture `produto` **não tem**
  `categoria`; adicionar `categoria: 'recheado'`. O helper
  `comDisponibilidade(valor, ui)` (linha 73) já serve pros testes novos.
- `__tests__/produtos.test.js` — só tem um `describe('produtos')`; o de
  `CATEGORIAS` entra depois dele, importando `{ produtos, CATEGORIAS }`.
- `src/data/produtos.js:1-3` — atualizar o comentário de cabeçalho pra citar
  `CATEGORIAS` como fonte de ordem e rótulo.
- `src/app/hoje/page.jsx:233-237` — o loop usa `key={grupo.categoria}` e
  `p.categoria === grupo.categoria`; passa a `grupo.id`.
- Tokens confirmados em `globals.css`: `--pink: #F0559E`, `--paper: #FBF1DC`,
  `--ink: #1A1512`, `--shadow-hard-sm: 2px 2px 0 var(--ink)`.
- Scripts confirmados no `package.json`: `test` = `vitest run`, `lint` =
  `eslint`, `build` = `next build --webpack`, `cf:deploy` = opennextjs.

## Fora de escopo (registrar, não fazer)

- Pulo de layout no primeiro load (pendência já existente, agora maior).
- `docs/superpowers/**` e `saidas/painel-hoje-mockup.html` ainda dizem "Sem
  recheio" — histórico/protótipo, não tocar.
- Deploy: só se o Cauê pedir.

## Verificação

1. `npm test` — tudo verde, anotar a contagem nova.
2. `npm run lint` — limpo.
3. `npm run build` (`next build --webpack`; não trocar pra Turbopack — quebra em
   runtime no Windows).
4. Manual com `npm run dev` (precisa de `.dev.vars` com `PAINEL_SENHA`): abrir
   `/hoje`, logar, "Abrir o dia", desligar 1-2 cookies de categorias
   diferentes. Na home: Sabores do Dia em pink no topo, tags nos cards,
   Speculoos com Novidade + Especial, seções de baixo só com os apagados, seção
   vazia sumindo. "Fechar o dia" → layout de referência com heading
   "Tradicional". Painel mostra "Tradicional". Conferir em largura de celular
   (duas colunas): a tag não pode virar faixa — se ficar grande, encolher
   `font-size`/`padding` mobile da `.categoriaTag`.
5. Screenshot headless (Chrome via CDP, como nas sessões anteriores) pra
   validar posicionamento — jsdom não faz layout.
6. Se for deployar: matar `workerd.exe` órfão antes e depois de
   `npm run cf:deploy`; reiniciar `next dev` depois.
