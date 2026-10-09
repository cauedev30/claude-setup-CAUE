---
name: projeto-pdf-contact-editor
description: "Editor de PDF (e-mail/telefone) + saúde do CNPJ; fica em Desktop\\pdf_contact_editor, FORA da vault até existir repo"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4f65dbaa-1fb4-4339-b0cc-8ecff29e994d
  modified: 2026-09-30T23:41:09.108Z
---

Projeto em `C:\Users\Administrator\Desktop\pdf_contact_editor` (Python 3.12, PyMuPDF, Tkinter). Entregue 2026-09-09: editor determinístico de e-mail/telefone em comprovante de CNPJ + botão "Verificar saúde do CNPJ" (BrasilAPI). 71 testes. Atalho "Editor de PDF" na área de trabalho.

**Repo:** https://github.com/cauedev30/automacao-infos-cnpj — publicado 2026-09-09 (público; ele vai privar depois). 9 commits em camadas, autor `cauedev30 <cauefranco01@gmail.com>`, sem Co-Authored-By. `docs/DECISOES.md` é o registro de decisões que ele quer reler. Parser da saúde corrigido para PDFs de outro gerador (fontes 6,78/9,03pt, blocos embaralhados) — caso de regressão Camaragibe em `tests/data/`.

**Decisões dele (não realertar):**
- Fica fora da vault; a vault recebe SÓ o ponteiro do repo (ele disse isso antes do repo existir — confirmar se quer a nota agora).
- Ambiguidade (rótulo repetido com valor válido) ⇒ falha e lista, nunca adivinha.
- E-mail na saúde: só validar formato (nenhuma API pública da Receita tem e-mail — verificado, `email = None` na BrasilAPI).
  - CORREÇÃO 2026-09-30: `publica.cnpj.ws/cnpj/<cnpj>` TRAZ `estabelecimento.email` e ddd/telefone da Receita. Nesse dia a BrasilAPI deu 504/500 pra todo CNPJ não cacheado (inclusive um que já tinha funcionado); o editor não tem fallback. Reportado a ele; ainda não pediu pra mudar o código.
- Dígito verificador inválido = PROBLEMA, primeiro alerta, muda o veredito.

**Contexto:** ele via "divergência nos dois últimos dígitos do CNPJ" ao analisar comprovantes com o ChatGPT. Diagnóstico dado: são dígitos verificadores (mod 11); o comprovante real (52.899.433/0001-24) é válido; o LLM errava a conta. Regra que ficou: LLM nunca opina sobre dígito, checagem é determinística.

**Why:** ele quer ferramenta local, offline e reproduzível, não dependência do chat.
**How to apply:** mudanças no editor/saúde vão nesse diretório; ver README antes. Não criar nota na vault até ele pedir o repo. Ver também [[um-passo-de-cada-vez]] e [[inferencia-minha-nao-e-fala-dele]].
