---
name: lp-sorocaba-cdt
description: LP Cartão de Todos Sorocaba no ar em sorocabasp.online desde 2026-09-16; primeiro caso de bloqueio por A duplicado no apex (erro 81058 da Cloudflare)
metadata: 
  node_type: memory
  type: project
  originSessionId: a773a5db-946a-4f17-a2c6-1dc4aa07f144
  modified: 2026-09-16T20:14:15.941Z
---

Unidade **Cartão de Todos Sorocaba (Sorocaba - SP)**, no ar em **https://sorocabasp.online** (apex)
desde **2026-09-16**. App `cdt-sorocaba-lp`, repo público `cauedev30/cdt-sorocaba-lp` (criado por ele,
não por mim), commit `46d269f`, deployId **53**, `mode: static`.

| Campo | Valor |
|---|---|
| Razão social | ADMINISTRADORA DE CARTOES DE DESCONTO SOROCABA LTDA |
| CNPJ | 12.831.230/0001-81 |
| Endereço | R. Coronel Benedito Pires, 44 - Sala C-2, Centro, Sorocaba - SP, CEP 18.010-160 |
| Telefone | (11) 5194-6044 |
| E-mail | contato@sorocabasp.online |

**Grafia:** cartão CNPJ e BrasilAPI batem caractere a caractere, já em caixa alta sem acento — não
houve nada a confirmar. Cuidado com o detalhe: `CARTOES` (plural) + `DESCONTO` (**singular**),
diferente de [[lp-aracati-razao-social]] que é `CARTOES DE DESCONTOS`. Ver
[[razao-social-sempre-caixa-alta]].

**Telefone (11) numa unidade de DDD 15 é decisão dele.** A BrasilAPI retornava (15) 3329-3491; o
cartão traz (11) 5194-6044 e ele escolheu o do documento, porque o site tem que bater com o cartão pra
verificação da Meta. Mesmo precedente de [[lp-cariri-cdt]] e [[lp-formiga-cdt]]. **Não "corrigir".**

**Título no formato longo** liderado pela razão social (113 caracteres), escolhido por ele sabendo que
ocupa 3–4 linhas no mobile. Isso encerra a dúvida aberta no Formiga: **não existe formato padrão**, é
escolha dele caso a caso — a skill [[skill-criar-site-cartao-de-todos]] obriga a perguntar.

**Primeiro caso de `81058 An identical record already exists`.** O apex tinha dois registros A —
`143.95.222.84` (host do Dokku) e `3.33.130.190` (morto) — e o painel tentava gravar o IP do Dokku num
registro enquanto o outro já o tinha. O sintoma aparecia como **404**, que é consequência: o painel
grava o DNS **antes** do `dokku domains:add`, então o vhost nunca era criado. Receita completa na skill
e em [[Dev Logs/2026-09-16 - LP Cartao de Todos Sorocaba Deploy]].

Dois aprendizados que valem pra qualquer LP:
- **DNS público não serve de diagnóstico** quando o proxy da Cloudflare está ligado — `dig` devolve
  sempre os IPs de borda, e registro duplicado é invisível de fora. Bata direto na origem com `Host` na
  mão e compare com um domínio que funciona.
- **Nunca apagar a zona pra "refazer do zero"** — ele sugeriu isso quando travou. Essas zonas têm MX,
  SPF, DMARC e SRV; apagar derruba o e-mail do domínio, que costuma ser o do próprio cartão CNPJ.

Relacionado: [[painel-dokku-mcp-deploy-lps]], [[lp-petrolina-cdt]] (mesmo defeito de ordem do painel),
[[um-passo-de-cada-vez]].
