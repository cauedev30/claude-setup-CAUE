<#
.SYNOPSIS
  Restaura o setup do Claude deste repo numa máquina Windows (repo -> máquina).

.DESCRIPTION
  1. Instala os programas de programas\winget.txt (pula os que já existem).
  2. Instala o Claude Code CLI via npm, se faltar.
  3. Copia settings, hooks, commands, skills, plans, memórias, ~/.agents,
     statusline e .gitconfig, trocando os caminhos pelos desta máquina.
     O que já existia e vai ser sobrescrito é copiado antes para
     ~/.claude-backup-<data>.
  4. Clona o obsidian-second-brain no commit exato do export.
  5. Cria o vault a partir do esqueleto (num vault que já existe, só acrescenta
     o que falta e não sobrescreve nada).
  6. Instala os plugins e cadastra os servidores MCP. Os tokens são pedidos na
     hora; para não digitar, defina antes uma variável de ambiente com o nome do
     marcador (ex.: $env:MCP_PAINEL_DOKKU_AUTHORIZATION = '...').

  Pode rodar de novo sem medo: cada passo pula o que já está feito.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\instalar.ps1

.EXAMPLE
  # Para um amigo: mesmo setup, sem os dados pessoais do Cauê (memórias, planos,
  # .gitconfig e o hook que força todo commit a sair como cauedev30)
  .\instalar.ps1 -Amigo

.EXAMPLE
  # Ensaio sem tocar na máquina: tudo vai para uma pasta de teste
  .\instalar.ps1 -Destino C:\teste\casa -VaultPath C:\teste\vault -PularProgramas -PularClaude
#>
param(
  [string]$Destino   = $env:USERPROFILE,
  [string]$VaultPath = "$env:USERPROFILE\Downloads\Vault_01",
  [switch]$PularProgramas,
  [switch]$PularClaude,
  [switch]$Amigo
)

# Arquivos pessoais do Cauê que o -Amigo não instala.
$HookPessoal = 'enforce-commit-author.js'

$ErrorActionPreference = 'Stop'
$Repo   = $PSScriptRoot
$Claude = Join-Path $Destino '.claude'
$Utf8   = New-Object System.Text.UTF8Encoding($false)
$Backup = Join-Path $Destino (".claude-backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$Pendencias = New-Object System.Collections.Generic.List[string]

function Passo([string]$t) { Write-Host ''; Write-Host "== $t" -ForegroundColor Cyan }
function Ler([string]$p) { [IO.File]::ReadAllText($p, $Utf8) }

function Gravar([string]$p, [string]$texto) {
  $dir = Split-Path $p -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  [IO.File]::WriteAllText($p, $texto, $Utf8)
}

# /E copia por cima sem apagar extras do destino. $soFaltantes não sobrescreve nada.
function Copiar([string]$origem, [string]$destino, [switch]$soFaltantes, [string[]]$semArquivos = @()) {
  $a = @($origem, $destino, '/E', '/NFL', '/NDL', '/NJH', '/NJS', '/NP', '/R:1', '/W:1')
  if ($soFaltantes) { $a += '/XC', '/XN', '/XO' }
  if ($semArquivos) { $a += '/XF'; $a += $semArquivos }
  robocopy @a | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy falhou ($LASTEXITCODE): $origem" }
  $global:LASTEXITCODE = 0
}

function Guardar([string]$alvo) {
  if (-not (Test-Path $alvo)) { return }
  $rel = $alvo.Substring($Destino.Length).TrimStart('\')
  $dest = Join-Path $Backup $rel
  if ((Get-Item $alvo).PSIsContainer) { Copiar $alvo $dest }
  else { New-Item -ItemType Directory -Force (Split-Path $dest -Parent) | Out-Null; Copy-Item $alvo $dest }
}

function EscJson([string]$s) { $s.Replace('\', '\\') }
function Codificar([string]$p) { $p -replace '[^A-Za-z0-9]', '-' }

function AtualizarPath {
  $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

# Valor de um marcador {{NOME}}: variável de ambiente NOME ou digitado na hora (oculto).
function Segredo([string]$marca, [string]$para) {
  $nome = $marca.Trim('{', '}')
  $v = [Environment]::GetEnvironmentVariable($nome)
  if ($v) { return $v }
  $s = Read-Host -AsSecureString "Valor de $nome ($para) - Enter vazio pula"
  $v = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))
  if ($v) { return $v } else { return $null }
}

# Roda um programa externo sem o PowerShell 5.1 transformar o stderr dele em erro fatal
# (com $ErrorActionPreference = 'Stop', até "2>$null" derruba o script). Confira $LASTEXITCODE depois.
function Externo([scriptblock]$comando) {
  $antes = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try { & $comando 2>&1 | ForEach-Object { "$_" } } finally { $ErrorActionPreference = $antes }
}

function ClaudeCmd {
  $c = Get-Command claude -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($c) { $c.Source } else { $null }
}

# --- 1. programas ----------------------------------------------------------------------
if (-not $PularProgramas) {
  Passo 'Programas (winget)'
  $ids = Get-Content "$Repo\programas\winget.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
  foreach ($id in $ids) {
    Externo { winget list --id $id --exact --accept-source-agreements --disable-interactivity } | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  ok   $id (já instalado)"; continue }
    Write-Host "  ...  $id"
    Externo { winget install --id $id --exact --accept-package-agreements --accept-source-agreements --disable-interactivity } | Out-Null
    if ($LASTEXITCODE -ne 0) { $Pendencias.Add("winget não instalou $id (código $LASTEXITCODE)") }
  }
  AtualizarPath
  # MiKTeX: baixar pacotes LaTeX sozinho (a skill curriculo-camaleao depende disso)
  $initexmf = (Get-Command initexmf -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source
  if (-not $initexmf) {
    $f = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64\initexmf.exe"
    if (Test-Path $f) { $initexmf = $f }
  }
  if ($initexmf) {
    Externo { & $initexmf --set-config-value='[MPM]AutoInstall=1' } | Out-Null
    Write-Host '  ok   MiKTeX instala pacotes sozinho'
  } else { $Pendencias.Add('MiKTeX não encontrado; a skill curriculo-camaleao não vai gerar PDF') }
}

# --- 2. Claude Code CLI ----------------------------------------------------------------
if (-not $PularClaude) {
  Passo 'Claude Code CLI'
  if (-not (ClaudeCmd)) {
    Externo { npm install -g @anthropic-ai/claude-code } | Out-Null
    AtualizarPath
  }
  if (ClaudeCmd) { Write-Host "  ok   $(Externo { & (ClaudeCmd) --version })" } else { $Pendencias.Add('Claude Code CLI não ficou no PATH; instale com: npm install -g @anthropic-ai/claude-code') }
}

# --- 3. arquivos do ~/.claude ----------------------------------------------------------
Passo "Arquivos do Claude em $Claude"
foreach ($alvo in 'settings.json', 'hooks', 'commands', 'plans') { Guardar (Join-Path $Claude $alvo) }
Get-ChildItem "$Repo\claude\skills" -Directory | ForEach-Object { Guardar (Join-Path $Claude "skills\$($_.Name)") }

$s = Ler "$Repo\claude\settings.json"
$s = $s.Replace('{{VAULT_JSON}}', (EscJson $VaultPath)).Replace('{{HOME_JSON}}', (EscJson $Destino)).Replace('{{HOME_FWD}}', $Destino.Replace('\', '/'))
foreach ($m in ([regex]::Matches($s, '\{\{ENV_[A-Z0-9_]+\}\}') | ForEach-Object Value | Sort-Object -Unique)) {
  $v = Segredo $m 'variável de ambiente do settings.json'
  if ($v) { $s = $s.Replace($m, $v.Replace('\', '\\').Replace('"', '\"')) } else { $Pendencias.Add("settings.json ficou com o marcador $m sem valor") }
}
if ($Amigo) {
  $cfg = $s | ConvertFrom-Json
  if ($cfg.hooks.PreToolUse) {
    $cfg.hooks.PreToolUse = @($cfg.hooks.PreToolUse | Where-Object { -not ($_.hooks | Where-Object { $_.command -like "*$HookPessoal*" }) })
  }
  $s = $cfg | ConvertTo-Json -Depth 30
}
Gravar "$Claude\settings.json" $s
Write-Host '  ok   settings.json'

foreach ($d in 'hooks', 'commands', 'plans') {
  if (-not (Test-Path "$Repo\claude\$d")) { continue }
  if ($Amigo -and $d -eq 'plans') { continue }
  $sem = if ($Amigo -and $d -eq 'hooks') { @($HookPessoal) } else { @() }
  Copiar "$Repo\claude\$d" "$Claude\$d" -semArquivos $sem
  Write-Host "  ok   $d"
}
Get-ChildItem "$Repo\claude\skills" -Directory | ForEach-Object {
  Copiar $_.FullName "$Claude\skills\$($_.Name)"
  Write-Host "  ok   skill $($_.Name)"
}

# Memórias: o nome da pasta de cada projeto é o caminho dele codificado, então
# os caminhos da máquina de origem são trocados pelos desta.
Passo 'Memórias'
$orig = Ler "$Repo\memoria\_origem.json" | ConvertFrom-Json
$encVault = Codificar $orig.vault
$encHome  = Codificar $orig.home
if ($Amigo) { Write-Host '  --   puladas (-Amigo)' }
Get-ChildItem "$Repo\memoria" -Directory | Where-Object { -not $Amigo } | ForEach-Object {
  $n = $_.Name
  if ($n -ieq $encVault) { $novo = Codificar $VaultPath }
  elseif ($n.ToLower().StartsWith($encHome.ToLower())) { $novo = (Codificar $Destino) + $n.Substring($encHome.Length) }
  else { $novo = $n }
  if ([char]::IsLower($n[0])) { $novo = $novo.Substring(0, 1).ToLower() + $novo.Substring(1) }
  $alvo = Join-Path $Claude "projects\$novo\memory"
  Guardar $alvo
  Copiar $_.FullName $alvo
  Write-Host "  ok   $novo ($((Get-ChildItem $_.FullName -File).Count) arquivos)"
}

Passo 'Outras configurações'
if (Test-Path "$Repo\agents") { Guardar "$Destino\.agents"; Copiar "$Repo\agents" "$Destino\.agents"; Write-Host '  ok   ~/.agents' }
if (Test-Path "$Repo\config\ccstatusline\settings.json") {
  Guardar "$Destino\.config\ccstatusline\settings.json"
  Gravar "$Destino\.config\ccstatusline\settings.json" (Ler "$Repo\config\ccstatusline\settings.json")
  Write-Host '  ok   statusline (ccstatusline)'
}
if (Test-Path "$Repo\config\gitconfig") {
  if ($Amigo) { Write-Host '  --   ~/.gitconfig pulado (-Amigo; ele traz a identidade do Cauê)' }
  elseif (Test-Path "$Destino\.gitconfig") { Write-Host '  --   ~/.gitconfig já existe; mantido (o do repo está em config\gitconfig)' }
  else { Gravar "$Destino\.gitconfig" (Ler "$Repo\config\gitconfig"); Write-Host '  ok   ~/.gitconfig' }
}

# --- 4. repos de terceiros -------------------------------------------------------------
Passo 'Repos de terceiros'
foreach ($e in (Ler "$Repo\externos\externos.json" | ConvertFrom-Json)) {
  $alvo = Join-Path $Destino $e.destino
  if (Test-Path "$alvo\.git") {
    Write-Host "  --   $($e.nome) já existe em $alvo; mantido (export estava em $($e.commit.Substring(0,7)))"
    continue
  }
  $saida = Externo { git clone --quiet $e.repo $alvo }
  if ($LASTEXITCODE -ne 0) { $Pendencias.Add("git clone de $($e.nome) falhou: $($saida -join ' ')"); continue }
  Externo { git -C $alvo checkout --quiet $e.commit } | Out-Null
  if ($LASTEXITCODE -ne 0) { $Pendencias.Add("$($e.nome): commit $($e.commit) não existe mais no upstream; ficou no HEAD atual") }
  $patch = Join-Path $Repo "externos\$($e.nome).patch"
  if (Test-Path $patch) {
    Externo { git -C $alvo apply $patch } | Out-Null
    if ($LASTEXITCODE -ne 0) { $Pendencias.Add("$($e.nome): o patch local não aplicou ($patch)") }
  }
  Write-Host "  ok   $($e.nome) @ $($e.commit.Substring(0,7))"
}

# --- 5. vault --------------------------------------------------------------------------
Passo "Vault em $VaultPath"
# Os .gitkeep só existem para o git guardar as pastas vazias; o robocopy cria as pastas sem eles.
if (Test-Path $VaultPath) {
  Copiar "$Repo\vault-esqueleto" $VaultPath -soFaltantes -semArquivos '.gitkeep'
  Write-Host '  ok   vault já existia; só foram acrescentados arquivos e pastas que faltavam'
} else {
  Copiar "$Repo\vault-esqueleto" $VaultPath -semArquivos '.gitkeep'
  Write-Host '  ok   vault criado a partir do esqueleto'
}

# --- 6. plugins e MCP ------------------------------------------------------------------
if (-not $PularClaude -and (ClaudeCmd)) {
  $cc = ClaudeCmd
  Passo 'Plugins'
  $pl = Ler "$Repo\plugins\plugins.json" | ConvertFrom-Json
  foreach ($m in $pl.marketplaces) {
    if ($m.nome -eq 'claude-plugins-official') { continue }
    $src = if ($m.source.repo) { $m.source.repo } else { $m.source.url }
    Externo { & $cc plugin marketplace add $src } | Out-Null
    $estado = if ($LASTEXITCODE -eq 0) { 'ok  ' } else { '--  ' }
    Write-Host "  $estado marketplace $($m.nome) ($src)"
  }
  foreach ($p in $pl.plugins) {
    Externo { & $cc plugin install $p.id --scope user } | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  ok   $($p.id)" } else { $Pendencias.Add("plugin $($p.id) não instalou; rode: claude plugin install $($p.id) --scope user") }
  }

  Passo 'Servidores MCP'
  $sv = Ler "$Repo\mcp\servidores.json" | ConvertFrom-Json
  foreach ($p in $sv.PSObject.Properties) {
    $nome = $p.Name; $c = $p.Value
    Externo { & $cc mcp get $nome } | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  --   $nome já cadastrado"; continue }
    $faltou = $false
    $resolver = {
      param($texto, $para)
      foreach ($m in [regex]::Matches($texto, '\{\{[A-Z0-9_]+\}\}')) {
        $v = Segredo $m.Value $para
        if (-not $v) { $script:faltou = $true; return $texto }
        $texto = $texto.Replace($m.Value, $v)
      }
      $texto
    }
    $a = @('mcp', 'add', '--scope', 'user')
    if ($c.type -eq 'stdio' -or $c.command) {
      $a += $nome
      if ($c.env) { foreach ($q in $c.env.PSObject.Properties) { $a += '-e', ($q.Name + '=' + (& $resolver $q.Value "MCP $nome")) } }
      $a += '--', $c.command
      if ($c.args) { $a += @($c.args) }
    } else {
      $a += '--transport', $c.type, $nome, $c.url
      if ($c.headers) { foreach ($q in $c.headers.PSObject.Properties) { $a += '--header', ($q.Name + ': ' + (& $resolver $q.Value "MCP $nome")) } }
    }
    if ($faltou) { $Pendencias.Add("MCP $nome não cadastrado (token não informado); rode o instalar.ps1 de novo quando tiver"); continue }
    $saida = Externo { & $cc @a }
    if ($LASTEXITCODE -eq 0) { Write-Host "  ok   $nome" } else { $Pendencias.Add("MCP $nome falhou ao cadastrar: $($saida -join ' ')") }
  }
}

# --- fim -------------------------------------------------------------------------------
Passo 'Pronto'
if (Test-Path $Backup) { Write-Host "  O que existia antes foi copiado para $Backup" }
Write-Host ''
Write-Host 'Passos manuais (não dá para automatizar):'
Write-Host '  1. Rode "claude" e faça o login (/login). As skills sincronizadas da conta do claude.ai voltam sozinhas.'
Write-Host '  2. "gh auth login" para o git conseguir dar push nos seus repos.'
Write-Host '  3. Abra o vault no Obsidian e ative os plugins da comunidade (Excalidraw).'
Write-Host '  4. Instale à mão o que não está no winget: app Maestri, Kotlin (kotlinc) e Flutter. Veja o README.'
if ($Pendencias.Count) {
  Write-Host ''
  Write-Host 'Pendências desta rodada:' -ForegroundColor Yellow
  $Pendencias | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
