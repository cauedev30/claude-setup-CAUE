#!/usr/bin/env python3
"""Leitura defensiva do transcript. Nada aqui levanta exceção: entrada malformada
devolve vazio, e o hook libera. Recorte do _transcript.py do dv-dev1/claude-setup."""
import json
import re
import unicodedata

# Chega como mensagem de usuário mas não é fala humana: eco de slash command,
# saída de comando local e lembretes injetados por hooks.
_NAO_HUMANO = (
    "<local-command-caveat>",
    "<command-name>",
    "<command-message>",
    "<local-command-stdout>",
    "<system-reminder>",
)


_SLASH_COMMAND = re.compile(r"^/[\w:-]+(\s|$)")


def ler_entradas(caminho):
    entradas = []
    try:
        with open(caminho, "r", encoding="utf-8", errors="replace") as fh:
            for linha in fh:
                linha = linha.strip()
                if not linha:
                    continue
                try:
                    entradas.append(json.loads(linha))
                except Exception:
                    continue
    except Exception:
        return []
    return entradas


def normalizar(texto):
    if not texto:
        return ""
    nfkd = unicodedata.normalize("NFKD", texto)
    return "".join(c for c in nfkd if not unicodedata.combining(c)).lower()


def _conteudo(entrada):
    msg = entrada.get("message")
    if not isinstance(msg, dict):
        return None
    return msg.get("content")


def texto_humano(entrada):
    tipo = entrada.get("type")

    # Mensagem enviada no meio do turno entra na fila antes de virar `user`.
    if tipo == "queue-operation":
        if entrada.get("operation") != "enqueue":
            return ""
        conteudo = entrada.get("content")
        if not isinstance(conteudo, str) or _SLASH_COMMAND.match(conteudo.strip()):
            return ""
        return conteudo.strip()

    if tipo != "user" or entrada.get("isMeta"):
        return ""

    conteudo = _conteudo(entrada)
    partes = []
    if isinstance(conteudo, str):
        partes.append(conteudo)
    elif isinstance(conteudo, list):
        for bloco in conteudo:
            if isinstance(bloco, dict) and bloco.get("type") == "text":
                partes.append(bloco.get("text") or "")

    texto = "\n".join(p for p in partes if p).strip()
    if not texto or texto.startswith(_NAO_HUMANO):
        return ""
    return texto


def texto_assistant(entrada):
    if entrada.get("type") != "assistant":
        return ""
    conteudo = _conteudo(entrada)
    if isinstance(conteudo, str):
        return conteudo
    if not isinstance(conteudo, list):
        return ""
    partes = [
        bloco.get("text") or ""
        for bloco in conteudo
        if isinstance(bloco, dict) and bloco.get("type") == "text"
    ]
    return "\n".join(p for p in partes if p)
