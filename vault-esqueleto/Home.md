---
date: 2026-04-22
tags:
  - home
aliases:
  - Dashboard
---

# CAUE's Second Brain

This is the home dashboard for the vault.

## Quick Navigation

| Work | Life | System |
|---|---|---|
| [[Boards/Work]] | [[Goals/2026 Goals]] | [[Templates/]] |
| [[Projects/Overview|Projects]] | [[Health/Health Dashboard]] | [[People/]] |
| [[Tasks/]] | [[Mentions/Mentions Log]] | [[index]] |
| [[Dev Logs/]] | [[Content/Content Calendar]] | [[log]] |

## Recent Daily Notes

```dataview
TABLE WITHOUT ID
  file.link AS "Day",
  mood AS "Mood",
  energy AS "Energy"
FROM "Daily"
SORT date DESC
LIMIT 7
```

## Active Projects

```dataview
TABLE WITHOUT ID
  file.link AS "Project",
  status AS "Status"
FROM "Projects"
WHERE contains(tags, "project") AND status = "active"
SORT file.name ASC
```

## Open Tasks

```dataview
TABLE WITHOUT ID
  file.link AS "Task",
  status AS "Status",
  due AS "Due"
FROM "Tasks"
WHERE contains(tags, "task") AND status != "done"
SORT due ASC
```

## Vault Stats

```dataviewjs
const all = dv.pages("");
const people = dv.pages('"People"').length;
const projects = dv.pages('"Projects"').where(p => p.tags && p.tags.includes("project")).length;
const dailies = dv.pages('"Daily"').length;
dv.paragraph(`Notes: **${all.length}** | People: **${people}** | Projects: **${projects}** | Daily notes: **${dailies}**`);
```
