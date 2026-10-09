---
name: criar-site-cartao-de-todos
description: Use quando o usuário for criar, gerar, refazer ou subir o site/LP de uma unidade franqueada Cartão de Todos (CDT) — "preciso criar o site do Cartão de Todos de <cidade>", "gerar a LP dessa unidade", "sobe esse site no painel" — ou quando mandar um cartão CNPJ de unidade CDT junto com um domínio. Vale também para redeploy de LP CDT já no ar. Use também quando QUALQUER LP publicada pelo painel (CDT, Amor Saúde ou genérica) estiver travada no loading/preloader, lenta, ou servindo arquivo errado — "o site tá no loading infinito", "tá demorando muito pra abrir".
---

# Criar site de unidade Cartão de Todos

Gera a LP de uma unidade franqueada CDT a partir do template de compliance do repo
`github.com/cauedev30/criador-de-sites-padrao-cdt` e publica pelo MCP `painel-dokku`.

**Requer o MCP `painel-dokku`** (escopo `user`, global). Se as tools `list_apps`/`deploy_repo`
não estiverem na sessão, pare e avise — sem elas dá pra gerar, não pra publicar.
Contexto e credenciais: `Projects/Active/Painel Dokku (Deploy LPs).md` na vault.

## Princípio

O site é da **entidade legal operadora** (razão social + CNPJ), e "Cartão de Todos" aparece como
**qualificação da unidade**, com disclosure honesto da franquia. Isso existe porque a Meta exige
o campo de site nos templates do WhatsApp Business e porque detectores de phishing não distinguem
franquia legítima de clone golpista.

É **proibido** qualquer artifício de evasão: esconder que é franquia, ocultar o operador, cloaking,
texto invisível, adulterar o logo pra driblar hashing. Se o objetivo de uma ação for "enganar o
detector" em vez de "mostrar quem realmente opera", não faça.

**Pré-requisito de honestidade:** só escreva "unidade franqueada autorizada" se o cliente for
mesmo franqueado/licenciado. Sem confirmação, pergunte — afirmar vínculo inexistente reprova na Meta
e é tão enganoso quanto o phishing que estamos evitando.

## Passo 0 — Confirmar ANTES de gerar

Três coisas travam a geração. Pergunte de uma vez, não uma por vez:

1. **Grafia da razão social.** Vai sempre em **CAIXA ALTA** (regra fixa dele, não pergunte isso).
   O que varia é a grafia — acento, `LTDA`/`ME`/`EIRELI` — e ela vem do cartão CNPJ, caractere a
   caractere. Confirme com `curl -s https://brasilapi.com.br/api/cnpj/v1/<cnpj-só-dígitos>` e mostre
   a ele o que voltou. **Não replique o padrão de outra unidade** — Macapá, Aracati, Cariri, Cuiabá
   e Formiga divergem entre si de propósito.
2. **`{{TITULO_SITE}}`.** Sempre pergunte. Dois formatos em uso e a escolha é dele:
   - curto `Cartão de Todos <Cidade>` (no ar em Cariri e Aracati);
   - longo `RAZAO SOCIAL — Cartão de Todos <Cidade> (unidade franqueada autorizada)` (o que o
     template prescreve, aplicado em Formiga).

   Se a unidade tiver **display name registrado na WABA**, essa string precisa aparecer **verbatim e
   contígua** dentro do título — a revisão da Meta procura por ela. Não troque caixa nem acento dela.
3. **Repo público.** `deploy_repo` baixa tarball pela API pública do GitHub; repo privado dá 404.
   Peça aval explícito antes de criar/tornar público e antes do push.

Só a razão social é caixa alta. Marca e nome fantasia continuam acentuados e em caixa mista.

## Passo 1 — Clonar o template

```bash
git clone --depth 1 https://github.com/cauedev30/criador-de-sites-padrao-cdt "$TMP/criador"
```

Template: `templates-editados-/template-cartaodetodos` — 4 HTMLs + `legal.css` + `logo.jpeg`.
O repo é a fonte da verdade; clone a cada geração em vez de usar cópia velha.

## Passo 2 — Preencher e verificar

Monte o arquivo de dados (UTF-8, `KEY=valor`) e rode o script — ele copia, substitui e **barra o
deploy** se algo ficou errado:

```bash
bash ~/.claude/skills/criar-site-cartao-de-todos/scripts/gerar-site.sh \
     "$TMP/criador/templates-editados-/template-cartaodetodos" \
     ~/Downloads/cdt-<cidade>-lp \
     dados.env
```

| Chave | Valor |
|---|---|
| `TITULO_SITE` | o formato confirmado no Passo 0 |
| `RAZAO_SOCIAL` | CAIXA ALTA, grafia do cartão CNPJ |
| `CNPJ` | `XX.XXX.XXX/XXXX-XX` |
| `ENDERECO` | logradouro, nº, bairro, cidade - UF, CEP |
| `ENDERECO_MAPS` | o endereço URL-encoded (espaço `%20`, vírgula `%2C`) |
| `TELEFONE` | `(XX) XXXX-XXXX` |
| `EMAIL` | preferir `contato@<domínio>`; Gmail/Hotmail enfraquece a verificação da Meta |
| `CIDADE_ESTADO` | `Cidade - UF` |
| `DATA_ATUALIZACAO` | `DD/MM/AAAA` de hoje |

`DISCLOSURE_FRANQUIA` o script monta sozinho, com razão social e CNPJ já por extenso.

O script reprova se sobrar `{{...}}`, se faltar razão social, CNPJ ou o disclosure de franquia em
qualquer uma das 4 páginas, ou se o JSON-LD virar JSON inválido. **Portão reprovado = não commita,
não faz deploy.** Depois do portão, abra o `index.html` e uma das páginas legais e confira
visualmente — inclusive em largura de celular, se o título for longo.

## Passo 3 — Repo

Convenção: `cdt-<cidade>-lp`, minúsculo. O nome do app no Dokku é o nome do repo em minúsculas.

```bash
gh repo create cauedev30/cdt-<cidade>-lp --public --source=. --push
```

Commits nesses repos: autor `cauedev30 <cauefranco01@gmail.com>`, **sem** `Co-Authored-By`.

## Passo 4 — Validar o tarball ANTES de tocar no domínio

```bash
curl -sI https://codeload.github.com/cauedev30/cdt-<cidade>-lp/tar.gz/refs/heads/main | head -1
```

Tem que ser **200**. Use o codeload, não `github.com/.../archive/...` (esse responde 302 e te engana).

Isso não é zelo: `deploy_repo` **publica o domínio antes de baixar o repo**. Se o download falhar, o
domínio fica preso num app vazio servindo 502 — e **o MCP não tem tool de remover domínio**, só a
interface do painel remove. Foi assim que o site de Petrolina caiu.

## Passo 5 — Deploy

```
list_domains()                          # o domínio precisa já existir e estar livre
list_apps()                             # confere se o app já existe (redeploy) ou não
deploy_repo({ repo: "cauedev30/cdt-<cidade>-lp", mode: "static", domain: "<dominio>" })
deploy_status(<id>)                     # repetir até success (~1 min)
```

- `deploy_repo` **não** aceita `app`, nem URL completa, nem `branch`. É `owner/nome`.
- `mode: "static"` sempre — é HTML/CSS/assets, sem buildpack. Não chame `set_port` nem
  `expose_internal`: não há container próprio nem Dockerfile.
- Apex → só `domain`. Subdomínio → `domain: "hubcanais.online"` + `subdomain: "<cidade><uf>"`.
- `list_apps()` só mostra apps criados pela conta dona da chave em uso. App de outra conta responde
  `app não encontrado ou sem acesso` — não fique adivinhando nome; o erro de conflito do `deploy_repo`
  entrega o nome real.

Se der 502, o nginx do Dokku está de pé sem container atrás — `app_report` / `app_logs` antes de
tentar `rebuild`.

## Passo 6 — Verificar a publicação (portão pós-deploy, obrigatório)

`deploy_status = success` e `curl` dando 200 **não fecham o deploy**. Rode, com a mesma pasta que
foi pro repo:

```bash
bash ~/.claude/skills/criar-site-cartao-de-todos/scripts/verificar-publicacao.sh \
     <dominio> ~/Downloads/cdt-<cidade>-lp
```

Para cada arquivo da pasta, o script confere **status, content-type e conteúdo** do que o domínio
público entrega contra o repo. Depois mede **8 acessos pela Cloudflare contra a origem direta**.
Sai com 1 se servir parking, tipo errado, conteúdo diferente ou acesso acima de 3 s.
**Portão reprovado = deploy não está fechado**: siga o que o script imprime e rode de novo.

Vale para **qualquer** LP publicada pelo painel (CDT, Amor Saúde, genérica), não só as desta skill.

Por que existe: em amparosaopaulo.online (2026-09-30) o deploy deu success, todo arquivo deu
200, e o site ficou **preso no preloader** pra todo mundo. Ver "Quando o site trava no loading".

## Armadilhas

| Armadilha | O que acontece |
|---|---|
| `{{TITULO_SITE}}` vai pra 4 lugares | `<title>`, `name` do JSON-LD, o `<span class="logo-text">` da navbar do index **e** o `.legal-logo` das 3 páginas legais. O template já tem regra responsiva pros dois últimos (desde 2026-09-16), mas título longo ocupa 3–4 linhas no mobile — confira no navegador antes de subir. |
| Editar os HTMLs no PowerShell 5.1 | `Set-Content`/`Out-File` sem `-Encoding utf8` grava ANSI e corrompe todo acento. Use Git Bash. |
| Corpo do template sem acento | "Descontos que fazem a diferenca", "Politica", "experiencia" — é assim no template. Endereço, marca e disclosure entram acentuados. Não saia "corrigindo" o corpo. |
| `81058 An identical record already exists` | O apex do domínio tem **dois** registros A e o painel tenta gravar o IP do Dokku num deles enquanto o outro já o tem. A Cloudflare recusa e o deploy aborta. Ver "Quando o deploy falha" abaixo. |
| 404 no domínio depois de um deploy que falhou | É **sintoma, não causa**. O painel grava o DNS **antes** do `dokku domains:add`; se o passo do DNS aborta, o vhost nunca é criado e o nginx do Dokku devolve 404. Não vá atacar o 404 — ele some sozinho quando o write do DNS passar. |
| Renomear o repo depois do deploy | O codeload não segue redirect de rename: todo deploy passa a dar 404 e o app novo conflita de domínio com o antigo. |
| "Deixa igual ao Cariri" | Cariri e Aracati vieram do **template antigo**, sem disclosure e sem JSON-LD. Confirme de qual ele está falando. |
| Telefone com DDD de outro estado | Normalmente é o do cartão CNPJ e ele manda manter — o site tem que bater com o documento pra Meta. Não "corrija". |
| Site preso no loading com deploy success e 200 em tudo | O apex tinha um A **extra** (parking da GoDaddy, `3.33.130.190`). A CF alterna entre os registros, e quando cai no morto leva ~20 s. Pior: ela **cacheou a página de parking no lugar do `script.js`**, o JS não roda e o preloader nunca sai. Ver "Quando o site trava no loading". |
| "Abri em aba anônima e continua" | Esperado. O cache envenenado é da **Cloudflare**, não do navegador. Só **Purge Everything** resolve. |

## Quando o deploy falha no passo do domínio

O painel publica o domínio **antes** de baixar o repo e antes de criar o vhost. Falha ali = app
sem domínio e 404. Ordem pra diagnosticar, sem chutar:

1. **Separe build de domínio.** `deploy_repo` **sem** `domain` publica o app internamente. Se isso
   passa, o repo e o tarball estão bons e o problema é só de domínio.
2. **Descubra o IP do Dokku:** `dig +short deploy.geniai.online` (hoje `143.95.222.84`).
3. **Teste a origem direto, com o Host na mão** — o proxy da Cloudflare esconde tudo de fora:
   ```bash
   curl -sk -o /dev/null -w "%{http_code}\n" --resolve "<dominio>:443:<ip-dokku>" https://<dominio>/
   ```
   Compare com um domínio que funciona (`sorocabasp.online`). 200 no que funciona + 404 no seu
   confirma que falta o vhost no Dokku.
4. **Não use DNS público como termômetro.** Com o proxy ligado, `dig` devolve sempre os IPs de
   borda da Cloudflare (104.21.x / 172.67.x), existindo um registro de origem ou três. Registro
   duplicado é **invisível** no DNS de fora. Só aparece no erro da API do painel (`81058`) ou na
   **latência**: o `verificar-publicacao.sh` acusa quando a CF passa de 3 s e a origem fica em 0,3 s.
5. **Se for o `81058`:** o apex tem dois A. O registro que o painel controla é o do ID que aparece
   no erro; o que precisa ser apagado é o **outro**, o que já ocupa o IP de destino. Isso é feito
   na interface da Cloudflare — **você não entra na conta dele**, escreva o passo a passo e peça
   pra ele executar. Depois é só `publish_client_domain` de novo.

**Nunca apague a zona pra "refazer do zero".** Essas zonas têm MX, SPF, DMARC e SRV — apagar
derruba o e-mail do domínio, que costuma ser o e-mail do próprio cartão CNPJ.

## Quando o site trava no loading

Sintoma: a aba fica girando e a tela mostra o preloader com o nome da unidade, inclusive em aba
anônima e em outro navegador. Muito provavelmente vai se repetir em domínio que veio da GoDaddy.
**Vá direto nisto, nesta ordem:**

1. **Rode o `verificar-publicacao.sh`.** Ele já diz qual dos dois casos é.
2. **Arquivo com tipo/conteúdo errado e `cf-cache-status: HIT`** (no Amparo: `script.js` vindo como
   `text/html` com `window.location.href="/lander?oref=..."`) = **cache envenenado**. A origem tem o
   arquivo certo, confira com `--resolve <dominio>:443:<ip-dokku>`. Correção: Cloudflare → zona →
   **Caching → Configuration → Purge Everything**.
3. **Latência de 3–20 s intermitente pela CF com a origem em ~0,3 s** = **A extra no apex**.
   Correção: Cloudflare → zona → **DNS → Records**. Mantenha só o A do apex pra `143.95.222.84`,
   apague os outros A/AAAA do apex (parking da GoDaddy: `3.33.130.190`, par conhecido
   `15.197.148.33`) e **depois faça o Purge Everything** do passo 2. Apagar o A não limpa o que já
   foi cacheado enquanto ele existia.
4. **Confirme no navegador de verdade, se precisar:** console com
   `SyntaxError: Unexpected token '<'` em `script.js` é a assinatura do caso 2. Curl com 200 não pega.

Os dois passos são na conta Cloudflare dele: **você não entra**. Mande um prompt fechado pro Claude in
Chrome dele dizendo o que fazer e o que é **proibido** (MX, TXT, CNAME, SRV, www, SSL, outras zonas).
Depois rode o script de novo.

O preloader do template só sai no `window.load` **e** depende do `script.js` rodar. Por isso
qualquer JS servido errado prende o site inteiro.

## Bandeiras vermelhas — pare

- Ia rodar `deploy_repo` sem ter visto 200 no codeload.
- Ia dizer "está no ar" sem o `verificar-publicacao.sh` verde, só porque o curl deu 200.
- Ele disse que "ainda trava" e você ia mandar limpar o cache do navegador ou abrir aba anônima.
- Ia decidir o `<title>` ou a grafia da razão social sem ele responder.
- O portão do script reprovou e você pensou "é só um placeholder, arrumo depois do deploy".
- Ia tornar um repo público sem aval explícito dele.
- Ia mexer em mais de uma unidade na mesma execução — **um passo de cada vez**; achou problema em
  outra LP, reporte e registre, não corrija junto.

## Limites honestos

As páginas ficam coerentes com a Meta, mas os sinais de **cluster** continuam: mesmo IP de origem,
template parecido entre unidades, domínios novos em lote. Mitigação real é conteúdo e fotos reais por
unidade, WHOIS/SPF/DMARC alinhados ao operador, e distribuir origens quando o volume justificar. Se
um domínio legítimo for flagado, o caminho é contestação (Search Console → Request Review, Cloudflare
Brand Protection, PhishTank/APWG) comprovando a franquia. Não prometa "zero flag".

## Depois que subir

Registre na vault: app, repo, domínio, deployId, commit, razão social usada e a fonte da grafia.
Segue o padrão de `lp-formiga-cdt` / `lp-cariri-cdt`. Só grave se ele pedir ou confirmar.
