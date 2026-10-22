---
name: herdr-windows-setup
description: herdr e Herdr UI foram instalados em 2026-10-14 e DESINSTALADOS no mesmo dia a pedido dele; não reinstalar nem sugerir sem ele pedir
metadata:
  node_type: memory
  type: reference
  originSessionId: 450b11c5-3e5f-4f25-8574-48594d0f5ba3
  modified: 2026-10-14T19:23:58.454Z
---

O herdr 0.9.5 (terminal) e o Herdr UI (app desktop, repo penso/herdr-gpui) foram instalados em 2026-10-14 e **desinstalados por completo no mesmo dia, a pedido dele** ("tirar tudo relacionado ao Herdr", na limpa da config global do Claude).

- Saiu do Claude: o hook SessionStart do settings.json, o `hooks/herdr-agent-state.ps1` e a skill `herdr-gpui-browser`. O backup ficou em `~/.claude/backups/remocao-herdr-2026-10-14/`.
- Saiu do Windows: `~\.herdr`, `%LOCALAPPDATA%\Programs\Herdr` (junction), `%LOCALAPPDATA%\Programs\Herdr UI`, `%APPDATA%\herdr` (config e tema clear-dark), `%LOCALAPPDATA%\herdr`, o atalho do Menu Iniciar e as 2 entradas do PATH do usuário. Nenhum dos dois tinha desinstalador registrado, porque foram instalados por script.
- Se ele voltar a querer o herdr: no Windows a config fica em `%APPDATA%\herdr\` (não em `~/.config`). Reinstalar recria o hook do Claude.
