---
name: grill-me
description: Use ONLY when the user explicitly says "grill me" / "me grilla", OR before executing a high-stakes plan the user hasn't stress-tested yet (irreversible action, architecture decision, or a plan touching multiple systems/large scope). Do NOT use for small or routine changes — see "When NOT to use" below.
---

# Grill Me

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grill-me`. Interrogates a plan or design that already exists — it does not build one from scratch. Use it after a plan is proposed (by either party) and before committing to execute it.

## When to use

- The user explicitly asks to be "grilled" on a plan.
- **Or**, right before executing a plan that meets at least one of:
  - Hard to reverse (deleting/merging data, force-push, schema migration, sending something externally)
  - An architecture or design decision with more than one reasonable approach
  - Touches multiple systems/files/projects, or will take a long session to execute
  - The user has expressed uncertainty or asked "does this make sense?" about the plan

## When NOT to use

Do not trigger this for: routine edits, single-file fixes, anything already covered by `test-driven-development` / `systematic-debugging` mechanics, small clarifying questions that `AskUserQuestion` already handles in one round, or any task where the plan is obvious and low-stakes. If in doubt, don't grill — ask the one clarifying question you actually need and move on. This skill exists to prevent silent bad assumptions on *big* decisions, not to add ceremony to small ones.

## Process

1. Treat the plan as a decision tree. Before asking anything, identify the branches — the specific points where a different choice would meaningfully change the outcome.
2. Ask **one question at a time**, not a batch. Wait for the answer before asking the next.
3. For every question, **offer a recommended answer** — don't leave an open-ended question with no default. The user should be able to say "yes, that" instead of having to design the answer from scratch.
4. When a question can be answered by reading the code/repo/vault instead of asking, go read it — don't ask the user something you can verify yourself.
5. Keep going until every branch of the decision tree is resolved, not until the first comfortable stopping point.
6. Close by stating the shared understanding back in plain terms — the resolved plan, restating any decision that changed from the original proposal.

## Failure mode this prevents

Proposing a plan, getting a quick "sounds good," and only discovering a wrong assumption mid-execution — after the hard-to-reverse action already happened. This skill trades a few minutes of interrogation up front for not finding out about a bad assumption after the fact.
