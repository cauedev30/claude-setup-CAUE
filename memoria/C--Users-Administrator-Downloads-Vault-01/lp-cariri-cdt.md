---
name: lp-cariri-cdt
description: LP Cartão de Todos Cariri publicada 2026-08-20 em caririce.online (app cdt-cariri-lp); razão social em CAIXA ALTA sem acentos; telefone do CNPJ tem DDD 83 numa unidade do CE, de propósito
metadata:
  type: project
---

Unidade **Cartão de Todos Cariri**, sede em Juazeiro do Norte - CE. Site gerado em 2026-08-20 pela skill
`SKILL_cdt.md` (`Downloads\skills-e-templates-`) e publicado pelo painel Dokku.

| Campo | Valor |
|---|---|
| Razão social | ADMINISTRADORA DE CARTAO DE TODOS CARIRI LTDA |
| CNPJ | 14.970.914/0001-90 |
| Endereço | R. São Pedro, 1443, Salesianos, Juazeiro do Norte - CE, CEP 63.050-270 |
| Telefone | (83) 3190-0380 |
| E-mail | contato@caririce.online |
| Domínio | caririce.online (apex) |
| App Dokku | `cdt-cariri-lp` (deployId 45, `mode: static`) |
| Repo | `cauedev30/cdt-cariri-lp` — **público de propósito** |
| Cópia local | `Downloads\cdt-cariri-lp` |

**Grafia:** razão social em CAIXA ALTA sem acentos, igual ao cartão CNPJ — padrão de [[lp-aracati-razao-social]]
e Petrolina, não o do Macapá. Confirmado com o usuário antes de gerar. O corpo do template continua sem
acentos; endereço, marca "Cartão de Todos" e o disclosure de franquia são acentuados, como no Aracati no ar.

**Telefone com DDD de outro estado é intencional:** (83) é da Paraíba e a unidade é do Ceará (DDD 88). Ele
optou por manter o número do documento — o site tem que bater com o cartão CNPJ pra verificação da Meta. Não
"corrija" isso numa próxima passada.

**Display name da Meta não se aplica aqui:** perguntei e ele respondeu "não precisa", então o título é
`Cartão de Todos Cariri` (precedente Aracati), não o formato liderado pela razão social que a skill sugere.

**Ordem de deploy usada (e que funcionou):** validar o tarball em `codeload.github.com/<repo>/tar.gz/refs/heads/main`
→ 200 **antes** de mover domínio. Ver [[painel-dokku-mcp-deploy-lps]].

**Confusão de pasta a antecipar:** ele chamou `Downloads\conciliation-team-creator-main` de "a skill" — essa
pasta é o app de times do Chatwoot, não tem nada de LP. A skill de site é `SKILL_cdt.md`.
