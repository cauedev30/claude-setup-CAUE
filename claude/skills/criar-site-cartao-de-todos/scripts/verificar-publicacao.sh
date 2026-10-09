#!/usr/bin/env bash
# Portao pos-deploy: confere se o que o dominio PUBLICO entrega e o que esta no repo.
#
#   bash verificar-publicacao.sh <dominio> <pasta-do-site>
#
# Existe por causa de amparosaopaulo.online (2026-09-30): deploy "success", curl dando 200
# em tudo, e o site preso no preloader. O apex tinha um A extra apontando pro parking da
# GoDaddy e a Cloudflare tinha cacheado a pagina de parking NO LUGAR do script.js.
# Status 200 nao prova nada: aqui se confere tipo, conteudo e latencia de cada arquivo.
#
# Sai com 1 se qualquer checagem falhar. Deploy so esta fechado com este script verde.

set -u

if [ $# -ne 2 ] || [ ! -d "$2" ]; then
    echo "uso: $0 <dominio> <pasta-do-site>" >&2
    exit 2
fi

DOMINIO=$1
PASTA=$2
DOKKU_HOST=deploy.geniai.online
LIMITE_LATENCIA=3      # segundos; a origem responde em ~0.3s, a CF saudavel em < 1s
AMOSTRAS=8

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

falhas=0
cache_suspeito=0
latencia_suspeita=0

ok()    { printf '  OK     %s\n' "$*"; }
falha() { printf '  FALHA  %s\n' "$*"; falhas=$((falhas + 1)); }

# IP da origem, via DNS-over-HTTPS (nslookup/dig variam entre Git Bash, Linux e macOS)
IP_DOKKU=$(curl -s --max-time 10 "https://dns.google/resolve?name=$DOKKU_HOST&type=A" \
    | grep -o '"data":"[0-9.]*"' | head -1 | cut -d'"' -f4)
[ -n "$IP_DOKKU" ] || IP_DOKKU=143.95.222.84

tipo_esperado() {
    case "${1##*.}" in
        html) echo text/html ;;
        css)  echo text/css ;;
        js)   echo javascript ;;
        json) echo json ;;
        png)  echo image/png ;;
        jpg|jpeg) echo image/jpeg ;;
        svg)  echo image/svg ;;
        webp) echo image/webp ;;
        ico)  echo image/ ;;
        *)    echo "" ;;
    esac
}

titulo() { tr -d '\r\n' < "$1" | grep -o '<title>[^<]*</title>' | head -1; }

echo "== Arquivos de $PASTA servidos por https://$DOMINIO"
cd "$PASTA" || exit 2
for arq in $(find . -type f ! -path './.git/*' ! -name '.*' ! -name '*.md' ! -name '*.sh' ! -name '*.env' | sed 's|^\./||' | sort); do
    url="https://$DOMINIO/$arq"
    [ "$arq" = index.html ] && url="https://$DOMINIO/"
    corpo="$TMP/corpo"
    cab=$(curl -s --max-time 30 -D - -o "$corpo" "$url" | tr -d '\r')
    status=$(printf '%s\n' "$cab" | head -1 | awk '{print $2}')
    ctype=$(printf '%s\n' "$cab" | grep -i '^content-type:' | head -1 | cut -d' ' -f2-)
    cache=$(printf '%s\n' "$cab" | grep -i '^cf-cache-status:' | head -1 | awk '{print $2}')

    if [ "$status" != 200 ]; then
        falha "$arq -> HTTP ${status:-sem resposta}"
        continue
    fi
    # Assinatura do parking da GoDaddy: redirect por JS pra /lander
    if grep -q '/lander' "$corpo" && ! grep -q '/lander' "$arq"; then
        falha "$arq -> pagina de PARKING da GoDaddy (cf-cache-status: ${cache:-?})"
        [ "$cache" = HIT ] && cache_suspeito=1
        latencia_suspeita=1
        continue
    fi
    esperado=$(tipo_esperado "$arq")
    if [ -n "$esperado" ] && ! printf '%s' "$ctype" | grep -qi "$esperado"; then
        falha "$arq -> content-type '$ctype', esperado $esperado (cf-cache-status: ${cache:-?})"
        [ "$cache" = HIT ] && cache_suspeito=1
        continue
    fi
    case "$arq" in
        *.html)
            # A CF reescreve HTML (Email Obfuscation, beacon), entao compara so o <title>
            if [ "$(titulo "$corpo")" != "$(titulo "$arq")" ]; then
                falha "$arq -> <title> diferente do repo (cf-cache-status: ${cache:-?})"
                [ "$cache" = HIT ] && cache_suspeito=1
            else
                ok "$arq"
            fi ;;
        *.png|*.jpg|*.jpeg|*.webp|*.ico)
            if cmp -s "$corpo" "$arq"; then ok "$arq"; else
                falha "$arq -> bytes diferentes do repo (cf-cache-status: ${cache:-?})"
                [ "$cache" = HIT ] && cache_suspeito=1
            fi ;;
        *)
            # texto: ignora CRLF/LF, que muda conforme o checkout
            if cmp -s <(tr -d '\r' < "$corpo") <(tr -d '\r' < "$arq"); then ok "$arq"; else
                falha "$arq -> conteudo diferente do repo (cf-cache-status: ${cache:-?})"
                [ "$cache" = HIT ] && cache_suspeito=1
            fi ;;
    esac
done

echo "== Latencia: $AMOSTRAS acessos pela Cloudflare x origem direta ($IP_DOKKU)"
pior=0
for i in $(seq 1 "$AMOSTRAS"); do
    t=$(curl -s -o /dev/null --max-time 40 -w '%{time_total}' "https://$DOMINIO/?verif=$RANDOM$i")
    printf '  CF     %ss\n' "$t"
    pior=$(awk -v a="$pior" -v b="$t" 'BEGIN{print (b>a)?b:a}')
done
origem=$(curl -sk -o /dev/null --max-time 20 -w '%{time_total}' \
    --resolve "$DOMINIO:443:$IP_DOKKU" "https://$DOMINIO/")
printf '  origem %ss\n' "$origem"
if awk -v p="$pior" -v l="$LIMITE_LATENCIA" 'BEGIN{exit !(p>l)}'; then
    falha "pior acesso pela CF levou ${pior}s (limite ${LIMITE_LATENCIA}s) com a origem em ${origem}s"
    latencia_suspeita=1
else
    ok "pior acesso pela CF: ${pior}s"
fi

echo
if [ "$falhas" -eq 0 ]; then
    echo "PUBLICACAO OK — $DOMINIO entrega exatamente o que esta em $PASTA"
    exit 0
fi

echo "PUBLICACAO REPROVADA — $falhas falha(s)"
if [ "$latencia_suspeita" -eq 1 ]; then
    cat <<EOF

-> Latencia alta/intermitente com a origem rapida = o apex de $DOMINIO tem MAIS DE UM
   registro A. Na Cloudflare (DNS > Records), mantenha so o A do apex pra $IP_DOKKU e apague
   os outros A/AAAA do apex — tipicamente o parking da GoDaddy (3.33.130.190 / 15.197.148.33).
   NAO toque em MX, TXT, CNAME, SRV nem no www. Depois faca o passo abaixo.
EOF
fi
if [ "$cache_suspeito" -eq 1 ] || [ "$latencia_suspeita" -eq 1 ]; then
    if [ "$cache_suspeito" -eq 1 ]; then
        echo
        echo "-> A Cloudflare esta servindo do CACHE (cf-cache-status: HIT) um arquivo errado."
    else
        echo
        echo "-> Enquanto o A extra existiu, a Cloudflare pode ter cacheado o parking no lugar de"
        echo "   algum arquivo (foi o que travou o preloader do Amparo). Limpe por garantia."
    fi
    cat <<EOF
   Apagar o DNS nao limpa cache. Na Cloudflare: zona $DOMINIO > Caching > Configuration >
   Purge Everything. Aba anonima NAO resolve — o cache e da Cloudflare, nao do navegador.
   Rode este script de novo depois.
EOF
fi
exit 1
