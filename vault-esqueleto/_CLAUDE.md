# Claude Operating Manual - CAUE's Vault

> Read this file before doing anything in this vault.
> This is the source of truth for how Claude/Codex should operate here.

---

## Vault Identity

- **Owner:** CAUE
- **Primary purpose:** Life OS and second brain for work, personal notes, projects, decisions, tasks, learning, and references.
- **Vault style:** Obsidian-style folders for human browsing, with optional `raw/` and `wiki/` folders for LLM-first ingestion.
- **Last updated:** 2026-04-22

---

## Folder Map

| Folder | Purpose |
|---|---|
| `Daily/` | One note per day. Named `YYYY-MM-DD.md`. |
| `Projects/` | Active and archived projects. |
| `Tasks/` | Standalone task notes linked from boards. |
| `Boards/` | Kanban boards. |
| `People/` | One note per person. |
| `Dev Logs/` | Technical work logs, dated and project-tagged. |
| `Knowledge/` | Reference material and permanent notes. |
| `Learning/` | Books, courses, videos, and articles consumed. |
| `Ideas/` | Fast idea captures and fragments. |
| `Content/` | Content calendar and drafts. |
| `Finances/` | Finance notes. Ask before writing sensitive details. |
| `Goals/` | Annual and life goals. |
| `Health/` | Health dashboard and habit notes. |
| `Mentions/` | Recognition, shoutouts, and important external mentions. |
| `Jobs/` | Employment and contract role notes. |
| `Businesses/` | Companies or businesses owned. |
| `Reviews/` | Weekly and monthly reviews. |
| `Templates/` | Note templates. Do not edit during routine capture. |
| `raw/` | Immutable source material: articles, transcripts, PDFs, videos. |
| `wiki/` | LLM-maintained workspace for entities, concepts, projects, logs, tasks, decisions. |
| `_trash/` | Soft-deleted notes only. Never hard delete unless explicitly asked. |

---

## Key Files

- **Dashboard:** `Home.md`
- **Catalog:** `index.md`
- **Activity log:** `log.md`
- **Identity:** `SOUL.md`
- **Always-load context:** `CRITICAL_FACTS.md`
- **Work board:** `Boards/Work.md`
- **Personal board:** `Boards/Personal.md`
- **Mentions log:** `Mentions/Mentions Log.md`

---

## Operating Rules

1. Read `_CLAUDE.md`, `CRITICAL_FACTS.md`, `index.md`, and `log.md` before making non-trivial vault changes.
2. Never create a note in isolation. Every new note should be linked from the daily note, relevant board, `index.md`, or a related entity/project note.
3. Search for an existing note before creating a new one. Prefer updating over duplicating.
4. Preserve source material in `raw/` and never modify it after capture.
5. Append changed facts with dates and sources. Do not erase old context unless asked.
6. Ask before writing sensitive financial, medical, legal, or private personal details.
7. Ask before deleting, archiving, renaming, or merging existing notes.

---

## Auto-Save Rules

Auto-save without asking:

- Decisions from a conversation -> relevant project note, daily note, `log.md`.
- New tasks -> `Tasks/`, relevant board, daily note.
- Project updates -> project note, board, daily note.
- Dev work -> `Dev Logs/`, project note, daily note.
- People or relationship context -> `People/`, daily note.
- Ideas and learnings -> `Ideas/` or `Knowledge/`, daily note.

Ask first:

- Anything involving money, health, legal risk, credentials, or highly personal information.
- Deleting, archiving, renaming, or merging notes.
- Large reorganizations of folders or naming conventions.

---

## Naming Conventions

- Daily notes: `YYYY-MM-DD.md`
- Dev logs: `YYYY-MM-DD - Description.md`
- People: full name, for example `Jane Smith.md`
- Projects: concise project name, for example `Second Brain Setup.md`
- Tasks: action-oriented title, for example `Configure Obsidian Dataview.md`
- Archive prefix: `_archived_`

---

## Frontmatter Minimum

```yaml
---
date: YYYY-MM-DD
tags:
  - note-type
---
```

Common note types: `daily`, `project`, `task`, `person`, `devlog`, `goal`, `mention`, `content`, `knowledge`, `idea`, `source`.

---

## Propagation Rules

| Event | Also update |
|---|---|
| New project | Board backlog, today's daily note, `index.md`. |
| Task created | Task note, relevant board, daily note. |
| Task completed | Board done column, project note, daily note. |
| Dev session | Dev log, project note, daily note. |
| Person interaction | Person note and daily note. |
| Decision made | Project note key decisions and daily note. |
| Source ingested | `raw/`, derived notes, `index.md`, `log.md`. |

---

## Recommended Obsidian Plugins

- Dataview for dashboards and dynamic lists.
- Templater for templates.
- Kanban for board files.
- Calendar for daily note navigation.

---

*Generated from eugeniughelbur/obsidian-second-brain and adapted for this Windows vault.*
