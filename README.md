# claude-setup-CAUE

Backup completo do setup do Claude Code do Cauê: configurações, hooks, skills,
comandos, plugins, servidores MCP, memórias, statusline e o esqueleto do vault do
Obsidian. Serve para restaurar tudo numa máquina nova, ou para um amigo montar o
mesmo setup.

> **Este repo é privado e tem que continuar privado.** As memórias (`memoria/`)
> têm dados de clientes: CNPJs, telefones, e-mails das unidades, contas do
> Chatwoot e detalhes de infraestrutura.

## Restaurar numa máquina nova (Windows)

```powershell
winget install --id Git.Git -e
winget install --id GitHub.cli -e
# feche e abra o terminal para o PATH atualizar
gh auth login
gh repo clone cauedev30/claude-setup-CAUE
cd claude-setup-CAUE
powershell -ExecutionPolicy Bypass -File .\instalar.ps1
```

O `instalar.ps1`:

1. instala os programas de [`programas/winget.txt`](programas/winget.txt) (pula os que já existem);
2. instala o Claude Code CLI (`npm install -g @anthropic-ai/claude-code`) se faltar;
3. copia settings, hooks, comandos, skills, planos, memórias, `~/.agents`,
   statusline e `.gitconfig`, trocando os caminhos `C:\Users\Administrator`
   pelos da máquina nova;
4. clona o `obsidian-second-brain` no mesmo commit do export;
5. cria o vault a partir do esqueleto (num vault que já existe, só acrescenta o
   que falta, sem sobrescrever nada);
6. instala os plugins e cadastra os servidores MCP, pedindo os tokens na hora.

Tudo que ele sobrescreve no `~/.claude` é copiado antes para
`~/.claude-backup-<data>`. Dá para rodar de novo quantas vezes precisar.

Opções:

| Opção | Para quê |
|---|---|
| `-VaultPath <pasta>` | vault em outro lugar (padrão: `~\Downloads\Vault_01`) |
| `-Amigo` | instala o setup sem os dados pessoais: memórias, planos, `.gitconfig` e o hook que força todo commit a sair como `cauedev30` |
| `-PularProgramas` | não roda o winget |
| `-PularClaude` | não instala o CLI, os plugins nem os MCPs |
| `-Destino <pasta>` | ensaio: instala numa pasta de teste em vez do seu usuário |

### Tokens que o instalador pede

Segredo não entra no repo. No lugar, ficam marcadores que o instalador pede na
hora. Para não precisar digitar, defina antes uma variável de ambiente com o
nome do marcador:

| Marcador | O que é | Onde pegar |
|---|---|---|
| `MCP_PAINEL_DOKKU_AUTHORIZATION` | token do MCP do painel de deploy (só o token, sem `Bearer`) | painel em `deploy.geniai.online` |
| `MCP_TESTSPRITE_API_KEY` | API key do TestSprite (`sk-user-...`) | dashboard do TestSprite |

```powershell
$env:MCP_PAINEL_DOKKU_AUTHORIZATION = '...'
$env:MCP_TESTSPRITE_API_KEY = '...'
```

### Passos manuais depois do instalador

1. Rode `claude` e faça o login (`/login`). As skills da conta do claude.ai
   (docx, pdf, pptx, xlsx etc.) voltam sozinhas com o login.
2. Abra o vault no Obsidian e ative os plugins da comunidade (Excalidraw).
3. O que não está no winget:
   - **Maestri**: app instalado à parte. As skills `maestri-*` já estão no repo,
     mas só funcionam com o app aberto.
   - **Kotlin 2.4.20**: zip do compilador em github.com/JetBrains/kotlin/releases,
     extraído em `~\Downloads\kotlinc` (fora do PATH, como na máquina original).
     O JDK 21 vem pelo winget.
   - **Flutter 3.47.6 (stable)**: clone em `~\development\flutter`, com o
     `bin` no PATH do usuário.
4. Os hooks do **Orca** (`~/.orca/agent-hooks/claude-hook.cmd`) são criados
   pelo próprio app Orca, que vem pelo winget. Sem o Orca, esses hooks
   simplesmente não fazem nada (`|| echo {}`).

## Manter o repo atualizado

Sempre que mudar alguma coisa no setup (skill nova, hook, plugin, MCP, memória):

```powershell
cd ~\Desktop\claude-setup-CAUE
powershell -ExecutionPolicy Bypass -File .\exportar.ps1 -Publicar
```

O `exportar.ps1` apaga e recria as pastas geradas, então o que você remover da
máquina também some do repo. No fim, ele procura padrões de token (`sk-`,
`sbp_`, `ghp_`, JWT, `Bearer`...) em tudo que gerou. Se achar algum, para sem
commitar e mostra onde está. Sem `-Publicar`, ele só gera os arquivos para você
revisar com `git diff`.

## O que tem aqui

| Pasta | Conteúdo | Vai para |
|---|---|---|
| `claude/settings.json` | configurações, hooks, plugins ativos, statusline, modelo (caminhos como `{{HOME_JSON}}`) | `~/.claude/settings.json` |
| `claude/hooks/` | `enforce-commit-author.js`: todo commit sai como `cauedev30`, sem Co-Authored-By | `~/.claude/hooks/` |
| `claude/commands/` | 44 slash commands (os do obsidian-second-brain e afins) | `~/.claude/commands/` |
| `claude/skills/` | skills próprias e instaladas à mão (criar-site-cartao-de-todos, curriculo-camaleao, grill-me, maestri-*) | `~/.claude/skills/` |
| `claude/plans/` | planos salvos de sessões anteriores | `~/.claude/plans/` |
| `memoria/` | memória de cada projeto (`_origem.json` guarda os caminhos da máquina de origem para remapear) | `~/.claude/projects/<projeto>/memory/` |
| `mcp/servidores.json` | servidores MCP do escopo usuário, com os tokens trocados por marcadores | `claude mcp add --scope user` |
| `plugins/plugins.json` | marketplaces e plugins (superpowers, frontend-design) | `claude plugin install` |
| `externos/externos.json` | repos de terceiros fixados por commit (obsidian-second-brain) | `git clone` + `checkout` |
| `agents/` | `~/.agents` (skills do Maestri e find-skills, `.skill-lock.json`) | `~/.agents/` |
| `config/` | config do ccstatusline e `.gitconfig` | `~/.config/ccstatusline/`, `~/.gitconfig` |
| `vault-esqueleto/` | `_CLAUDE.md`, `AGENTS.md`, `Home.md`, `Templates/`, `.obsidian/` e a árvore de pastas, sem notas | o vault |
| `programas/winget.txt` | programas do setup (lista escrita à mão) | `winget install` |

## O que fica de fora, e por quê

| Item | Motivo |
|---|---|
| `~/.claude/.credentials.json` | é o seu login; refaça com `/login` |
| tokens de MCP e API keys | segredo em git é risco permanente; o instalador pede na hora |
| transcrições (`~/.claude/projects/*.jsonl`, `history.jsonl`) | ~300 MB de conversas cheias de tokens colados em sessões |
| notas do vault (Daily, Projects, People...) | por decisão: do vault só sobe o esqueleto |
| `~/.claude/skills/synced`, `plugins/synced` | vêm da conta do claude.ai no login |
| cache, telemetria, `file-history`, `session-env`, `shell-snapshots`, backups | estado de execução, recriado sozinho |
| o resto do `~/.claude.json` | estado do app (dicas vistas, contadores, cache); só os MCPs importam e eles estão em `mcp/` |
