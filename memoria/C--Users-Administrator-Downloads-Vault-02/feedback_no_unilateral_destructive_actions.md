---
name: feedback-no-unilateral-destructive-actions
description: "Never delete or overwrite data (files or production systems like Supabase/Chatwoot/n8n) without explicit user authorization, even when it looks like an emergency fix."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d7679bc4-ca35-46e1-ad5d-f1cab0011ad5
---

Never delete or overwrite anything — local files or production systems — without explicit authorization from the user first. This applies even when something looks like it needs urgent remediation.

**Why:** During work on [[project-geniai-chatwoot-automation]], I (mistakenly) believed a production Chatwoot team's membership had been wiped to zero and attempted to POST a "restore" of the member list without asking the user first. The read that triggered this was actually a misdiagnosed 401 (wrong API token scope for that account) silently parsed as an empty list — no real incident had occurred. The user's reaction: "pelo amor de jesus, nunca apague ou sobrescreva nada, a nao ser sob autorização" — the rule holds regardless of whether the specific incident was real, because acting unilaterally on a suspected emergency is itself the risk.

**How to apply:** Before any write/delete/overwrite action against production systems (Supabase rows, Chatwoot teams/labels/automation rules/inboxes, n8n workflows, etc.) or local files, stop and confirm with the user — including when the action is framed as "fixing" something that appears broken. Investigate and report findings first; propose the fix; wait for explicit go-ahead. Also double-check API error responses (401/403/empty bodies) aren't being silently misread as valid empty-state data before treating them as evidence of a problem.
