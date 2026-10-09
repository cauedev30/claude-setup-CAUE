---
name: razao-social-sempre-caixa-alta
description: "Razão social nas LPs vai sempre em CAIXA ALTA, igual ao cartão CNPJ - regra geral, não caso a caso"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 016a7303-e0ce-468e-9911-5c2ea2cf41a6
  modified: 2026-09-10T16:53:24.443Z
---

Razão social em site de unidade vai **sempre em CAIXA ALTA**, exatamente como sai no cartão CNPJ. Ele disse isso sem eu perguntar, em 2026-09-10, no meio da geração da LP de Formiga: *"CARTAO DE TODOS FORMIGA LTDA um adendo, sempre coloque a razão social maiuscula, dessa forma"*.

**Why:** eu vinha tratando isso como decisão por cliente e perguntando/confirmando a cada LP (Macapá, Aracati, Cariri, Cuiabá viraram memórias separadas). Não é — é padrão dele. O que muda de cliente pra cliente é a **grafia** (acento, sufixo societário, nome exato), que vem do CNPJ; a **caixa** é fixa.

**How to apply:** copie a razão social do cartão CNPJ caractere a caractere e mantenha em maiúscula em todo o site — título, header, rodapé, páginas legais, `legalName` do JSON-LD. Não perguntar "maiúscula ou não". Continue confirmando a grafia quando o documento tiver algo ambíguo (acento, `LTDA`/`ME`/`EIRELI`) — ver [[lp-macapa-razao-social]], [[lp-aracati-razao-social]], [[lp-cuiaba-razao-social]], [[lp-cariri-cdt]], [[lp-formiga-cdt]].

Só a razão social. Marca e nome fantasia continuam com a grafia normal, acentuada.
