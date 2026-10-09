---
name: skill-curriculo-camaleao
description: "Skill global curriculo-camaleao instalada 2026-10-08 a partir de dv-dev1/claude-setup; a base candidato.md é do Daniel, não do Cauê; não tem pdflatex na máquina"
metadata:
  node_type: memory
  type: project
  originSessionId: 0a20ecc1-2d2e-439f-9cc9-544ed60395f0
  modified: 2026-10-09T02:13:22.635Z
---

Skill `curriculo-camaleao` copiada sem alteração de github.com/dv-dev1/claude-setup (commit 4e94455) para `~/.claude/skills/curriculo-camaleao/` em 2026-10-08, a pedido dele ("logo vou usar").

- `references/candidato.md` é a base do **Daniel Vieira** (dono do repo, ver [[projeto-achei-no-campus]]). Se o currículo for do Cauê, a base precisa ser trocada — perguntar de quem é antes de gerar.
- Decisão dele em 2026-10-08: a base do Daniel fica como está e vira só um apêndice no fim do SKILL.md; ele vai montar a base dele depois. Não trocar nem adaptar sem ele mandar.
- PDF funcionando desde 2026-10-08: MiKTeX 25.12 via winget (escopo usuário, `%LOCALAPPDATA%\Programs\MiKTeX\miktex\bin\x64`, já no PATH do usuário), AutoInstall de pacotes ligado; template testado com acentos, exit 0. A Etapa 3 do SKILL.md já traz a nota pro Windows.

**Why:** a skill veio de outra pessoa e assume outra máquina e outro candidato.
**How to apply:** no primeiro uso, perguntar de quem é o currículo; se for dele e a base não existir, montar a base antes de gerar.
