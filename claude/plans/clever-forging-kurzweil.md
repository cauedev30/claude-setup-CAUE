# Fechar a spec do agente de inadimplência

## Context

A spec (`repo/docs/spec.md`, `repo/docs/arquitetura.md`) parou na D26. As decisões D27 a D33 já estão
publicadas, mas o desenho ainda traz o `SIMULATE` e o `pediu_parcelamento`, embora não haja parcelamento
(D23). Também ainda traz o teto de 3 + 1, que agora é de 5 mais a 6ª fixa (D33). Faltam a ação do link do
CTN (D30) e as saídas para o humano no "atrito com a clínica" e na Energisa.

O Cauê quer começar com o que já temos: a dúvida aberta vira parâmetro ou interface falsa. O resultado
deste plano é a spec fechada, com as lacunas marcadas, pronta para o plano de implementação.

## Decisões novas desta sessão (viram D34 a D37 em `repo/docs/decisoes.md`)

| # | Decisão |
|---|---|
| D34 | O desconto vale só no **link do CTN com cadastro do cartão**. No Pix, o cliente paga o **integral**. Responde à pergunta da G1.1 sobre o Pix sem cartão |
| D35 | Até a G1.1 responder, o desconto sai em **3 degraus iguais** até o máximo da régua (R3: R$ 30, R$ 60, R$ 90). Cada objeção de valor libera o degrau seguinte. É um parâmetro por régua |
| D36 | **Propensão ao cartão**, calculada pelo backend com o histórico do CTN. Exemplo: 3 meses seguidos de Pix no mesmo dia do mês. Cliente propenso: o link do CTN vai primeiro, e a confirmação já convida a cadastrar o cartão. Cliente não propenso: o Pix vai primeiro, e o link com desconto só entra se ele pedir desconto. A regra é um parâmetro (N meses, tolerância de dias). Cliente sem histórico conta como não propenso |
| D37 | **Uma mensagem pode levar mais de um assunto**, porque cada mensagem custa. Exemplo: a confirmação do Pix e, na mesma mensagem, o convite para cadastrar o cartão; ou o débito total junto com o link. O Jev 2 escolhe **a ação principal**, que é uma pergunta de escolha. O **código anexa** as ações que a acompanham, por uma tabela fixa. O backend calcula os números de todas, e o LLM redige uma mensagem só |

## Padrões propostos para o que ainda está aberto (parâmetros, a confirmar)

| Lacuna | Padrão proposto |
|---|---|
| Prévia e R6 (G1.1) | R$ 60 nas duas, como disse a operação |
| Mais de 6 mensalidades | condição da R6 |
| Objeção na NR, R1 e R2 | explica a condição; 2ª objeção → humano |
| Pix gerado e não pago (G2.4) | vale 24h; sem pagamento, sem novo contato |
| Pagou depois do teto | a confirmação sai sempre (D33) |
| Confirmação fora da janela de 24h | vai por template de utilidade |
| Abertura no teto | não conta, porque é template (decidido pelo Cauê em 2026-10-22; entra no texto da D33) |

## O que muda no desenho

0. **Combinação de ações (D37).** O Jev só responde perguntas tipadas e não devolve uma lista, por isso ele escolhe a ação principal. Uma tabela fixa, em código, diz o que vai junto com ela:
   - `INFORM_DEBT` leva junto `SEND_CTN_LINK` se o cliente é propenso, ou `GENERATE_PIX` se não é (D36);
   - `OFFER_DISCOUNT` leva sempre `SEND_CTN_LINK` (D34);
   - `PAGO` leva o convite para o cartão quando o cliente é propenso e pagou no Pix.
   O Jev 3 confere se o texto cobre todas as ações (`bate_com_acao` vira "cobre todas as ações").
1. **Jev 2: as ações.**
   - Saem o `SIMULATE` e a pré-condição de parcelamento.
   - `INFORM_DEBT` apresenta sempre primeiro o débito total (D29).
   - Entra o `OFFER_DISCOUNT`. Pré-condições: a régua tem desconto, há um degrau seguinte e a objeção de valor foi detectada. O backend calcula o valor.
   - Entra o `SEND_CTN_LINK`: o cliente paga e cadastra o cartão (D30); o desconto só vale por aqui (D34).
   - `GENERATE_PIX` paga o integral (D34). Ele dispensa a "simulação válida" e sai pelo botão (D26) ou por pedido.
   - Continuam `OUT_OF_SCOPE`, `NONE` e `HUMAN`, e o `GENERATE_BOLETO` segue fora.
2. **Jev 1.**
   - Sai a pergunta `pediu_parcelamento`.
   - Entra `objecao_valor` (o cliente acha caro ou pede desconto).
   - Entram dois gatilhos de saída para o humano: `atrito_clinica` (ATRITO) e `quer_conta_energia` (ENERGISA, D30).
3. **Estados.** `AGUARDANDO_PAGAMENTO` guarda a forma (Pix ou link) e o degrau. Entra o estado `PAGO`: o webhook leva a `PAGO`, depois vem a 6ª fixa e então `ENCERRADO`, com a baixa no CTN (D31).
4. **Gates.** Teto de 5 mensagens de resolução. A abertura é template e não conta no teto. A 6ª é fixa: confirmação ou canal externo (D33).
5. **6ª mensagem fixa.** São modelos de catálogo, com o nome e os dados preenchidos pelo backend e sem LLM:
   - confirmação simples;
   - confirmação + convite para o cartão, numa mensagem só (D37), quando o cliente é propenso (D36) e pagou no Pix. Exemplo do Cauê: "Obrigado, fulano, por ter pago a sua dívida… vimos que você paga há mais de 3 meses no Pix; registre o seu cartão no link abaixo";
   - canal externo (texto da D19).
   Os textos finais são desenhados no projeto (D28), e o exemplo acima é só uma referência.
6. **Integrações como interfaces**, com implementação falsa até a T1 e a T9:
   - `CTN`: consulta do cliente e do histórico de pagamentos, geração do link, baixa e webhook;
   - `PixBanco`: cobrança com txid e webhook.
7. **Critério de aceite provisório**, até a G4:
   - as conversas simuladas passam no Jev 3 (as da Lohanny, quando chegarem; até lá, um roteiro nosso por régua);
   - nenhum número fora do backend;
   - o teto e a janela são respeitados em teste;
   - o modo sombra grava os laudos.

## Arquivos

- `repo/docs/decisoes.md`: entram a D34 a D37.
- `repo/docs/spec.md`: as seções 2 a 6 mudam, e sai o aviso de "pendente".
- `repo/docs/arquitetura.md`: mudam as seções 1 a 5 e a 8, com as interfaces do CTN e do Pix.
- `repo/docs/duvidas.md`:
  - a T8 fica respondida, e a G1.1 respondida em parte (Pix e degraus como parâmetro);
  - entram na T9 três perguntas: o CTN expõe o histórico de pagamentos com a forma e a data? O link do CTN aceita o valor com desconto? Quem pagou pelo link já sai com a baixa no próprio CTN?;
  - o contexto rápido passa para o teto de 5.
- `current-state.md` e `session-log.md` do workspace.
- **Depois da aprovação da spec:** o plano completo em `specs/planos/2026-10-22-plano-implementacao.md`. Ele traz as etapas 1 a 7, as tarefas com interfaces e testes, o "pronto quando", o checklist e uma parada por etapa. Não traz código e passa por uma revisão própria.

## Verificação

- `grep` sem `SIMULATE`, `pediu_parcelamento`, "teto de 3" nem "4ª" em `spec.md` e `arquitetura.md`.
- `python "C:/Users/Administrator/Desktop/workspace-standard/workspace.py" check .`
- Commit no repo e no workspace com o autor `cauedev30`. O push da spec só acontece com o ok do Cauê.
