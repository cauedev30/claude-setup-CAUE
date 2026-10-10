---
name: claude-setup-caue-repo
description: "Backup do setup do Claude em cauedev30/claude-setup-CAUE (PRIVADO), com exportar.ps1 e instalar.ps1; rodar o export depois de mudar skill, hook, MCP ou memória"
metadata:
  node_type: memory
  type: project
  originSessionId: 0a20ecc1-2d2e-439f-9cc9-544ed60395f0
  modified: 2026-10-10T02:56:35.787Z
---

Repo `github.com/cauedev30/claude-setup-CAUE`, clone em `C:\Users\Administrator\Desktop\claude-setup-CAUE`. Primeiro push em 2026-10-08 (`c9d5648`).

- **Privado por decisão dele** (2026-10-08): leva as memórias, que têm dados de clientes. Não tornar público. Para o amigo, ele adiciona como colaborador, e o amigo instala com `instalar.ps1 -Amigo` (sem memórias, planos, `.gitconfig` e o hook de autoria `cauedev30`).
- **O `-Amigo` instala TODAS as skills**, inclusive a `curriculo-camaleao` com a base e o currículo dele (telefone, e-mail). Ele sabe e decidiu não mexer (2026-10-09): "não vou passar isso pra nenhum amigo... se um dia eu for passar, eu tiro antes". Não reabrir; só lembrar se ele for de fato instalar para alguém.
- Atualizar: `powershell -ExecutionPolicy Bypass -File .\exportar.ps1 -Publicar` no clone. A varredura de segredos aborta antes do commit se achar token.
- Nunca entram: `.credentials.json`, tokens de MCP (viram `{{MCP_...}}` e o instalador pede), transcrições/`history.jsonl`, notas do vault (só o esqueleto).
- Detalhes que já morderam: `ConvertFrom-Json` do PS 5.1 recusa o `~/.claude.json` (chaves `c:/` e `C:/` duplicadas), então o export lê com JavaScriptSerializer. `.gitattributes` `* -text` é obrigatório (CRLF quebra os `.sh` da skill CDT). Os scripts precisam de BOM UTF-8. No PS 5.1 com `$ErrorActionPreference='Stop'`, até `2>$null` em programa externo vira erro fatal: toda chamada externa passa pela função `Externo` (corrigido em `aace10e`).
- O winget, os plugins e o cadastro de MCP do instalador NÃO foram testados de verdade (só o ensaio com `-PularProgramas -PularClaude`); confira na primeira restauração real.

**Why:** ele quer poder trocar de máquina e ficar com o Claude exatamente igual.
**How to apply:** quando mudar o setup (skill nova, hook, MCP, plugin), lembre que o repo fica desatualizado até rodar o export; ofereça rodar. Commits seguem [[commits-repos-caue-autor-unico]] e [[hook-commit-author-caminho-windows]].
