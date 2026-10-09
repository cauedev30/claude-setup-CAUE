---
name: skill-criar-site-cartao-de-todos
description: Skill global criar-site-cartao-de-todos substitui a SKILL_cdt.md do repo para gerar LP de unidade Cartão de Todos; a metade de deploy do repo está morta
metadata: 
  node_type: memory
  type: project
  originSessionId: a773a5db-946a-4f17-a2c6-1dc4aa07f144
  modified: 2026-10-01T03:45:41.779Z
---

Existe uma skill pessoal global `criar-site-cartao-de-todos`
(`C:\Users\Administrator\.claude\skills\criar-site-cartao-de-todos\`), criada em 2026-09-16 a partir do
repo `github.com/cauedev30/criador-de-sites-padrao`. Dispara quando ele fala em criar/gerar/subir site
ou LP de unidade Cartão de Todos. Traz um script `scripts/gerar-site.sh` que copia o template,
substitui os 9 placeholders e **reprova** (exit 1) se sobrar `{{...}}`, se faltar razão social/CNPJ em
alguma das 4 páginas ou se o JSON-LD virar JSON inválido.

**Why:** a `SKILL_cdt.md` que está dentro do repo tem a metade de deploy **morta** — são passos de
`sudo nginx`, `/var/www`, `/home/matheus/projetos` e origin `5.161.238.162` (prod2, que o próprio
CHANGELOG do repo diz ter sido substituído). O deploy real é `deploy_repo` no MCP `painel-dokku`. Ler a
SKILL_cdt.md do repo e segui-la ao pé da letra leva pro caminho errado.

**Versionada no repo desde 2026-09-16** (commit `5062bc5`), em
`skills/criar-site-cartao-de-todos/`. **O repo é a fonte da verdade da skill**, mas a cópia que
RODA é a de `~/.claude/skills/` — editar a local e esquecer de subir faz as duas divergirem em
silêncio. Reinstalar/atualizar: `cp -r skills/criar-site-cartao-de-todos ~/.claude/skills/`.
As 3 `SKILL_*.md` antigas ganharam um aviso no topo (commit `38f48c5`) marcando a seção de deploy
como desatualizada — nenhuma foi removida, porque AMS e genérico não têm substituto.

**How to apply:** use a skill, não a `SKILL_cdt.md` do repo. Ver
[[painel-dokku-mcp-deploy-lps]], [[razao-social-sempre-caixa-alta]], [[lp-formiga-cdt]].

**Os dois defeitos do template foram CORRIGIDOS em 2026-09-16** (commit `3671246`): o
`{{DISCLOSURE_FRANQUIA}}` entrou no rodapé das 3 páginas legais, e a regra responsiva entrou tanto no
`.logo-text` da navbar quanto no `.legal-logo` das legais — esse segundo tinha o mesmo defeito e nunca
tinha sido notado. O portão do `gerar-site.sh` voltou a exigir disclosure nas 4 páginas. Não remendar
por LP de novo; se aparecer quebrado, o template está desatualizado na cópia local.

**Pendência separada, levantada e não tratada:** o repo é público e expõe o IP de origem
`5.161.238.162` e o caminho `/home/matheus/projetos` nas 3 skills antigas. prod2 está morto, risco
baixo, mas é infra dele em repo aberto. Ele ainda não decidiu.
→ **Em 2026-09-30 o repo já estava PRIVADO e renomeado para `criador-de-sites-padrao-cdt`.** O nome
antigo redireciona. A skill foi atualizada pro nome novo no commit `7238649`.

**Passo 6 obrigatório desde 2026-10-01** (pedido dele, "determinístico"):
`scripts/verificar-publicacao.sh <dominio> <pasta>`. Deploy só fecha com ele verde, para qualquer LP
do painel (CDT, AMS, genérica). A skill também dispara com "site no loading infinito". Ver
[[lp-amparo-ams]].
