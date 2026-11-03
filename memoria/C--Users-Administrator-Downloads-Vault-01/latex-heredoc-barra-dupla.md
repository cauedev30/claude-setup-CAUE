---
name: latex-heredoc-barra-dupla
description: "Bash tool colapsa `\\\\` em `\\` no heredoc; currículo LaTeX sai com cabeçalho e competências grudados numa linha"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2778d743-7c7b-4037-a5cd-3cec3c4dc5cb
  modified: 2026-10-22T16:44:49.982Z
---

Ao gerar `.tex` do [[skill-curriculo-camaleao]] via heredoc no Bash tool, o `\\` de fim de linha virou `\` (aconteceu no Build_IT.tex e no BuildIT_NLP.tex, 22/10/2026). O PDF compila sem erro, mas Cargo/Período/Local, Competências e Idiomas saem grudados numa linha só. O Cauê só viu pelo print.

**Why:** compila sem erro, então o defeito passa batido se não olhar o PDF.
**How to apply:** escreva o `.tex` com a ferramenta Write (não heredoc), ou corrija com `perl -pi -e 's/ \x5c\r?$/ \x5c\x5c/'`; sempre abra o PDF com Read antes de entregar.
