---
name: skill-curriculo-camaleao
description: "Skill global curriculo-camaleao: desde 2026-10-22 a fonte ÚNICA é o curriculo-base.tex (candidato.md removido); o que ele confirma pra uma vaga NÃO vai pra base; frase fixa do Claude Code no fim de Metodologias"
metadata:
  node_type: memory
  type: project
  originSessionId: 863398be-48b4-47fb-8ec5-2927d225372f
  modified: 2026-10-22T16:29:40.237Z
---

Skill `curriculo-camaleao` em `~/.claude/skills/curriculo-camaleao/`, copiada de github.com/dv-dev1/claude-setup (commit 4e94455) em 2026-10-08. Base do Cauê desde 2026-10-09 (a do Daniel foi apagada a pedido dele).

- **FONTE ÚNICA (22/10/2026):** só o `references/curriculo-base.tex` (currículo original aprovado em 09/10). O `candidato.md` foi removido porque acumulava confirmações de vagas anteriores (Dialogflow, Watson, Automation Anywhere, C#, PHP, Power Platform...) que vazavam pros currículos seguintes. Fala dele: "deixa só o currículo original como fonte única de conhecimento, aí fazemos adaptações de acordo com a vaga". Backup em `~/Documents/curriculo-camaleao-build/_backup-base/` (não usar pra gerar).
- Vaga pede algo fora da base → perguntar; se ele confirmar, entra SÓ naquele currículo e NÃO vai pra base. Base só muda com pedido explícito dele.
- Regras de redação (1ª pessoa, AI Full Stack Engineer, marca do cliente fora, números só os da base, sem travessão, não afirmar mudança de cidade) moraram no candidato.md e agora estão no SKILL.md.
- **Frase fixa (22/10/2026):** a linha "Ferramentas e Metodologias" SEMPRE termina com `Claude Code: workflow agêntico (harness, guardrails, contexto versionado, evals, policies)`.
- Só o que a vaga pede: ver [[curriculo-so-o-que-a-vaga-pede]]. Posicionamento: [[posicionamento-ai-full-stack-engineer]].
- Estrutura obrigatória: `template.tex` (sem seção Projetos; sem certificação, a seção sai).
- PDF: MiKTeX 25.12 (`%LOCALAPPDATA%\Programs\MiKTeX\miktex\bin\x64`); build em `~/Documents/curriculo-camaleao-build/`, PDF final `~/Downloads/Cauê_Franco_<Empresa>.pdf`.

**Why:** a base contaminada fazia cada currículo herdar adaptações de outras vagas.
**How to apply:** gerar sempre a partir do curriculo-base.tex; confirmação de vaga fica na vaga.

**22/10/2026, stack de reserva:** a pedido dele, a stack detalhada do agente de atendimento (GeniAI) e do site do restaurante (freelance) entrou no `curriculo-base.tex` como comentários `% STACK DE RESERVA`, invisíveis no PDF. São fatos confirmados: quando a vaga pedir um item, enriqueça bullet e Competências sem perguntar de novo; sem pedido da vaga, fica fora. SKILL.md regra 4 da "Fonte única".
