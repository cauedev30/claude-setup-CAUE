---
name: lp-alfenas-ams
description: "LP Amor Saúde Alfenas publicada em alfenasmg.online (app ams-alfenas-lp, deploy 71) em 2026-10-01; gerada a partir da LP de Amparo; portão de latência ainda reprovando ao encerrar"
metadata:
  node_type: memory
  type: project
  originSessionId: 72c42f7f-4ba6-49d6-84a8-b3cb4465c050
  modified: 2026-10-01T16:28:55.760Z
---

alfenasmg.online publicada em 2026-10-01. App `ams-alfenas-lp`, repo público `cauedev30/ams-alfenas-LP`, que ele mesmo criou. Commit 8eb0723, deployId 71. Razão social `AMOR SAUDE ALFENAS LTDA` (CNPJ 43.327.548/0001-53), em CAIXA ALTA, reafirmado por ele. Título no formato longo, sem display name da WABA. Franquia confirmada por ele. Contato vem do PDF `_atualizado`: (35) 3091-0294, contato@alfenasmg.online. A Receita mostra (35) 3470-3415 / alfenas.mg@amorsaude.com, mas vale o PDF, mesmo padrão de [[lp-amparo-ams]].

A base foi a LP de Amparo, escolha dele, e não o `_template-amorsaude` cru. O template do repo criador continua sem as 4 correções.

**Why:** Ao encerrar, o `verificar-publicacao.sh` estava com os 12 arquivos OK, mas a latência reprovava: pela Cloudflare até 19,8 s, na origem 0,4 s. É o sintoma de A extra de parking da GoDaddy no apex. Ele disse que "testou e deu certo" e encerrou a sessão. Não confirmei se ele apagou o A e fez o Purge.
**How to apply:** Se ele voltar a falar de Alfenas lenta ou travada, rode o script primeiro. Se ainda reprovar, a correção é apagar o A extra no apex e fazer Purge Everything, ver [[lp-amparo-ams]].
