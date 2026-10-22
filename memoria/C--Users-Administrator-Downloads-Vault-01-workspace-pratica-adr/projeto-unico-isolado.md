---
name: projeto-unico-isolado
description: "workspace-pratica-adr tem um projeto só, o painel de BI da ADR, isolado do resto do vault e sem nenhuma ligação com o antigo simulador"
metadata:
  node_type: memory
  type: project
  originSessionId: 694cbf2c-4efc-4a1f-af6d-037e787264f9
  modified: 2026-10-14T03:20:44.986Z
---

O `workspace-pratica-adr` existe para um projeto só: o painel de BI comercial e de recebíveis da ADR Empreendimentos. É o projeto de portfólio da candidatura do Caue à vaga de Analista de Dados Júnior. O app é web, em React + Vite, e roda PostgreSQL no navegador pelo PGlite. Até 2026-10-14 o plano era usar DuckDB-WASM; o PGlite entrou no lugar para que a afirmação "o banco é PostgreSQL" seja verdadeira.

**Why:** Em 2026-10-13 o Caue apagou o antigo `workspace-simulador-adr` e disse: "Pode esquecer tudo do outro [...] não suje o contexto dessa sessão com aquele outro. Eu criei essa pasta aqui dentro da Vault justamente para ter um contexto isolado."

**How to apply:**
- Não reaproveite decisões, specs nem código do simulador antigo, nem cite esse projeto. Isso vale também para a regra de "repo privado sem aviso de protótipo".
- Cada decisão deste projeto é tomada de novo, com o Caue.
- O código e os arquivos de trabalho ficam nesta pasta. A exceção é a nota do vault `Projects/Active/Painel de Dados ADR.md`, que ele pediu em 2026-10-14 para guardar a explicação aprovada do projeto. A seção literal dessa nota não deve ser alterada.
