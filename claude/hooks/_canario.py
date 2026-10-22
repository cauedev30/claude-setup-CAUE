#!/usr/bin/env python3
"""Canário: hook que falha aberto registra aqui a falha, senão morreria em silêncio.
Uso no `except` do hook: `registrar("nome-do-hook")` e `sys.exit(0)`. Nunca levanta."""
import datetime
import os
import traceback


def caminho_log():
    base = os.environ.get("CLAUDE_CONFIG_DIR") or os.path.join(
        os.path.expanduser("~"), ".claude"
    )
    return os.path.join(base, ".hooks-errors.log")


def registrar(hook, detalhe=None):
    """Anexa uma linha com o horário, o hook e a última linha do traceback."""
    try:
        if detalhe is None:
            detalhe = traceback.format_exc(limit=3).strip().replace("\n", " | ")
        quando = datetime.datetime.now().isoformat(timespec="seconds")
        with open(caminho_log(), "a", encoding="utf-8") as fh:
            fh.write("%s\t%s\t%s\n" % (quando, hook, detalhe[:500]))
    except Exception:
        pass
