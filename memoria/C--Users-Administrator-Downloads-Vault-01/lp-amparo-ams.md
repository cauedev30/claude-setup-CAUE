---
name: lp-amparo-ams
description: "LP Amor Saúde Amparo no ar em amparosaopaulo.online (app amparosp-lp, deployId 70) — PRIMEIRA LP Amor Saúde publicada; template AMS precisa de 4 correções"
metadata:
  node_type: memory
  type: project
  originSessionId: 82368e85-568b-4e8c-9775-0327614e6d0b
  modified: 2026-10-01T03:23:00.214Z
---

amparosaopaulo.online no ar desde 2026-09-30. App `amparosp-lp`, repo público `cauedev30/amparosp-LP` (nome escolhido por ele, foge do `cdt-<cidade>-lp`), commit ab2ea84, deployId 70. Razão social `AMOR SAUDE AMPARO SAO PAULO LTDA` (CNPJ 40.498.106/0001-81), sempre CAIXA ALTA, reafirmado por ele no meio da sessão. Título no formato longo; ele disse que não há display name da WABA a respeitar. Franquia confirmada por ele.

O PDF `CNPJ-AMS-AMPARO_atualizado.pdf` tem o mesmo horário de emissão do original, mas outro e-mail/telefone (`contato@amparosaopaulo.online`, (11) 4863-6437; a Receita ainda mostra contabil@sayddel / (31) 9939-8710). Eu avisei que era documento alterado; ele respondeu "o atualizado é o certo". **NÃO realertar** — mesmo padrão de [[lp-macapa-razao-social]].

**Why:** É a primeira LP Amor Saúde de verdade ([[lp-petrolina-cdt]] virou CDT). O `_template-amorsaude` do `criador-de-sites-padrao-cdt` não tem script, e o `gerar-site.sh` da [[skill-criar-site-cartao-de-todos]] é só pro CDT.
**How to apply:** Na próxima unidade AMS, corrigir no template: (1) assets absolutos `geradordesite.geniai.online/sites/7d9a…` → relativos, com og:image absoluto no domínio; (2) "inclusive em João Pessoa" fixo no Sobre; (3) estatísticas inventadas no hero (100%/24-7/15 anos) e o card "Atendimento 24/7", que ele mandou tirar; (4) ícones do manifest apontam pra favicon-192/512, que não existem. O `" AMORSAUDE"` com espaço aparece nos alts, no preloader e na galeria. HTTP puro dá 520 (igual Formiga; Sorocaba tem 301).

**Loading infinito (resolvido em 2026-10-01):** o apex tinha um A extra pra `3.33.130.190`, o estacionamento da GoDaddy que sobrou da migração. Isso aparecia como 525 antes do deploy e como 3–20 s intermitentes pela Cloudflare depois, enquanto a origem direta respondia em 0,3 s. O preloader só some no `load`, então o site parecia travado. Ele apagou o registro via Claude in Chrome, e o domínio voltou a responder em 0,2 s. Diagnóstico: comparar `--resolve <dom>:443:143.95.222.84` com o acesso pela CF, repetindo várias vezes. Em 2026-09-30 Cariri, Gravatá, Formiga, Aracati e Acaraú tinham o mesmo sintoma, provavelmente pela mesma causa. Foi reportado, mas não corrigido ([[um-passo-de-cada-vez]]). Em LP nova, confira se não há A de parking da GoDaddy no apex antes de dar o deploy por fechado.

**Apagar o A não basta:** a CF tinha CACHEADO a página de parking da GoDaddy no lugar do `script.js` (`text/html`, `cf-cache-status: HIT`, redirect pra `/lander`). O preloader nunca saía (SyntaxError `Unexpected token '<'`). Curl com código 200 não pega isso. Confira o `content-type` de cada asset e o console no Chrome. A correção é Purge Everything na zona. Se o curl está rápido e ele diz que "ainda trava", vá direto no console.
