---
name: tcc-cicero-franco-revisao
description: "Estado da revisão do TCC de Cícero Franco de Almeida (curso TTI) — arquivo final pronto, 2 pendências"
metadata: 
  node_type: memory
  type: project
  originSessionId: dc2873f6-88e7-42d4-8c9e-3acd2d0f6f95
---

Em 2026-07-08 foi feita revisão completa do TCC "Gestão Administrativa do Corretor Autônomo no Mercado Imobiliário" (Cícero Franco de Almeida, Escola Técnica São Vicente de Paula, curso Técnico em Transações Imobiliárias). ~30 correções de citações/referências ABNT aplicadas via edição direta do XML do .docx.

**Arquivos em `C:\Users\Administrator\Downloads\`:** `TCC_CRECI_Cicero_Franco_Almeida.docx` (final, para envio) e `TCC_CRECI_Cicero_Franco_Almeida_v1_ANTIGA.docx` (original, versionamento). ⚠️ Existe também `TCC_Cicero_Franco_Almeida - versao-final-entrega.docx` — nome enganoso, é cópia byte-idêntica da versão ANTIGA (hash conferido em 2026-07-08); usuário avisado, não autorizou renomear/apagar.

**Pendências:** (1) nota de rodapé da orientadora Marilúcia de Almeida Paulino — falta só a TITULAÇÃO (graduada/especialista/mestra/doutora). Decisão do usuário em 2026-07-08: e-mail dela NÃO entra (a escola não forneceu) — não perguntar de novo.

**Sumário:** é ESTÁTICO (hyperlinks para bookmarks `_TocTcc001`–`013`, sem campo TOC — F9 não faz nada). Em 2026-07-08 ~17:11, segunda revisão encontrou 5 números de página defasados em 1 (2.7→15, 3→17, 4→19, Considerações→23, Referências→25) e corrigiu via XML; validado com Word COM (26 páginas, bookmarks conferidos). Bookmarks são ocultos: usar `Bookmarks.ShowHidden = $true` no COM. Backup pré-fix no scratchpad da sessão b2d297e7.

**Decisões do usuário:** manter numeração das seções 1–4 (padrão ABNT), mesmo que o modelo da escola (`Downloads\Arquivos_Soltos (1)\struturaartigoTCC-TTI-2 (1) (1).docx`) peça títulos sem numeração; modelo da escola usa "Descritores" separados por ponto (não "Palavras-chave").

**Why:** contexto necessário se o usuário voltar com os dados da orientadora ou pedir novos ajustes no TCC.
**How to apply:** editar o .docx via substituição de strings no `word/document.xml` (runs simples, sem negrito nas referências); nunca editar enquanto o arquivo estiver aberto no Word — um salvamento do Word às 16:29 chegou a apagar as ementas das leis nas referências (detectado por diff e restaurado).
