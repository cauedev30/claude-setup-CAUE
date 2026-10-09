---
name: lp-macapa-razao-social
description: LP Macapá - razão social agora é CAIXA ALTA SEM ACENTO no site inteiro (decisão reafirmada 2026-09-08); a exigência de acento da Meta de ago/2026 foi conscientemente abandonada
metadata:
  node_type: memory
  type: project
  originSessionId: 996334f3-e60c-4b94-886e-1d6fdc1edcbe
  modified: 2026-09-08T00:00:00.000Z
---

Site `macapaap.hubcanais.online`, app Dokku `macapa-lp` ← repo `github.com/cauedev30/macapa-lp` (público, branch `main`). CNPJ 30.420.633/0001-10. O app antigo `cdt-macapaap` foi apagado pelo admin.

**ESTADO ATUAL (2026-09-08, deploy #50, commit `11dac05`): as 32 ocorrências da razão social estão em `ADMINISTRADORA DE CARTAO DE DESCONTO MACAPA LTDA` — CAIXA ALTA e SEM ACENTO — no site inteiro** (index, politica-cookies, politica-privacidade, termos-uso). Isso encerra a divergência antiga em que só o `<title>` era sem acento e o corpo era acentuado.

**Histórico da decisão, pra não reabrir:** em 2026-08-11 a Meta exigiu a grafia acentuada e o nome virou `Administradora de Cartão de Desconto Macapá Ltda` (commit `50240cb`). Em 2026-09-04 ele tirou o acento só do `<title>`. Em 2026-09-08 ele mandou aplicar caixa alta sem acento em tudo. **Eu levantei o conflito com a Meta nas duas vezes e ele reafirmou nas duas.** Está decidido: **não realertar sobre acento no Macapá.** Se a Meta reclamar da grafia de novo, aí sim é assunto novo — e a correção é reacentuar, não remover o nome.

Caixa alta e acento são coisas independentes: existia a opção `ADMINISTRADORA DE CARTÃO DE DESCONTO MACAPÁ LTDA`, ele escolheu sem acento por escrito.

**Escopo do que NÃO mudou (escolha dele em 2026-09-08):** nome fantasia `Cartao de Todos Macapa`, endereço `Av. General Gurjao, 85, Central, Macapa/AP`, e-mail `cdtmacapa@hubcanais.online` e a URL do Google Maps continuam como estavam. O resto do site segue sem acentuação de propósito — ver [[um-passo-de-cada-vez]].

**"Laranjal do Jari" não existe neste repo.** Ele pediu em 2026-09-08 pra colocar esse nome em maiúsculo junto; conferi os 4 HTMLs, o CSS, os repos da conta e os apps do painel: zero ocorrências, nenhum repo, nenhum app. Ele mandou seguir só com o Macapá. Se voltar a citar Laranjal do Jari, é outro site ou conteúdo novo — pergunte, não procure aqui de novo.

Contexto de deploy em [[painel-dokku-mcp-deploy-lps]]; mesmo padrão de caixa alta sem acento em [[lp-aracati-razao-social]], [[lp-cariri-cdt]] e [[lp-cuiaba-razao-social]].
