---
name: consulta-por-api-nao-navegador
description: Ele prefere que eu consulte sistemas por API direta (PowerShell) em vez de pela extensão do Chrome
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5286aeae-0acd-4928-93ee-a45333d73341
  modified: 2026-08-12T17:16:30.990Z
---

Quando precisar ler dados de um sistema dele (Chatwoot, n8n, Supabase), **puxar por API direta**, não pela
extensão do Chrome. Disse isso explicitamente em 2026-08-12, depois de eu ter feito uma auditoria inteira
via `javascript_tool` na aba do Chatwoot.

**Why:** a API dá o dado bruto, completo e sem truncar; pelo navegador eu dependo da sessão logada, os
resultados vêm cortados e é mais lento. Ele também raciocina melhor em cima do retorno cru.

**How to apply:** o token do Chatwoot de cada unidade está em `chatwoot_unit_credentials` no Supabase —
buscar de lá com o token `sbp_` via Management API (`/database/query`), usar em variável de sessão e não
gravar em arquivo (regra 7 do projeto). Em PowerShell 5.1, ler a resposta com
`[System.Text.Encoding]::UTF8.GetString($r.RawContentStream.ToArray())` para não corromper acento.
**Exceção:** o navegador continua necessário para disparar workflow n8n com Manual Trigger — a API pública
não executa (e o disparo é `Ctrl+Enter`, não o clique no botão). Ver [[chatmultgni-tucurui]].
