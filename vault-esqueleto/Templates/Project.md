---
date: <% tp.date.now("YYYY-MM-DD") %>
tags:
  - project
status: active
---

# <% tp.file.title %>

## Overview

<% tp.file.cursor() %>

## Goals


## Architecture


## Key Decisions


## Tasks

```dataview
TABLE WITHOUT ID file.link AS "Task", status AS "Status", due AS "Due"
FROM "Tasks"
WHERE contains(file.outlinks, this.file.link)
SORT due ASC
```

## Recent Activity

```dataview
LIST FROM "Daily"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
LIMIT 10
```
