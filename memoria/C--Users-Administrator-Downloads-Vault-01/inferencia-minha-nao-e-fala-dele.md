---
name: inferencia-minha-nao-e-fala-dele
description: Achado meu que muda o produto tem que ser confirmado com ele ANTES de eu construir em cima - senão vira premissa no vault e produz trabalho inteiro na direção errada
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 37a32517-f19f-4f6e-8936-24098b222e09
  modified: 2026-08-26T19:54:03.995Z
---

Quando eu levantar um **achado meu** que muda o entendimento do produto — não um detalhe técnico, mas
algo que redefine o que a coisa faz — eu tenho que **confirmar com ele antes de construir qualquer
coisa em cima**. Marcar como "inferência minha, não validada" na nota **não basta**: o rótulo se
apaga na leitura seguinte e o achado vira premissa.

**Why:** aconteceu no [[tier0-chatbot-suporte-geniai]] entre 2026-08-24 e 2026-08-26. Eu gravei como
achado que *"`P2`/`P3` não são dúvida, são execução — o autoatendimento é o bot fazendo o que hoje é
feito na mão"*. Era inferência minha, nunca fala dele, e estava rotulada como tal. Duas sessões
depois eu já tinha escrito uma spec técnica inteira de port em cima disso e levantado um risco de
autorização elaborado (quem pode mandar o bot apagar quem, sem rollback). Ele desfez tudo com uma
frase: *"Não é para o bot ter a permissão de apagar, adicionar alguém ou qualquer que seja a opção."*
O trabalho não foi perdido inteiro, mas foi feito na direção errada por dois dias, e o vault carregou
a premissa errada nesse período.

**How to apply:** achado que muda **o que o produto faz** vira **pergunta na hora**, curta e direta,
não seção de nota. Achado que muda **como o produto faz** pode ficar registrado como inferência e
esperar. O teste: *se isso estiver errado, o que eu escrever depois vira lixo?* Se sim, pergunte
antes. Ver também [[um-passo-de-cada-vez]] e [[notas-sem-pendencia-arrastada]].
