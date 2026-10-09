---
name: feedback-git-identity
description: "Git commits in this workspace must use Cauê's personal identity, never the geniai session account"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4970577f-6e28-4820-bb6b-9f623b733afa
  modified: 2026-07-28T18:56:28.465Z
---

Always commit using the local repo-scoped git identity `cauedev30 <cauefranco01@gmail.com>` (a PreToolUse hook blocks commits unless user.name is exactly "cauedev30" — "Cauê Dev" is rejected) — never the "geniai" account tied to this Claude session's default email context (`geniai.contatohub@gmail.com`).

**Why:** Explicit instruction from Cauê when setting up the `clientes/Bestie Cookies/site/` repo: "commite apenas com a minha conta cauefranco01@gmail.com, não commite com a conta da geniai." This is his personal freelance GitHub identity, separate from any agency/session account.

**How to apply:** Before committing in any client project repo under this workspace (e.g. `clientes/*/site/`), verify `git config user.email` in that repo resolves to `cauefranco01@gmail.com` (set locally, not globally — see [[project-bestie-cookies]] for how it was configured). If a new client repo is created, set this identity locally on init before the first commit. Never rely on global git config for this.
