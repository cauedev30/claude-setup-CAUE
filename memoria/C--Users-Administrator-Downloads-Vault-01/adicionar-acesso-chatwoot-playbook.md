---
name: adicionar-acesso-chatwoot-playbook
description: "Playbook genérico no vault para adicionar atendente novo em qualquer conta Chatwoot do projeto (Patos, Ananindeua, Fortaleza, Mossoró, Tucuruí, Parnamirim etc.), não só uma unidade específica"
metadata: 
  node_type: memory
  type: reference
  originSessionId: ea5fda93-0027-44ac-a3df-3151994b5aba
  modified: 2026-08-19T15:52:54.478Z
---

Nota `Knowledge/Adicionar Acesso Chatwoot.md` no vault — playbook generalizado a partir da sessão de
2026-08-19 (Lincon Emanuel em [[chatmultgni-parnamirim]]). Criado porque o usuário disse que vai fazer
os próximos acessos de **outros clientes também via API** (ex.: Cartão de Todos Patos, ver
[[chatmultgni-patos-cadastrado]]).

**Conteúdo:** Passo 0 decide o caminho — conta cadastrada no Supabase (`chatwoot_units`) usa o workflow
n8n `20`; conta fora dele usa o Caminho B (API direta do Chatwoot). Traz a receita completa do Caminho B
(Platform Token do Chatwoot hardcoded em `conciliation-team-creator-main/src/pages/Index.tsx:55`, admin
token via `GET /platform/api/v1/users/{id}`, sempre `GET /agents` antes de criar, ler o padrão real de
time/regra/oversight da conta-alvo antes de replicar — não copiar de outra conta) e as 7 regras
permanentes do projeto (nunca somar em `team_members`/`inbox_members` sem ler a lista atual primeiro,
nunca confiar na tela de sucesso, os três retornos de erro `401`/`404` da Platform API).

**How to apply:** antes de provisionar/remover atendente em QUALQUER conta deste projeto (não só
Parnamirim), ler esta nota primeiro. Ela não substitui o histórico por conta — só generaliza o "como
fazer". Ver [[consulta-por-api-nao-navegador]] e [[um-passo-de-cada-vez]].
