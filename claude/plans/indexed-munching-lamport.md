# Refino para a entrevista: grade de meses no filtro de período

## Contexto

A etapa 3 (painel mais intuitivo) está pronta, com commit local `d84f80b`, e o Cauê gostou. Um ponto
ficou feio: no painel do período, o De/Até são `<select>` nativos, que abrem uma lista comprida de 45
meses descendo pela tela (a "cascata" da imagem). Ele escolheu trocar por uma **grade de meses de–até**:
um ano por vez, com ‹ › para trocar de ano, os 12 meses em grade, o 1º clique marca o início, o 2º o
fim, e o intervalo fica pintado em cobre.

## Decisões

| # | Decisão |
|---|---|
| G1 | Sai o De/Até em `<select>`. No lugar, embaixo dos atalhos, a grade: cabeçalho "‹ 2026 ›" e os meses em 4 colunas × 3 linhas ("jan", "fev"…) |
| G2 | 1º clique: marca o início, e a dica muda para "Agora o mês de fim". 2º clique: fecha o intervalo (se for antes do início, os dois trocam de lugar), aplica o filtro e fecha o painel, como os atalhos |
| G3 | O intervalo atual aparece pintado: início e fim em cobre cheio; os meses do meio, em cobre claro. Passando o mouse depois do 1º clique, o intervalo provisório aparece igual |
| G4 | Meses fora dos dados (antes de jan/2023, depois de set/2026) ficam apagados e não clicáveis; as setas param em 2023 e 2026 |
| G5 | A grade abre no ano do fim do período. Cada mês é um botão com o nome por extenso para o leitor de tela ("outubro de 2025") |

## Tarefas (etapa 3, complemento)

Repositório: `repo/web/`. Commit local na `main`; push só com ok.

**3.6 Funções da grade, com teste**
- `src/formatar.ts`: `mesPorExtenso('2025-10')` → `"outubro de 2025"`; `nomeDoMes('2025-10')` → `"out"`.
- `src/navegacao/rotas.ts`: `ANOS_DOS_DADOS` (`[2023, 2024, 2025, 2026]`, de `PRIMEIRO_MES` a `ULTIMO_MES`);
  `mesesDoAno(ano)` → os 12 `AAAA-MM`; `mesNosDados(m)` (exporta a regra que o `lerHash` já usa);
  `posicaoNoIntervalo(m, de, ate)` → `'inicio' | 'fim' | 'unico' | 'meio' | null`;
  `ordenarIntervalo(a, b)` → `{ de, ate }` com o menor primeiro.
- Testes em `testes/painel/formatar.test.ts` e `rotas.test.ts`.

**3.7 Componente da grade**
- Novo `src/componentes/GradeDeMeses.tsx` (+ `.module.css`). Props: `de`, `ate`,
  `aoEscolher(de, ate)`. Estado: o ano exibido (começa no ano de `ate`), o início pendente e o mês sob
  o mouse.
- Cabeçalho com 2 botões de seta (`aria-label` "Ano anterior"/"Próximo ano", desabilitados nas pontas)
  e o ano no meio (`aria-live="polite"`).
- Cada mês: `<button>` com `data-posicao` (G3), `disabled` fora dos dados (G4) e `aria-label` por extenso
  (G5). Visual: raio de 6 px; início e fim com fundo `--cobre` e texto `--fundo`; meio com
  `color-mix(--cobre 16%)`; hover com borda cobre; `transition` de cor em 150 ms.
- Dica embaixo, em `--texto-2`, 0.75rem: "Clique no mês de início e no de fim" / "Agora o mês de fim".
- Ícone: a seta "‹ ›" usa o traço `seta` que já existe, girado (sem ícone novo).

**3.8 Ligar no filtro**
- `src/componentes/Filtros.tsx`: troca o bloco `.exato` (os 2 `Seletor`) pela `GradeDeMeses`, com
  `aoEscolher={(de, ate) => { navegar({ de, ate }); fechar() }}`; tira o `Seletor`, as `opcoesDeMes` e o
  import de `mes`.
- `src/componentes/Filtros.module.css`: tira `.exato`, `.caixa` e `.seletor`; a grade ganha o mesmo
  separador (borda em cima) que o `.exato` tinha.
- Pronto quando: o painel do período não tem mais nenhum `<select>`.

**3.9 Verificação e registro**
- `docs/spec.md` 6.2 (Filtros): o De/Até vira a grade de meses.
- Workspace: as tarefas 3.6 a 3.9 no plano `09` e o andamento.

**Ponto de parada:** o Cauê confere no navegador; push com ok à parte (já inclui a etapa 3).

## Verificação

1. Em `repo/web`: `npm test` e `npm run build` verdes, com os testes novos.
2. No navegador (preview local, recarregando a página), por JavaScript:
   - o painel abre com a grade de 2026, set/2026 como fim e out–dez/2026 apagados;
   - ‹ vai a 2025; clicar em mar/2025 e depois em jan/2025 aplica jan/2025–mar/2025 (trocou a ordem),
     fecha o painel e o botão mostra "jan 25 – mar 25";
   - reabrindo, jan e mar/2025 em cobre cheio e fev em cobre claro; ‹ para em 2023.
3. Celular (moldura de 390 px): a grade cabe no painel, sem rolagem lateral.

## Checklist

- [ ] 3.6 Funções da grade
- [ ] 3.7 Componente da grade
- [ ] 3.8 Ligar no filtro
- [ ] 3.9 Verificação e registro
- [ ] **Parada:** o Cauê confere no navegador; push com ok à parte
