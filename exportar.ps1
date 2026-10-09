<#
.SYNOPSIS
  Copia o setup do Claude desta máquina para dentro deste repo (máquina -> repo).

.DESCRIPTION
  Rode de novo sempre que mudar skill, hook, memória, plugin, MCP ou configuração.
  As pastas geradas são apagadas e recriadas a cada rodada, então o que você
  remover da máquina some do repo também.

  Segredos nunca entram: tokens de MCP e variáveis de ambiente com cara de
  segredo viram marcadores {{...}} que o instalar.ps1 pede na hora. No fim, uma
  varredura procura padrões de token em tudo que foi gerado e aborta se achar.

.EXAMPLE
  .\exportar.ps1              # só gera; você revisa com git diff e faz commit
  .\exportar.ps1 -Publicar    # gera, faz commit e push se a varredura passar
#>
param(
  [string]$VaultPath = "$env:USERPROFILE\Downloads\Vault_01",
  [switch]$Publicar
)

$ErrorActionPreference = 'Stop'
$Repo   = $PSScriptRoot
$Casa   = $env:USERPROFILE
$Claude = Join-Path $Casa '.claude'
$Utf8   = New-Object System.Text.UTF8Encoding($false)

# Pastas que este script gera. Tudo fora daqui (README, scripts, programas/) é escrito à mão.
$Geradas = 'claude', 'memoria', 'mcp', 'plugins', 'externos', 'agents', 'config', 'vault-esqueleto'

# Skills que não são copiadas: obsidian-second-brain é clone de terceiro (fica fixado
# por commit em externos/) e synced/ vem da conta do claude.ai no login.
$SkillsFora = 'obsidian-second-brain', 'synced'

# Do vault só sobe o esqueleto: regras, templates, config do Obsidian e as pastas vazias.
$VaultArquivos = '_CLAUDE.md', 'AGENTS.md', 'Home.md', 'Welcome.md'
$VaultPastasFora = '.obsidian', '.claude', '.codex', '.git', '.trash', 'Templates', 'workspace-*', 'loca-standards'

function Ler([string]$p) { [IO.File]::ReadAllText($p, $Utf8) }

function Gravar([string]$p, [string]$texto) {
  $dir = Split-Path $p -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  [IO.File]::WriteAllText($p, $texto, $Utf8)
}

function Espelhar([string]$origem, [string]$destino, [string[]]$semPastas = @(), [string[]]$semArquivos = @()) {
  $a = @($origem, $destino, '/E', '/NFL', '/NDL', '/NJH', '/NJS', '/NP', '/R:1', '/W:1')
  if ($semPastas)   { $a += '/XD'; $a += $semPastas }
  if ($semArquivos) { $a += '/XF'; $a += $semArquivos }
  robocopy @a | Out-Null
  if ($LASTEXITCODE -ge 8) { throw "robocopy falhou ($LASTEXITCODE): $origem" }
  $global:LASTEXITCODE = 0
}

# Roda um programa externo sem o PowerShell 5.1 transformar o stderr dele em erro fatal
# (com $ErrorActionPreference = 'Stop', até "2>$null" derruba o script). Com -soSaida o
# stderr é descartado, para não sujar o que vai ser gravado (o diff do patch, por exemplo).
function Externo([scriptblock]$comando, [switch]$soSaida) {
  $antes = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    if ($soSaida) { & $comando 2>$null } else { & $comando 2>&1 | ForEach-Object { "$_" } }
  } finally { $ErrorActionPreference = $antes }
}

function EscJson([string]$s) { $s.Replace('\', '\\') }

# Troca os caminhos desta máquina por marcadores que o instalar.ps1 resolve.
function Tokenizar([string]$t) {
  $t = $t.Replace((EscJson $VaultPath), '{{VAULT_JSON}}')
  $t = $t.Replace((EscJson $Casa), '{{HOME_JSON}}')
  $t = $t.Replace($Casa.Replace('\', '/'), '{{HOME_FWD}}')
  $t
}

function Slug([string]$s) { ($s -replace '[^A-Za-z0-9]', '_').ToUpper() }

$SegredoNome = '(?i)(key|token|secret|password|senha|auth)'

Write-Host "Exportando setup de $Casa para $Repo"

foreach ($g in $Geradas) {
  $p = Join-Path $Repo $g
  if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}

# --- claude/: settings, hooks, commands, skills, plans --------------------------------
$s = Ler "$Claude\settings.json"
$cfg = $s | ConvertFrom-Json
if ($cfg.env) {
  foreach ($e in $cfg.env.PSObject.Properties) {
    if ($e.Name -match $SegredoNome) {
      $s = [regex]::Replace($s, '("' + [regex]::Escape($e.Name) + '"\s*:\s*)"[^"]*"', '$1"{{ENV_' + (Slug $e.Name) + '}}"')
    }
  }
}
Gravar "$Repo\claude\settings.json" (Tokenizar $s)

foreach ($d in 'hooks', 'commands', 'plans') {
  if (Test-Path "$Claude\$d") { Espelhar "$Claude\$d" "$Repo\claude\$d" }
}

Get-ChildItem "$Claude\skills" -Directory | Where-Object { $SkillsFora -notcontains $_.Name } | ForEach-Object {
  Espelhar $_.FullName "$Repo\claude\skills\$($_.Name)" -semPastas '.git'
}

# --- memoria/: memórias de cada projeto ------------------------------------------------
Get-ChildItem "$Claude\projects" -Directory | ForEach-Object {
  $m = Join-Path $_.FullName 'memory'
  if ((Test-Path $m) -and (Get-ChildItem $m -File)) { Espelhar $m "$Repo\memoria\$($_.Name)" }
}
Gravar "$Repo\memoria\_origem.json" ((@{ home = $Casa; vault = $VaultPath } | ConvertTo-Json))

# --- mcp/: servidores MCP do escopo usuário, sem os segredos ---------------------------
# O ~/.claude.json tem chaves que só diferem na caixa (c:/ e C:/ do mesmo projeto), e o
# ConvertFrom-Json do PowerShell 5.1 recusa isso. O JavaScriptSerializer diferencia.
Add-Type -AssemblyName System.Web.Extensions
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = [int]::MaxValue
$cj = $js.DeserializeObject((Ler "$Casa\.claude.json"))
$servidores = [ordered]@{}
if ($cj.ContainsKey('mcpServers')) {
  foreach ($nome in $cj['mcpServers'].Keys) {
    $srv = $cj['mcpServers'][$nome]
    $novo = [ordered]@{}
    foreach ($k in $srv.Keys) { $novo[$k] = $srv[$k] }
    foreach ($campo in 'headers', 'env') {
      if (-not $srv.ContainsKey($campo)) { continue }
      $limpo = [ordered]@{}
      foreach ($k in $srv[$campo].Keys) {
        $marca = '{{MCP_' + (Slug $nome) + '_' + (Slug $k) + '}}'
        $prefixo = if ($srv[$campo][$k] -match '^(Bearer|Basic|Token) ') { $Matches[1] + ' ' } else { '' }
        $limpo[$k] = $prefixo + $marca
      }
      $novo[$campo] = $limpo
    }
    $servidores[$nome] = $novo
  }
}
Gravar "$Repo\mcp\servidores.json" ($servidores | ConvertTo-Json -Depth 10)

# --- plugins/: marketplaces e plugins instalados ---------------------------------------
$inst = Ler "$Claude\plugins\installed_plugins.json" | ConvertFrom-Json
$mkts = Ler "$Claude\plugins\known_marketplaces.json" | ConvertFrom-Json
$plug = [ordered]@{
  marketplaces = @($mkts.PSObject.Properties | ForEach-Object { [ordered]@{ nome = $_.Name; source = $_.Value.source } })
  plugins      = @($inst.plugins.PSObject.Properties | ForEach-Object {
                   [ordered]@{ id = $_.Name; versao = $_.Value[0].version; commit = $_.Value[0].gitCommitSha } })
}
Gravar "$Repo\plugins\plugins.json" ($plug | ConvertTo-Json -Depth 10)

# --- externos/: repos de terceiros fixados por commit ----------------------------------
$externos = @()
$osb = "$Claude\skills\obsidian-second-brain"
if (Test-Path "$osb\.git") {
  $remoto = "$(Externo -soSaida { git -C $osb remote get-url origin })".Trim()
  $commit = "$(Externo -soSaida { git -C $osb rev-parse HEAD })".Trim()
  $externos += [ordered]@{ nome = 'obsidian-second-brain'; destino = '.claude/skills/obsidian-second-brain'; repo = $remoto; commit = $commit }
  $sujo = Externo -soSaida { git -C $osb status --porcelain }
  if ($sujo) {
    # O git grava o patch direto: passar pelo pipeline do PowerShell estragaria os acentos.
    New-Item -ItemType Directory -Force "$Repo\externos" | Out-Null
    Externo -soSaida { git -C $osb diff HEAD --binary "--output=$Repo\externos\obsidian-second-brain.patch" } | Out-Null
    $novos = Externo -soSaida { git -C $osb ls-files --others --exclude-standard }
    if ($novos) { Write-Warning "obsidian-second-brain tem arquivos novos fora do git (não exportados): $($novos -join ', ')" }
  }
}
Gravar "$Repo\externos\externos.json" ((ConvertTo-Json @($externos) -Depth 5))

# --- agents/: skills do ~/.agents (Maestri e afins) ------------------------------------
if (Test-Path "$Casa\.agents") { Espelhar "$Casa\.agents" "$Repo\agents" }

# --- config/: statusline e git ---------------------------------------------------------
$ccs = "$Casa\.config\ccstatusline\settings.json"
if (Test-Path $ccs) { Gravar "$Repo\config\ccstatusline\settings.json" (Ler $ccs) }
if (Test-Path "$Casa\.gitconfig") { Gravar "$Repo\config\gitconfig" (Ler "$Casa\.gitconfig") }

# --- vault-esqueleto/ ------------------------------------------------------------------
if (Test-Path $VaultPath) {
  $ve = "$Repo\vault-esqueleto"
  foreach ($a in $VaultArquivos) { if (Test-Path "$VaultPath\$a") { Gravar "$ve\$a" (Ler "$VaultPath\$a") } }
  Espelhar "$VaultPath\Templates" "$ve\Templates"
  Espelhar "$VaultPath\.obsidian" "$ve\.obsidian" -semArquivos 'workspace*.json'
  # Só a árvore de pastas (2 níveis), sem notas: um .gitkeep segura cada pasta no git.
  Get-ChildItem $VaultPath -Directory | Where-Object { $n = $_.Name; -not ($VaultPastasFora | Where-Object { $n -like $_ }) } | ForEach-Object {
    Gravar "$ve\$($_.Name)\.gitkeep" ''
    Get-ChildItem $_.FullName -Directory | ForEach-Object { Gravar "$ve\$($_.Parent.Name)\$($_.Name)\.gitkeep" '' }
  }
} else {
  Write-Warning "Vault não encontrado em $VaultPath; vault-esqueleto/ não foi gerado."
}

# --- varredura de segredos -------------------------------------------------------------
$padroes = @(
  'sk-[A-Za-z0-9_-]{20,}', 'sbp_[A-Za-z0-9]{20,}', 'gh[pousr]_[A-Za-z0-9]{30,}',
  'eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}', 'AKIA[0-9A-Z]{16}', 'xox[abprs]-[A-Za-z0-9-]{10,}',
  '-----BEGIN [A-Z ]*PRIVATE KEY-----', 'Bearer [A-Za-z0-9._~+/-]{20,}'
)
$achados = Get-ChildItem ($Geradas | ForEach-Object { Join-Path $Repo $_ } | Where-Object { Test-Path $_ }) -Recurse -File |
  Where-Object { $_.Length -lt 5MB } |
  Select-String -Pattern $padroes -AllMatches
if ($achados) {
  Write-Host ''
  Write-Host 'PARADO: possíveis segredos no que foi exportado. Nada foi commitado.' -ForegroundColor Red
  $achados | ForEach-Object {
    $rel = $_.Path.Substring($Repo.Length + 1)
    $m = $_.Matches[0].Value
    Write-Host ("  {0}:{1}  {2}..." -f $rel, $_.LineNumber, $m.Substring(0, [Math]::Min(8, $m.Length)))
  }
  exit 1
}
Write-Host 'Varredura de segredos: limpa.' -ForegroundColor Green

if ($Publicar) {
  Externo { git -C $Repo add -A } | Out-Null
  if (Externo -soSaida { git -C $Repo status --porcelain }) {
    $msg = "chore: exporta setup em " + (Get-Date -Format 'yyyy-MM-dd HH:mm')
    Externo { git -C $Repo commit -q -m $msg } | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "git commit falhou ($LASTEXITCODE)" }
    Externo { git -C $Repo push -q } | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "git push falhou ($LASTEXITCODE); o commit ficou só local" }
    Write-Host "Publicado: $(Externo -soSaida { git -C $Repo log -1 --format='%h %s' })" -ForegroundColor Green
  } else {
    Write-Host 'Nada mudou desde o último export.'
  }
} else {
  Write-Host 'Pronto. Revise com "git status" / "git diff" e faça o commit.'
}
