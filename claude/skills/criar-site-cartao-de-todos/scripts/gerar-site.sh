#!/usr/bin/env bash
# Gera o site de uma unidade franqueada Cartao de Todos a partir do template
# criador-de-sites-padrao-cdt/templates-editados-/template-cartaodetodos.
#
# Uso:  ./gerar-site.sh <dir-template> <dir-destino> <arquivo-dados>
#
# O arquivo de dados e um KEY=valor por linha, UTF-8, com EXATAMENTE estas chaves:
#   TITULO_SITE, RAZAO_SOCIAL, CNPJ, ENDERECO, ENDERECO_MAPS,
#   TELEFONE, EMAIL, CIDADE_ESTADO, DATA_ATUALIZACAO
# DISCLOSURE_FRANQUIA e montado pelo script a partir de RAZAO_SOCIAL + CNPJ.
#
# Rode no Git Bash. NAO use PowerShell 5.1 para editar estes HTML:
# Set-Content/Out-File sem -Encoding utf8 grava em ANSI e corrompe os acentos.

set -euo pipefail

TEMPLATE="${1:?dir do template}"
DEST="${2:?dir de destino}"
DADOS="${3:?arquivo de dados}"

CHAVES=(TITULO_SITE RAZAO_SOCIAL CNPJ ENDERECO ENDERECO_MAPS TELEFONE EMAIL CIDADE_ESTADO DATA_ATUALIZACAO)

[ -f "$TEMPLATE/index.html" ] || { echo "ERRO: $TEMPLATE nao parece ser o template (sem index.html)"; exit 1; }
[ -f "$DADOS" ] || { echo "ERRO: arquivo de dados $DADOS nao existe"; exit 1; }

# ---- carregar dados sem executar o arquivo -------------------------------
declare -A V
while IFS= read -r linha || [ -n "$linha" ]; do
    case "$linha" in ''|'#'*) continue;; esac
    k="${linha%%=*}"; v="${linha#*=}"
    V["$k"]="$v"
done < "$DADOS"

faltando=()
for k in "${CHAVES[@]}"; do
    [ -n "${V[$k]:-}" ] || faltando+=("$k")
done
if [ ${#faltando[@]} -gt 0 ]; then
    echo "ERRO: chaves ausentes ou vazias no arquivo de dados: ${faltando[*]}"
    exit 1
fi

# Disclosure montado AQUI, com razao social e CNPJ ja por extenso.
# Nunca deixar {{...}} aninhado dentro do disclosure.
V[DISCLOSURE_FRANQUIA]="Site operado por ${V[RAZAO_SOCIAL]} — CNPJ ${V[CNPJ]}, unidade franqueada autorizada de Cartão de Todos. Marca \"Cartão de Todos\" utilizada sob licença de franquia."

# ---- copiar template ------------------------------------------------------
mkdir -p "$DEST"
cp -r "$TEMPLATE"/. "$DEST"/
rm -f "$DEST/CLAUDE_INSTRUCTIONS.md" "$DEST"/SKILL_*.md
echo "Template copiado para $DEST"

# ---- substituir -----------------------------------------------------------
# escapa \  &  e o delimitador | para o lado direito do s|||
esc() { printf '%s' "$1" | sed -e 's/[\|&]/\&/g'; }

cd "$DEST"
for k in "${CHAVES[@]}" DISCLOSURE_FRANQUIA; do
    sed -i "s|{{$k}}|$(esc "${V[$k]}")|g" *.html
done
echo "Placeholders substituidos em: $(ls *.html | tr '\n' ' ')"

# ---- portao de verificacao -------------------------------------------------
falhou=0
check() { # descricao, comando-que-deve-ter-saida-vazia
    local desc="$1"; shift
    local out; out="$("$@" 2>/dev/null || true)"
    if [ -n "$out" ]; then
        echo "FALHOU: $desc"; echo "$out" | head -5; falhou=1
    else
        echo "ok: $desc"
    fi
}

check "nenhum placeholder {{...}} sobrando"      grep -oh "{{[A-Z_]*}}" index.html politica-cookies.html politica-privacidade.html termos-uso.html
check "nenhum marcador [RAZAO_SOCIAL]/[CNPJ]"    grep -oh "\[RAZAO_SOCIAL\]\|\[CNPJ\]" index.html politica-cookies.html politica-privacidade.html termos-uso.html

# estes precisam ESTAR presentes em TODAS as 4 paginas
for f in index.html politica-cookies.html politica-privacidade.html termos-uso.html; do
    grep -q "franqueada autorizada" "$f"       || { echo "FALHOU: disclosure de franquia ausente em $f"; falhou=1; }
    grep -q "$(esc "${V[CNPJ]}")" "$f"         || { echo "FALHOU: CNPJ ausente em $f"; falhou=1; }
    grep -q "$(esc "${V[RAZAO_SOCIAL]}")" "$f" || { echo "FALHOU: razao social ausente em $f"; falhou=1; }
done
grep -q "application/ld+json" index.html || { echo "FALHOU: JSON-LD sumiu do index.html"; falhou=1; }
[ "$falhou" -eq 0 ] && echo "ok: disclosure, razao social, CNPJ nas 4 paginas; JSON-LD presente"

# JSON-LD tem que continuar sendo JSON valido depois da substituicao
if command -v node >/dev/null 2>&1; then
    if sed -n '/application\/ld+json/,/<\/script>/p' index.html \
       | sed '1d;$d' | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>JSON.parse(s))' 2>/dev/null; then
        echo "ok: JSON-LD e JSON valido"
    else
        echo "FALHOU: JSON-LD virou JSON invalido (aspas ou barra num valor?)"; falhou=1
    fi
else
    echo "AVISO: node nao encontrado, JSON-LD nao foi validado"
fi

# {{TITULO_SITE}} alimenta tambem o <span> da navbar (index) e o do .legal-logo
# (paginas legais). O template ja tem regra responsiva pros dois, mas titulo muito
# longo ocupa varias linhas -- vale conferir no navegador.
n=${#V[TITULO_SITE]}
if [ "$n" -gt 40 ]; then
    echo "AVISO: TITULO_SITE tem $n caracteres e vai inteiro para a navbar do index e"
    echo "       para o cabecalho das 3 paginas legais. O template quebra em varias"
    echo "       linhas no mobile por regra propria -- confira visualmente."
fi

echo
if [ "$falhou" -ne 0 ]; then
    echo "==> PORTAO REPROVADO. NAO commite, NAO faca deploy. Corrija acima."
    exit 1
fi
echo "==> Portao aprovado. Falta revisar visualmente antes de commitar."
