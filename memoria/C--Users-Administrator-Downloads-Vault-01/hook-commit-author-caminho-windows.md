---
name: hook-commit-author-caminho-windows
description: "A hook enforce-commit-author.js bloqueia commits com identidade \"(vazio)\" se o cd usar caminho /c/... do Git Bash; use C:/... no cd do comando de commit"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f8aaaaf3-a133-47cc-841d-22dffe8d9ed0
  modified: 2026-09-18T16:35:04.167Z
---

A hook `~/.claude/hooks/enforce-commit-author.js` extrai o diretório do `cd` no comando e roda `git -C <dir> config` via Node (fora do MSYS). Caminho `/c/Users/...` não resolve lá → lê identidade vazia → bloqueia com "identidade git deste repositório é (vazio)" mesmo com `git config --local` correto.

**Why:** perdi três tentativas achando que o config não tinha gravado; o `.git/config` estava certo o tempo todo.

**How to apply:** em todo comando Bash que contenha `git commit`, faça `cd "C:/Users/..."` (letra de unidade), nunca `/c/...`. Antes do primeiro commit num clone novo, grave `git config user.name/email` local num comando SEPARADO — a hook roda antes do comando e não vê o config gravado na mesma linha. Ver [[commits-repos-caue-autor-unico]].
