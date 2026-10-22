---
name: vaga-analista-dados-adr
description: "Usuário pode entrar como analista de dados jr na ADR Empreendimentos (incorporadora de compactos em JP); projeto de portfólio = simulador de investimento, workspace Vault_01/workspace-simulador-adr, repo privado cauedev30/simulador-adr"
metadata:
  node_type: memory
  type: project
  originSessionId: 8b100363-1112-4017-b46f-4710aa7f2fba
  modified: 2026-10-14T00:04:20.524Z
---

Em 2026-10-13 ele contou que talvez entre numa vaga de **analista de dados jr** na ADR Empreendimentos
(adrempreendimentos.com), incorporadora de João Pessoa/PB. A ADR faz compactos de alto padrão (studios
de 16 a 39 m², "Linha Mares") na orla, com discurso de investimento e rentabilidade. Data da entrevista:
desconhecida.

**Projeto escolhido (2026-10-13):** simulador de investimento em studio na planta. Compara temporada,
aluguel tradicional, CDI e IPCA+. Python (pipeline, motor, FastAPI, notebooks) + Next.js no front, com a
identidade visual da ADR.
- **Workspace:** `Vault_01/workspace-simulador-adr`, no padrão workspace-standard, como o do chatbot.
  Abra a sessão NESSA pasta; o AGENTS.md e o current-state.md de lá são a fonte.
- **Repo:** `cauedev30/simulador-adr`, PRIVADO, clonado em `repo/`. A spec está em `repo/docs/spec.md`.
- Escopo completo numa entrega só. Ele pediu explicitamente para **não dividir em v1/v2** nem em marcos.
- Sem aviso de protótipo no app, por decisão dele. O repo fica privado; perguntar antes de deixar público
  ou de fazer deploy.

**Why:** o projeto existe para conversar com o negócio da ADR. Ideia genérica de dados perde o sentido.
**How to apply:** ao retomar, leia o current-state.md do workspace. O próximo passo era ele reler a spec
e depois vir o plano de implementação (writing-plans). Relacionado: [[commits-pequenos-um-assunto]],
[[commits-repos-caue-autor-unico]].
