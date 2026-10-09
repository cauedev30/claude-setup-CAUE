---
name: chatmultgni-ams-tucurui
description: "Amor Saúde Tucuruí é a conta 114 do Chatwoot, cliente NOVO criado do zero em 2026-08-27; não confundir com a conta 15 (CDT Tucuruí)"
metadata: 
  node_type: memory
  type: project
  originSessionId: a65e5f6c-255b-4f6a-b428-37c98000ae8b
  modified: 2026-08-27T18:30:19.395Z
---

**AMS Tucuruí = conta 114 `AMS TUCURUI PA`**, criada do zero em 2026-08-27 na instância
`appchatfvk.geniai.online`. Segunda conta criada pelo projeto, depois da 113. ⚠️ **NÃO é a conta 15** —
essa é CDT Tucuruí, cliente diferente, mesma cidade (ver [[chatmultgni-tucurui]]).

**Gatilho combinado com ele:** quando falar **"Amor Saúde de Tucuruí"**, abrir por
`Projects/Active/Amor Saúde de Tucuruí.md` no vault. Ele pediu o nome **entre aspas** porque "não vai
ser exatamente um projeto" — é frente dentro de Automação Chatwoot GeniAI.

**Pronto:** Super Admin **499** (`superadminamstucuruipa@geniai.online`, senha e e-mail fornecidos por
ele, `type: SuperAdmin` que ele mesmo concedeu no DevTools), time **423** `triagem`, regra **514**
`Triagem - entrada`. **Falta por decisão dele:** atendentes (cliente ainda não passou a lista) e
inbox/dial. Conta **não está no Supabase** — workflows `20`/`22` não rodam nela.

**O modelo é a 113, não a "103".** Ele disse 103; a 103 **não existe**. Perguntei antes de replicar e
ele confirmou 113 — ver [[inferencia-minha-nao-e-fala-dele]].

**Três perguntas obrigatórias quando a lista chegar:** grafia exata dos nomes (batiza e-mail/time/regra
permanentemente), quem é o(a) gestor(a), e se o e-mail leva sufixo `pa` (na 113 os atendentes ficaram
**sem** a UF, ao contrário do Super Admin).

**Dois achados de API que valem para todas as contas:**

- **`404` vs `401` na Platform API separam "não existe" de "não é meu".** Contas antigas do projeto
  (6, 15, 16, 81, 85, 87, 88, 96, 105) dão `401`; ids inexistentes dão `404`. Use quando ele der um id
  de memória.
- **A Platform API é cega ao campo `type`** — não devolve, não lê, não escreve (conferido no 486, que é
  `SuperAdmin`, e no 499). O console de Super Admin só se concede pelo DevTools, **por um super admin
  que já existe** (o usuário novo não loga lá para se promover) e **só na tela `Edit`**, nunca na `Show`.

**O `Central Gateway Bot` (397) entra sozinho em conta nova** como administrator; está igual na 113. É
padrão da instância — não remover.

Relacionado: [[adicionar-acesso-chatwoot-playbook]], [[chatmultgni-tucurui]], [[um-passo-de-cada-vez]],
[[consulta-por-api-nao-navegador]].
