---
name: skill-curriculo-camaleao
description: "Skill global curriculo-camaleao: desde 2026-10-09 a base candidato.md é do Cauê (a do Daniel foi apagada a pedido dele); direção AI Full Stack Engineer no currículo inteiro; MiKTeX instalado e PDF testado"
metadata:
  node_type: memory
  type: project
  originSessionId: 863398be-48b4-47fb-8ec5-2927d225372f
  modified: 2026-10-10T02:52:33.769Z
---

Skill `curriculo-camaleao` em `~/.claude/skills/curriculo-camaleao/`, copiada de github.com/dv-dev1/claude-setup (commit 4e94455) em 2026-10-08.

- **2026-10-09:** `references/candidato.md` passou a ser a base do Cauê. Ele mandou tirar tudo do Daniel ("pode tirar tudo, substituir pelas minhas"). O original do Daniel continua no repo dele.
- Direção dele: "eu me posiciono como AI Full Stack Engineer [...] não só os projetos, mas todo o currículo". Ver [[posicionamento-ai-full-stack-engineer]].
- Projetos do currículo: só o agente de atendimento, o provisionamento no Chatwoot e o site de pedidos. Números: só os já publicados ("pode deixar as estatísticas assim").
- **ESTRUTURA OBRIGATÓRIA (09/10/2026):** o `template.tex` reproduz exatamente o PDF `Daniel_Vieira_Geral_Engenheiro_IA_Automacao_n8n.pdf` ("deixa esse currículo como base obrigatória... o que vai mudar são as informações"). Sem seção Projetos: projeto vira bullet da experiência; freelance é entrada própria. Única exceção: sem certificação, a seção sai (decisão dele).
- Decisões de 09/10: GeniAI numa entrada só (11/2025 a presente, João Pessoa, PB; estágio citado no cargo); freelance em andamento, remoto, início 07/2026 tirado do 1º commit do repo `bestie-cookies-LP` (não foi fala dele, pode corrigir).
- **Primeira pessoa no currículo inteiro**, inclusive no resumo (ele reclamou de "construiu", "desenvolve" em 09/10). A regra está em `regras-ats.md` e no checklist; o modelo do Daniel era em terceira pessoa, não copiar isso.
- Categoria "Backend e Frontend" virou **"Full Stack"** (pedido dele). Fatos novos dele em 09/10: Make, Flask, SQLite3, policies, UBTech = sistema de gestão operacional + modelagem de BD.
- **Currículo base aprovado (09/10):** `references/curriculo-base.tex` (cópia da versão geral). Todo currículo novo parte dele. Regra dele: "não sejam inventadas mentiras, apenas adaptações [...] alterar palavras-chave e colocar os meus projetos voltados ao que a vaga solicita". Mudou dado da base? Atualize `curriculo-base.tex` e `candidato.md` juntos.
- Versão geral gerada: `Downloads/Caue_Franco_Geral_AI_Full_Stack_Engineer.pdf` (fonte em `~/Documents/curriculo-camaleao-build/`).
- PDF funciona: MiKTeX 25.12 (escopo usuário, `%LOCALAPPDATA%\Programs\MiKTeX\miktex\bin\x64`), AutoInstall ligado; template compilado com exit 0 em 2026-10-09.

**Why:** a skill veio de outra pessoa; a base agora é dele, então novo dado de carreira vai para `candidato.md` (e para a nota do vault `Knowledge/Perfil Profissional - LinkedIn e GitHub`).
**How to apply:** gerar direto com a base dele; não perguntar mais de quem é o currículo. Telefone fica só na base da skill, não no vault.
