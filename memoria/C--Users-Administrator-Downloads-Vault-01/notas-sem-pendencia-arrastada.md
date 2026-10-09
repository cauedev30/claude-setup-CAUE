---
name: notas-sem-pendencia-arrastada
description: "Cauê não quer pendências antigas arrastadas nas notas do vault — sessões novas são sobre coisas novas; estado atual fica no topo, histórico é registro"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 397005d7-8a32-4d4d-9d5b-0c9530902c6d
---

Ao retomar um projeto no vault, não trate as listas de "Pendências"/"Bloqueios"/"Próximo ponto de
retomada" das seções históricas como backlog vivo. Pergunte o estado atual antes de propor trabalho
a partir delas.

**Why:** as notas de projeto do Cauê crescem por acúmulo — uma seção de encerramento por sessão, cada
uma com sua própria lista datada. Ele trabalha bastante fora do chat, então o que está escrito como
pendente normalmente já foi resolvido e nunca voltou pra nota. Em 2026-07-15, na
[[Projects/Active/Automação Chatwoot GeniAI]], o prompt de retomada carregava 5 pendências de 2026-06-23
que não existiam mais. Palavras dele: "não tem nada pendente sobre tudo o que a gente fez até hoje...
as novas sessões são sobre coisas novas, não coisas antigas".

**How to apply:** padrão adotado — uma seção "Estado Atual" datada no topo da nota como única fonte de
verdade sobre o que está aberto, e o corpo marcado explicitamente como registro histórico/referência
técnica. Ao encerrar sessão, atualize o "Estado Atual" em vez de empilhar mais uma seção de encerramento.

**Mas não feche pendência técnica só na palavra dele.** Ainda em 2026-07-15, horas depois, o acesso ao
Supabase desmentiu 1 das 5 pendências que ele tinha dado como resolvidas (o token da AMS Odonto nunca
foi cadastrado). Ele tinha razão nas outras. A lição não é desconfiar dele — é que memória humana não
fecha pendência técnica, leitura de API/banco fecha. Quando houver acesso, verifique antes de escrever.
Sem acesso, escreva a fonte explícita ("confirmado pelo usuário em DATA", nunca "validado via API") —
ele valoriza essa distinção e ela foi o que permitiu achar e corrigir o erro depois.

**Ausência intencional ≠ pendência.** Quando algo parece faltando mas é decisão dele (token não
cadastrado de propósito, agente fora de um inbox de propósito), registre em destaque como intencional,
com o motivo — senão a sessão seguinte "conserta" e quebra o que ele quis. Ver [[chatwoot-geniai-estado]].
