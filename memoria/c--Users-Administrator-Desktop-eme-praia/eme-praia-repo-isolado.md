---
name: eme-praia-repo-isolado
description: O repo da loja Eme Praia leva só código — nada do MazyOS pode vazar pro GitHub da cliente
metadata: 
  node_type: memory
  type: project
  originSessionId: 6d06b037-0153-4574-b194-deea7230839f
  modified: 2026-09-09T19:55:39.676Z
---

O código da loja Eme Praia vive em `clientes/eme-praia/`, dentro do workspace
MazyOS, mas é um **repositório git próprio e independente**, com remote separado:
`https://github.com/cauedev30/eme-praia-LP` (branch `main`, público).

O GitHub da loja leva **só o código**. Nada do MazyOS — nem memória de negócio,
nem briefing, nem contexto do Cauê. A documentação técnica do projeto vive no
repositório da loja, no GitHub, porque é entregável da cliente.

**Why:** o MazyOS guarda informação comercial do Cauê (tom de voz, gargalos,
precificação, estratégia). Se isso vazar pro repositório que a cliente tem acesso,
é constrangedor e expõe informação de negócio dele.

**How to apply:** o `.gitignore` da raiz do MazyOS ignora `clientes/eme-praia/`
inteira, então não existe caminho em que os dois se misturem. Ao trabalhar no
código, conferir com `git rev-parse --show-toplevel` em qual repositório o commit
vai cair.

Relacionado: [[git-commits-conta-caue]], [[caue-um-mazyos-por-cliente]]
