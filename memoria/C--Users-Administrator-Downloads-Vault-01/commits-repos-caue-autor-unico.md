---
name: commits-repos-caue-autor-unico
description: Commits nos repos dele saem como cauedev30 <cauefranco01@gmail.com> e SEM Co-Authored-By - ele quer ser o unico contribuidor; desde 2026-09-16 isso e imposto por hook global PreToolUse; push em repo publico so com aval explicito
metadata:
  type: feedback
---

Em todo repositório dele, o commit sai **só no nome dele** e **sem `Co-Authored-By`**:

- autor e committer: **`cauedev30 <cauefranco01@gmail.com>`** (já é o `git config` global da máquina);
- **nunca** adicionar linha `Co-Authored-By`, nem de assistente nem de mais ninguém;
- conferir depois do push **lendo a API** (`GET /repos/{owner}/{repo}/contributors`), não pelo
  retorno do `git push`.

⚠️ **`cauefranco01` não é usuário do GitHub** — é o **e-mail de login** (`cauefranco01@gmail.com`),
dono do usuário **`cauedev30`**. Quando ele diz "commita pela conta cauefranco01", é disso que fala.
Já gerou confusão antes; não procurar um usuário com esse nome.

**Push em repo público é ato dele.** Escrever local, mostrar o que ficou, e **só publicar com um
"pode" explícito** — mesmo quando o trabalho já foi aprovado em conteúdo.

**Why:** os repos públicos dele são **portfólio**. Um co-autor no histórico muda quem aparece como
autor do trabalho na página do repositório, que é exatamente o que o portfólio existe para mostrar.
E publicar é irreversível na prática: o histórico fica.

**How to apply:** commitar com `--author="cauedev30 <cauefranco01@gmail.com>"` quando houver dúvida,
sem rodapé de co-autoria, no formato de commit que o projeto exigir. Aplicado no
[[aula-java-repo-apsii]] e no [[tier0-chatbot-suporte-geniai]] (commit raiz de 2026-08-28).

---

**2026-09-16 — a regra virou hook, não depende mais de eu lembrar.** Ele reafirmou sem eu perguntar:
*"o claude nunca deve ser colaborador de nenhum projeto meu"*.

- `~/.claude/hooks/enforce-commit-author.js` + `PreToolUse` (matcher `Bash|PowerShell`) em
  `~/.claude/settings.json` — **escopo global**, vale em todo repo da máquina, não só na vault
  (a vault nem é repo git; ele escolheu global ciente disso).
- Bloqueia: `user.name`/`user.email` do repo diferentes de `cauedev30 <cauefranco01@gmail.com>`,
  `--author` de terceiro, `-c user.email=`, `GIT_AUTHOR_*`/`GIT_COMMITTER_*` e qualquer
  `Co-Authored-By` que cite Claude/Anthropic.
- `attribution: {commit: "", pr: ""}` no settings global desliga o rodapé automático do Claude Code
  em commits **e** PRs — o hook virou a segunda camada, não a única.
