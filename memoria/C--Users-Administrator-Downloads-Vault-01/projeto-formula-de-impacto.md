---
name: projeto-formula-de-impacto
description: "Repo github.com/dv-dev1/formula-de-impacto (não é dele) — clone em Desktop\\formula-de-impacto; cauedev30 só tem pull, sem push; 2 commits locais de 2026-09-18 aguardando decisão de fork+PR"
metadata: 
  node_type: memory
  type: project
  originSessionId: f8aaaaf3-a133-47cc-841d-22dffe8d9ed0
  modified: 2026-09-23T02:19:49.974Z
---

App Next.js (export estático, Cloudflare Pages) de entrevista de campo "CAIXA Fórmula de Impacto". Dono é `dv-dev1`; `cauedev30` tem `push: false`, então subir mudança exige colaborador ou fork + PR.

Cópia de trabalho: `C:\Users\Administrator\Desktop\formula-de-impacto` (fora da vault). Em 2026-09-18 ficaram 2 commits locais sem push: `c2ff4ad` (try/catch na tranca de login, `components/Tranca.jsx`) e `43019ca` (aspas do glob em `npm test`, que no Windows rodava 0 testes). Ele disse "depois a gente vê para dar o push".

Achados não corrigidos, de propósito: chave `"acesso-formula-impacto"` duplicada em `app/page.jsx:63`; README diz 31 testes (são 32); sem freio de tentativas no PIN (coerente com o intento declarado, não é bug).

**ENTREGUE 2026-09-22 via PR #1 em dv-dev1/formula-de-impacto** (fork `cauedev30/formula-de-impacto`, branch `entrega-2026-09-22`): só as 2 correções de bug (login + npm test) + `ENTREGA.md`, rebaseado no master dele, CI verde, MERGEABLE, aguardando o amigo aprovar. O acesso de colaborador que ele prometeu NUNCA chegou (`push: false`, zero convites pendentes) — por isso fork+PR.

**Banco saiu do escopo dele; quem assume é o amigo. Não retomar Supabase sem ele pedir.** O trabalho de sync foi tirado do PR e parqueado no branch `sincronizacao-supabase-wip` (no fork, `da0a9e3`). `supabase/schema.sql` NUNCA foi executado contra um Postgres.

**Cuidado ao voltar:** em 22/09 o amigo empurrou 4 commits (23 arquivos, incluindo `.github/workflows/ci.yml`) e implementou sozinho o MESMO carimbo em `salvarEntrevista`, com nome diferente — `atualizadaEm` (dele) vs `alteradaEm` (meu). Se retomar o sync, adotar o nome dele. O CI dele falha por fetch do Google Fonts (`next/font`) de forma intermitente: rerun resolve, não é regressão.

**Sync com Supabase (desenhado 2026-09-18, spec em `specs/2026-09-18-sincronizacao-supabase.md`):** projeto Supabase novo; propósito é backup + consolidado central; coordenador cria as contas no painel (entrevistador não se cadastra); áudios sobem só no Wi-Fi; entrevista inteira sobe e a mais nova vence (sem log de eventos); pendência mora na própria entrevista (`alteradaEm`/`sincronizadaEm`), não em fila no localStorage; id é `text` porque `novoId()` cai em fallback sem `crypto.randomUUID`; nada de DELETE, só `apagada_em`. Painel do coordenador ficou pra spec próprio.

Plano de implementação em `specs/2026-09-18-sincronizacao-supabase-plano.md` (10 tarefas TDD, o arquivo em si NÃO commitado). **Tarefas 1 e 2 executadas e commitadas em 2026-09-18** (`3388a6c` carimbo `alteradaEm`/`aparelhoId` em `lib/aparelho.mjs`; `4e4269c` decisão de pendência em `lib/sincronizar.mjs`); 45 testes passando. Parou na Tarefa 3 porque exige projeto Supabase criado por ele. Plano e spec ficam em `specs/`, não em `docs/superpowers/` — a convenção é do repo, que não é dele. Três armadilhas que a autorrevisão pegou e que valem pra qualquer mudança nesse repo: (1) `apagarEntrevista` apaga do IndexedDB na hora, então marcar `apagada_em` no servidor exige separar marcar de remover; (2) áudio precisa de `enviadoEm` gravado LOCALMENTE senão cada sync re-sobe os MB; (3) mexer na primeira tela da tranca quebra `passarPelaTranca` em `scripts/cdp.mjs`, e com isso `npm run validar` e `npm run test:ui` juntos.

Como testar o login: Claude in Chrome não conectava; funcionou com Chrome headless `--remote-debugging-port=9223` + `scripts/cdp.mjs` do próprio repo, servindo `out/` com `node scripts/servir.mjs 3111 out`. Ele relatou um bug "na tela de login, pra receber o código" que ainda não foi descrito em detalhe — perguntar o sintoma exato antes de assumir que o try/catch resolveu. Ver [[hook-commit-author-caminho-windows]], [[um-passo-de-cada-vez]].
