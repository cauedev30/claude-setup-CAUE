---
name: git-commits-conta-caue
description: Todos os commits do projeto Eme Praia devem sair da conta cauefranco01@gmail.com
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3b6f9aa8-c3a9-4d9d-b9da-ce0d0a60000a
  modified: 2026-10-01T12:50:43.185Z
---

Nos projetos do Cauê, os commits são feitos **exclusivamente** como
`cauedev30 <cauefranco01@gmail.com>`. Configurar `git config user.name cauedev30`
e `git config user.email cauefranco01@gmail.com` localmente em cada repositório
novo, antes do primeiro commit. Nunca pôr trailer `Co-Authored-By` do Claude.

Um hook PreToolUse (`~/.claude/hooks/enforce-commit-author.js`) barra commit
fora disso. Ele lê o `cd` do comando e passa o caminho pro git do Windows:
no Bash, usar `cd "C:/Users/..."`, nunca `/c/Users/...` — com o formato do
Git Bash o hook lê a identidade como vazia e bloqueia mesmo com tudo certo.

**Why:** o e-mail global da máquina é `geniai.contatohub@gmail.com`, que não é a
conta de desenvolvedor dele. Sem o config local, os commits saem atribuídos à
conta errada e não aparecem no perfil do GitHub dele — que é o portfólio que ele
usa pra vender.

**How to apply:** ao criar qualquer repositório novo, rodar o `git config` local
como primeiro passo, antes de qualquer `git add`. Conferir com
`git config user.email` no começo de cada sessão de trabalho no repo.

Relacionado: [[eme-praia-repo-isolado]]
