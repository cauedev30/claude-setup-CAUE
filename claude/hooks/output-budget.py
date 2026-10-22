#!/usr/bin/env python3
"""UserPromptSubmit: cobra prosa, tela, células e blocos da resposta anterior.
PLAN fica fora; skills explicativas isentam tela e blocos no próprio turno.
Portado do dv-dev1/claude-setup (hooks/output-budget.py)."""
import json
import os
import re
import sys

from _canario import registrar

from _transcript import ler_entradas, normalizar, texto_assistant, texto_humano

TETO_PADRAO = 8
COLUNAS_PADRAO = 100
CONTRATO_VISUAL = (
    "VISUAL PRIMEIRO: estrutura vira visual, prosa fica com o resto. "
    "Achados (leitura, pesquisa, subagente) = tabela arquivo:linha · o que é · "
    "por que importa, nunca saída colada. Ordem, causa ou ramo = caixas. "
    "Resposta até 15 linhas na tela, célula até 8 palavras, até 2 blocos; "
    "o detalhe fica no commit ou no arquivo."
)

# Cabeçalho de bloco cercado: ``` ou ~~~ com linguagem opcional.
_CERCA = re.compile(r"^[ \t]{0,3}(?:`{3,}|~{3,})")

# `## PLAN` sozinho na linha, com ou sem #, com ou sem negrito.
_PLAN = re.compile(
    r"^[ \t]{0,3}(?:#{1,6}[ \t]*)?\*{0,2}[ \t]*plan[ \t]*\*{0,2}[ \t]*:?[ \t]*$"
)

_CABECALHO = re.compile(r"^[ \t]{0,3}#{1,6}[ \t]+\S")
_TABELA = re.compile(r"^\s*\|", re.M)
_SEPARADOR = re.compile(r"^\s*\|(?:\s*:?-+:?\s*\|)+\s*$")
# Skill que explica por natureza não é cobrada por tela nem blocos; nenhuma por enquanto.
_SKILLS_ISENTAS = ()


def isenta_tela_blocos(entradas):
    if not _SKILLS_ISENTAS:
        return False
    fim = next((i for i in range(len(entradas) - 1, -1, -1)
                if not entradas[i].get("isSidechain") and texto_assistant(entradas[i])), -1)
    chamou_skill = False
    for entrada in reversed(entradas[:fim + 1]):
        if entrada.get("isSidechain"):
            continue
        conteudo = (entrada.get("message") or {}).get("content", "")
        texto = texto_humano(entrada)
        if entrada.get("type") == "user" and not entrada.get("isMeta"):
            bruto = conteudo if isinstance(conteudo, str) else "\n".join(
                b.get("text", "") for b in conteudo
                if isinstance(b, dict) and b.get("type") == "text")
            comando = re.search(r"<command-name>\s*([^<]+)</command-name>", bruto)
            if comando:
                texto = comando.group(1).strip()
        if texto:
            return chamou_skill or texto.strip() in tuple("/" + n for n in _SKILLS_ISENTAS)
        if entrada.get("type") == "assistant" and isinstance(conteudo, list):
            for bloco in conteudo:
                if isinstance(bloco, dict) and bloco.get("type") == "tool_use" \
                        and bloco.get("name") == "Skill":
                    skill = (bloco.get("input") or {}).get("skill", "")
                    chamou_skill |= isinstance(skill, str) and skill.endswith(_SKILLS_ISENTAS)
    return chamou_skill


def contar_tela_celulas_blocos(texto, colunas, teto_celula):
    tela = celulas = blocos = 0
    codigo = plan = tabela_anterior = False
    for linha in texto.splitlines():
        if not codigo and _PLAN.match(normalizar(linha)):
            plan = True
            tabela_anterior = False
            continue
        if plan:
            if _CABECALHO.match(linha):
                plan = False
            else:
                continue
        if linha.strip():
            tela += -(-len(linha.rstrip()) // colunas)
        if _CERCA.match(linha):
            blocos += not codigo
            codigo = not codigo
            tabela_anterior = False
            continue
        if codigo:
            continue
        tabela = bool(_TABELA.match(linha))
        blocos += tabela and not tabela_anterior
        if tabela and not _SEPARADOR.fullmatch(linha):
            celulas += sum(len(c.split()) > teto_celula for c in linha.strip().strip("|").split("|"))
        tabela_anterior = tabela
    return tela, celulas, blocos


def teto_env(nome, padrao):
    try:
        return int(os.environ.get(nome, padrao))
    except ValueError:
        return padrao


def tem_visual(texto):
    return "┌" in texto or "╭" in texto or bool(_TABELA.search(texto))


def ultima_resposta(entradas):
    for entrada in reversed(entradas):
        if entrada.get("isSidechain"):
            continue
        texto = texto_assistant(entrada)
        if texto:
            return texto
    return ""


def contar_prosa(texto, colunas=COLUNAS_PADRAO):
    """Linhas de prosa como aparecem na tela, ignorando código, o bloco PLAN e linhas vazias."""
    dentro_de_codigo = False
    dentro_de_plan = False
    total = 0

    for linha in texto.splitlines():
        if _CERCA.match(linha):
            dentro_de_codigo = not dentro_de_codigo
            continue
        if dentro_de_codigo:
            continue

        if _PLAN.match(normalizar(linha)):
            dentro_de_plan = True
            continue
        if dentro_de_plan:
            # o PLAN termina no próximo cabeçalho de seção
            if _CABECALHO.match(linha):
                dentro_de_plan = False
            else:
                continue

        if linha.strip() and not _TABELA.match(linha):
            # parágrafo sem quebra ocupa várias linhas na tela; contar a quebra deixava passar
            total += -(-len(linha.rstrip()) // colunas)

    return total


def main():
    if os.environ.get("OUTPUT_BUDGET_OFF") == "1":
        sys.exit(0)

    try:
        teto = int(os.environ.get("OUTPUT_BUDGET_LINHAS", TETO_PADRAO))
    except ValueError:
        teto = TETO_PADRAO
    try:
        colunas = max(20, int(os.environ.get("OUTPUT_BUDGET_COLUNAS", COLUNAS_PADRAO)))
    except ValueError:
        colunas = COLUNAS_PADRAO

    # no Windows o stdin de texto sai em cp1252; o payload do Claude Code é UTF-8
    bruto = sys.stdin.buffer.read().decode("utf-8", errors="replace")
    try:
        dados = json.loads(bruto) if bruto.strip() else {}
    except Exception:
        sys.exit(0)

    caminho = dados.get("transcript_path")
    entradas = ler_entradas(caminho) if caminho else []

    texto = ultima_resposta(entradas)
    linhas = contar_prosa(texto, colunas)
    teto_tela = teto_env("OUTPUT_BUDGET_TELA", 15)
    teto_celula = teto_env("OUTPUT_BUDGET_CELULA", 8)
    teto_blocos = teto_env("OUTPUT_BUDGET_BLOCOS", 2)
    tela, celulas, blocos = contar_tela_celulas_blocos(texto, colunas, teto_celula)
    isenta = isenta_tela_blocos(entradas)
    avisos = []
    if linhas > teto:
        avisos.append(
            "TETO DE SAÍDA: sua última resposta teve %d linhas de prosa, o teto é %d. "
            "Troque prosa por visual: lista com atributos vira tabela; ordem, causa ou ramo vira caixas. "
            "Sem recap, sem opção que não vai ser seguida." % (linhas, teto)
        )
    if linhas >= 6 and not tem_visual(texto):
        avisos.append(
            "VISUAL: sua última resposta teve %d linhas de prosa e nenhuma tabela nem caixa. "
            "O usuário entende pelo visual: estrutura vira tabela ou caixas, e a prosa fica com "
            "o que o visual não mostra." % linhas
        )
    if tela > teto_tela and not isenta:
        avisos.append(
            "TELA: sua última resposta ocupou %d linhas, o teto é %d. "
            "Uma tabela curta ou um diagrama, não os dois mais prosa." % (tela, teto_tela)
        )
    if celulas:
        avisos.append(
            "CÉLULA: sua última resposta teve %d células acima de %d palavras. "
            "Use rótulo, não frase; detalhe no arquivo." % (celulas, teto_celula)
        )
    if blocos > teto_blocos and not isenta:
        avisos.append(
            "BLOCOS: sua última resposta teve %d blocos, o teto é %d. "
            "Escolha tabela ou diagrama." % (blocos, teto_blocos)
        )
    saida = {
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": "\n".join([CONTRATO_VISUAL] + avisos),
        }
    }
    sys.stdout.write(json.dumps(saida))
    sys.exit(0)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        registrar("output-budget")
        sys.exit(0)
