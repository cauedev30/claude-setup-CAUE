---
name: chatmultgni-mossoro
description: "CDT Mossoró é a conta 6 no Chatwoot; Monalisa provisionada 2026-08-13 pelo workflow 20 + alinhamento manual; padrão da conta é conversation_updated, e a Triagem não recebe atendente"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8e5cbe20-252d-4d4c-b153-ae1252110f5f
  modified: 2026-08-13T19:17:44.349Z
---

**CDT Mossoró = conta 6** no Chatwoot (`appchatfvk.geniai.online`), UF **RN**. Unidade nova para o projeto,
cadastrada no Supabase em 2026-08-13 como `cdt_mossoro_1782` (inbox 197, triagem 39) — só **1 linha**, para
o inbox vivo, de propósito.

**Monalisa Medeiros** (agente 484) provisionada em 2026-08-13: time 410 `[484, 10, 11]`, regra 500, inboxes
197/166/146/194, **fora da Triagem**, **sem label**. Sessão fechada sem pendência para ela — falta só o
teste funcional com conversa real, que depende do usuário.

Três coisas não óbvias desta conta:

1. **A Triagem (39) não tem atendente nenhum** — só `11` (CDT Mossoró) e `10` (Gestão). Diferente das outras
   contas CDT. Colocar atendente lá é mudança de comportamento, não "completar o cadastro".
2. **A conta não usa label** (0 no total) e **todos os times pessoais têm `10` + `11` como supervisão.** O
   workflow `20` erra nos dois: cria label e não adiciona oversight. Ambos corrigidos à mão para a Monalisa
   em 2026-08-13, por decisão do usuário.
3. **Inbox 229 está vivo e sem nenhum membro.** Não é dial morto como os casos de
   [[chatmultgni-ananindeua]] e Fortaleza — tem tráfego real. Não investigado.

**O `20` nunca adiciona supervisão ao time pessoal.** Nas duas execuções reais dele (Moziane/409 em
Tucuruí, Monalisa/410 aqui) o time saiu com uma pessoa só; nas feitas à mão pelo Caminho B a supervisão
entrou sempre. O **409 da Moziane continua sem** — ver [[chatmultgni-tucurui]].

**O padrão `conversation_updated` + `assignee_id` → `assign_team` já é maioria** (Ananindeua, Fortaleza,
Mossoró), não exceção. O `message_created` + `team_id` que o workflow `20` cria só vale em Tucuruí/Patos.
Ler as automation rules da conta antes de assumir qualquer padrão.

**Dá para rodar o `20` sem o Claude-in-Chrome:** Claude prepara por API (Supabase + node `Entrada`), o
usuário dá `Ctrl+Enter` na UI **depois de F5** (sem o F5 roda com os dados do cliente anterior), Claude
confere por API. Ver [[consulta-por-api-nao-navegador]].

**Armadilha de ferramenta:** `ConvertFrom-Json` do PowerShell 5.1 quebra ao ler workflows do n8n (chaves
duplicadas `Supabase`/`SupaBase`). Usar Node.
