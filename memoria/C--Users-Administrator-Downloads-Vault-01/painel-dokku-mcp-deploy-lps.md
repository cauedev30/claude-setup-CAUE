---
name: painel-dokku-mcp-deploy-lps
description: "MCP painel-dokku (deploy.geniai.online) para deploy de LPs, vinculado ao projeto de vault \"Painel Dokku (Deploy LPs)\""
metadata: 
  node_type: memory
  type: project
  originSessionId: f2edcc08-b807-4156-9168-753fda73ae97
  modified: 2026-08-17T20:17:58.415Z
---

MCP HTTP `painel-dokku` (`https://deploy.geniai.online/mcp`) foi cadastrado em 2026-07-27 via `claude mcp add --transport http --scope user painel-dokku https://deploy.geniai.online/mcp` (escopo `user`, global — vale em qualquer projeto do Claude Code, nao so nesta vault). Objetivo: subir deploy de landing pages (LPs) direto pelo Claude.

Usuário pediu que esse MCP fosse ancorado a um projeto na vault: sempre que ele disser "abrir esse projeto" (no contexto de deploy de LP), é o projeto [[Projects/Active/Painel Dokku (Deploy LPs)]] dentro da vault (`C:\Users\Administrator\Downloads\Vault_01\Projects\Active\Painel Dokku (Deploy LPs).md`).

**Why:** o usuário quer reabrir esse contexto rapidamente em sessões futuras sem repetir a URL/credenciais toda vez.

**How to apply:** quando o usuário pedir pra "abrir esse projeto" ou mencionar deploy de LP/painel Dokku, ler a nota de projeto na vault (tem login + chave de API guardados lá — não duplicados aqui de propósito, pra não espalhar o segredo em dois lugares). Autenticação concluída em 2026-07-27 via Chave de API do painel (`Authorization: Bearer pdk_...`, gerada pelo usuário na seção "automação sem navegador" do próprio painel) — `claude mcp list` confirmou "✔ Connected". Tools testadas com sucesso em 2026-08-03 (`list_apps`, `list_domains`, `deploy_repo`, `deploy_status`): fluxo completo e validado na nota de projeto (seção "Fluxo de Deploy"). Achado-chave: `deploy_repo` só funciona com repo GitHub **público** (baixa tarball via API pública; repo privado dá 404) — se o usuário criar um repo pra deploy, lembrar de confirmar/pedir que fique público antes de tentar o deploy.

**Ordem obrigatória de deploy (aprendido derrubando o site de Petrolina em 2026-08-17):** ANTES de mover qualquer domínio, validar que o tarball baixa. A regra do repo público acima é a causa nº 1 de 404 — confirmar visibilidade primeiro, sempre. Mover o domínio antes de um build validado gera janela fora do ar, porque:
- `deploy_repo` publica o domínio ANTES de baixar o repo; se o download falhar, o domínio fica preso num app vazio servindo 502.
- Um domínio só pode pertencer a um app. `deploy_repo`, `publish_client_domain` e `expose_internal` TODOS recusam se outro app o detiver, e **o MCP não tem tool de remover domínio** — só a interface do painel remove (botão "remover domínio" no detalhe do app).
- Mitigação enquanto o site estiver quebrado: `maintenance(app, true)` troca o 502 cru por página de manutenção 503.

**Rename de repo quebra o deploy:** o codeload não segue redirect de rename — a página web do GitHub redireciona, o download do tarball dá 404. Depois de renomear um repo, o painel continua apontando pro nome antigo e todo deploy falha. O nome do app é derivado do repo em minúsculas (`cdt-aracati-LP` → app `cdt-aracati-lp`), então repo renomeado = app novo = conflito de domínio com o app antigo.

**Painel congela:** a aba Aplicações trava o renderer nos eventos de input quando o app monitorado está fora do ar. `browser_batch` com vários cliques encadeados passa onde cliques individuais estouram timeout.

**Skill de referência:** use a skill global [[skill-criar-site-cartao-de-todos]] para unidades Cartão de Todos — a `SKILL_cdt.md` do repo tem a metade de deploy morta (nginx/VPS). O material original em `Downloads/skills-e-templates-` (fora da vault, hoje versionado em `github.com/cauedev30/criador-de-sites-padrao`) tem `SKILL_cdt.md` (unidade franqueada Cartão de Todos), `SKILL_ams.md` (Amor Saúde) e `SKILL_site.md` (genérico) — cada uma com seu template em `templates-editados-`. Preenchem placeholders (CNPJ, razão social, endereço etc.) com dados reais da unidade antes de gerar o site; ver [[Knowledge/Caso Hostinger - Bloqueio por Denuncia de Phishing]] pro porquê desses sites existirem (exigência de campo de site nos templates de mensagem do WhatsApp Business/Meta).

**Não logar via navegador em nome do usuário:** já foi pedido uma vez ("use o login que eu te mandei" no site) e foi recusado — entrar com login/senha num site em nome do usuário é ação proibida, mesmo com autorização explícita. A chave de API (gerada pelo próprio usuário no painel) é o caminho correto pra automação — ver [[um-passo-de-cada-vez]] pra o padrão geral de pedir confirmação antes de agir em nome do usuário.
