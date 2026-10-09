---
name: lp-cuiaba-razao-social
description: LP Cuiabá - razão social em CAIXA ALTA sem acentos, publicada 2026-09-08 em cuiabamt.hubcanais.online; repo virou público pra destravar o deploy
metadata:
  type: project
---

App `cuiaba-lp`, repo `cauedev30/cuiaba-LP`, domínio https://cuiabamt.hubcanais.online (subdomínio `cuiabamt` em `hubcanais.online`).

Em 2026-09-08 a razão social foi padronizada para **`CARTAO DE TODOS ADMINISTRADORA CUIABA LTDA`** — caixa alta e **sem acentos**, como ele escreveu. Mesmo padrão de [[lp-aracati-razao-social]] e [[lp-cariri-cdt]]; oposto de [[lp-macapa-razao-social]], que é acentuada por exigência da Meta. 32 ocorrências em `index.html`, `politica-cookies.html`, `politica-privacidade.html`, `termos-uso.html`.

**Só a razão social mudou.** A marca "Cartão de Todos" sozinha e o nome fantasia "Cartão de Todos Cuiabá (unidade franqueada autorizada)" continuam acentuados e em caixa mista, de propósito — ele confirmou. Não saia trocando a marca junto.

**O repo era PRIVADO e virou público nessa sessão (com aval explícito dele).** O primeiro deploy falhou com `status 404` no tarball porque o painel baixa anonimamente. `git clone` local enganou: funcionou por causa da credencial salva na máquina. Para checar de verdade a visibilidade, use `gh repo view --json visibility` ou um `curl` anônimo na API — não confie no clone. Confirma [[painel-dokku-mcp-deploy-lps]].
