# Rodada de correção: achados 5, 6 e 7 + FAQ de qualidade do número

## Contexto

O teste real de 2026-09-30 levantou três achados (spec `specs/2026-09-29-teste-real-no-chatwoot.md`) e
uma lacuna no FAQ. O dono mandou corrigir só isso nesta rodada. O relatório dos agentes do amigo fica
para outra vez. Fluxo de sempre:
1. o Orquestrador escreve a spec com o plano do Executor;
2. o Executor (subagente) implementa no `main` local de `repo/`, sem push;
3. o Orquestrador reinicia o backend do teste;
4. o dono testa e valida;
5. o push só com o aval dele.

O que a exploração mostrou:

- **Achado 5, frase da passagem.** `_write_decision` (`backend/geniai/app/process_turn.py:274-276`)
  sempre manda `TEXT.handoff`.
  - O `reply` da LLM não serve para a frase. Num turno de passagem, ele pode ter uma pergunta de
    esclarecimento, uma resposta acima do limite de perguntas ou a frase de abertura do FAQ.
  - Então precisa de um **campo novo** na saída da LLM.
  - O padrão de reserva já existe na linha 288: `(turn.reply.strip() if turn else "") or TEXT.clarify_fallback`.
- **Achado 6, choque na LLM.** A linha do tempo do log corrige o diagnóstico:
  - a chamada do ticket 40 começou às 17:00:04,1, antes do resumo do ticket 41 (06,5);
  - a primeira tentativa estourou os 5 s sozinha, e às 17:01:17 outra chamada levou 4,7 s sem choque
    nenhum (é a cauda do modelo grátis);
  - o que o resumo provavelmente atrasou foi a nova tentativa (2,7 s).

  Hoje o resumo (`_fill_missing_summary`, `process_turn.py:347-375`) só roda depois de passagem sem LLM
  (palavra-chave ou mídia). Ele é chamado dentro do turno da conversa A, com a trava dela. Ele começa
  mesmo com outra conversa usando a LLM. Nada coordena as chamadas.
- **Achado 7, a foto "duas vezes".** **Não é bug.** No ticket 38, a msg 145 (foto) caiu no turno da
  saudação, que não chama a LLM. A msg 147 trouxe outra foto: outro anexo no Chatwoot, com os mesmos
  bytes, porque o cliente reenviou. O turno seguinte leu as duas. Isso é de propósito: imagem não lida
  fica para o próximo turno com LLM (teste `tests/app/test_turn_images.py:202`), e os downloads rodam
  em paralelo, por isso o mesmo milissegundo. Sem mudança de código.
  - Observação para a lista de erros, **fora desta rodada**: a saudação pede "me conta qual é o
    problema" mesmo quando a primeira mensagem já trazia o problema, e por isso o cliente reenviou a
    foto.
- **FAQ.** O item "A qualidade do número caiu" fica em `backend/faq/faq.json:78-84`.
  - O único teste que valida o arquivo real é `tests/db/test_faq_file.py:224-254`. Ele exige 17 itens,
    toda linha do `knowledge_base` começando com `"- "` e nenhum `**`.
  - O item é casado pelo título, então manter o título atualiza o item no lugar.

## Tarefas do Executor

### T1 · FAQ: qualidade do número (texto meu a partir das regras do dono; aprovar junto com o plano)

Em `backend/faq/faq.json`, item "A qualidade do número caiu". O título, `applies_when` e o resto não
mudam.

`answer_text` (vai literal ao cliente):
```
Quando a qualidade cai, o mais seguro é:
-> Se estiver baixa: parar os disparos e só voltar quando a qualidade voltar para alta.
-> Se estiver média: esperar mais um pouco para voltar para alta. Se não voltar em 24 horas, pode disparar, mas em quantidade menor ou só para os clientes ativos (não para os inadimplentes).
-> Criar templates novos e parar de usar os que estavam sendo usados.
-> Dividir sempre os disparos em manhã e tarde.
-> Não repetir disparo para o mesmo cliente em menos de 14 dias.

A qualidade costuma voltar em 2 a 4 dias. Voltou para alta, já pode voltar a disparar normalmente, mesmo antes desse prazo. Vou avisar a equipe para acompanhar o seu número e passar o limite de disparos até normalizar.
```

`knowledge_base`, só três linhas mudam. As outras quatro seguem iguais.
- `- O índice de qualidade é atualizado a cada 6 horas.`
  - **Sai** "espere de 24 a 48 horas para confirmar a volta", porque briga com "voltou para alta, já
    pode disparar".
- `- Qualidade baixa ("Low"): parar todos os disparos e só voltar quando a qualidade voltar para alta. Voltou para alta, pode voltar a disparar normalmente, antes ou depois do prazo de 2 a 4 dias.`
  - Substitui a linha "Na qualidade baixa…".
- `- Qualidade média: esperar mais um pouco para voltar para alta. Se em 24 horas continuar média, pode disparar, mas em quantidade menor ou para uma base mais tranquila: os clientes ativos, não os inadimplentes.`
  - Linha nova.

Gate da tarefa: `tests/db/test_faq_file.py`.

### T2 · Achado 5: a LLM escreve a frase da passagem

Segue a decisão `decisions/2026-09-30-llm-escreve-a-frase-da-passagem-para-a-equipe.md`.

- **Campo novo `handoff_reply`** na saída da LLM (`geniai/llm/output_schema.py`, `InterpretedTurn` em
  `geniai/domain/types.py`).
  - É opcional e vale `""` por padrão, como `faq_answer_found`.
  - A leitura é tolerante, como `image_descriptions`: valor ruim ou acima de 300 caracteres vira `""`
    e nunca derruba o turno.
- **Prompt** (`geniai/llm/prompt.py`, no formato do JSON e nas regras dos campos):
  - A LLM só preenche o campo quando a própria leitura dela aponta passagem:
    - `human_requested`, `registration_mismatch` ou `off_topic` verdadeiro;
    - `faq_feedback` = `not_resolved` ou `unclear`;
    - `faq_feedback` = `question` com `faq_answer_found` falso;
    - nenhum item do FAQ serve (`faq_item_id` nulo e `needs_clarification` falso).
  - O texto é uma frase curta, em português do Brasil, de acordo com a conversa, dizendo que a equipe
    segue por aqui. Exemplo do dono: "Para um atendimento mais preciso, vou te encaminhar para a equipe
    de suporte".
  - A frase não responde a dúvida, não pergunta nada e não promete prazo. Fora desses casos, fica vazia.
  - Por que só nesses casos: saída a mais em todo turno custaria latência em todos.
- **Código** (`_write_decision`, `process_turn.py:274-276`): numa passagem com LLM no turno, usar
  `(turn.handoff_reply.strip() if turn else "") or TEXT.handoff`, no mesmo padrão da linha 288.
  - O texto fixo continua:
    - nas passagens sem LLM (palavra-chave, mídia pela segunda vez, falha da LLM);
    - nos limites que só o código conhece (limite de perguntas, limite de esclarecimento);
    - quando o campo vier vazio.
- **Testes:**
  - `tests/llm/test_output_schema.py`:
    - campo ausente vira `""`;
    - valor ruim ou longo vira `""`.
  - `tests/llm/test_interpret.py`: o prompt descreve o campo.
  - `tests/app/test_process_turn.py`:
    - a passagem com LLM usa a frase;
    - a frase vazia cai no texto fixo;
    - a passagem sem LLM segue com o texto fixo.
  - Aproveitar os testes de passagem com LLM que hoje não conferem o texto (linhas ~170, 178, 191,
    236).
  - `turn_json` em `tests/support/fakes.py` ganha o padrão `handoff_reply=""`.
- **Docs:**
  - `docs/specs/2026-09-23-single-agent-support-bot-design.md`, §6: o campo no contrato.
  - `docs/architecture.md`: quem escreve o texto da passagem.
  - `README.md:28-31`, se o item fala do texto.

### T3 · Achado 6: o resumo do card espera a LLM ficar livre

- **O resumo sai do turno.** Vira uma tarefa própria, registrada e cancelada na parada do app junto
  com o resto do trabalho de fundo.
  - Assim ele não segura a trava da conversa A e não conta como "turno rodando".
  - A resposta ao cliente já está na outbox antes dele, como hoje.
- **LLM livre** = nenhuma conversa na janela de juntar mensagens e nenhum turno rodando. O
  `DebouncedScheduler` (`geniai/app/turn_scheduler.py`) já tem `_timers` (janela) e `_running`
  (turnos).
  - O resumo espera esse estado antes de chamar a LLM.
  - Turno de cliente **nunca** espera o resumo.
  - Com a janela de 4 s, um cliente que escreve logo depois de o resumo começar ainda tem 4 s de folga.
    O resumo leva 1,5 a 3 s.
  - A fiação fica a cargo do Executor. A `RecordingScheduler` e o `Harness` dos testes têm que continuar
    funcionando.
- **Prazo total do resumo: 30 s**, contando espera e chamadas. `summary_deadline_ms` no `rules.py`,
  marcado `OWNER-UNCONFIRMED`.
  - Se passar do prazo ou a LLM falhar, vale a reserva de hoje: as palavras do cliente, cortadas em
    280, com categoria "Outros".
- **Log `card summary`** (formato JSON atual, sem texto nem telefone):
  - `ticketId`;
  - `waitedMs` (espera pela LLM livre);
  - `llmMs`;
  - `llmOutcomes`;
  - `fallback` (bool).
  - A linha "turn timing" não muda.
- **Não entra:** interromper um resumo em andamento. Com a espera e a folga da janela, o choque visto
  no log some. Se o log novo mostrar choque, volta para a mesa.
- **Testes** (padrão de LLM travada por `asyncio.Event` em `tests/api/test_webhook_api.py:138`):
  - o resumo espera outra conversa na janela e começa quando ela termina;
  - um turno que chega durante a espera do resumo chama a LLM sem esperar;
  - o prazo estourado leva à reserva;
  - a parada do app não fica presa num resumo esperando;
  - os testes de resumo que já existem (`test_process_turn.py:106, 122, 214, 225`,
    `test_turn_images.py:263`) continuam passando, ajustados ao resumo fora do turno.
- **Docs:** `docs/architecture.md`, nas seções de LLM e de logs.

## Regras do Executor (iguais às das rodadas anteriores)

- `main` local de `repo/`, **sem push**. O frontend não muda.
- TDD, commits pequenos. Autor `cauedev30 <cauefranco01@gmail.com>`, sem `Co-Authored-By`; no commit,
  `cd "C:/..."`. Mensagens em inglês, no estilo do `git log`.
- Nada de dado real no repo. Não abrir `secrets/` nem mexer no `backend/.env`.
- **Não parar nem reiniciar** o backend do teste (`python -m geniai` rodando de `repo/backend`), nem
  subir outro na porta 8000.
- Durante o trabalho, só os testes da área mexida. A suíte inteira roda uma vez, no fim.
- Gates, em `backend/` com o `.env` exportado:
  - `ruff check .`
  - `ruff format --check .`
  - `mypy geniai`
  - `pytest`
  - `python -m geniai.export_openapi`, sem mudança no `openapi.json`.
- No fim, relatório na spec: commits, gates, desvios.

## Passos do Orquestrador

1. Escrever `specs/2026-09-30-rodada-de-correcao.md` com este plano (contexto, T1 a T3, regras, gates).
   Atualizar a spec do teste:
   - achado 6 com a linha do tempo corrigida;
   - achado 7 fechado como "não é bug";
   - a observação da saudação como item para depois.

   Acrescentar à decisão da frase da passagem que o campo só vem nos casos de passagem pela leitura da
   LLM.
2. Disparar o Executor (subagente `general-purpose`, em segundo plano) com a spec.
3. No fim:
   - conferir `git log` e o relatório;
   - reiniciar o backend do teste com `secrets/teste-real.env`;
   - confirmar na `geniai_dev` que o item do FAQ carregou o texto novo;
   - fazer o reset dos tickets.
4. Entregar ao dono para o teste manual.

## Verificação

- **Gates do Executor**, acima.
- **Teste manual do dono** no WhatsApp:
  - fazer o FAQ de qualidade e perguntar "se voltar para alta antes, já posso disparar?". O bot deve
    responder, não passar para a equipe;
  - perguntar sobre qualidade média. O bot deve dar a regra das 24 h e da base de ativos;
  - responder "não" ao "resolveu?". A frase de passagem deve vir da LLM, não o texto fixo;
  - pedir "atendente" por palavra-chave. Continua o texto fixo, e o log `card summary` aparece com
    `waitedMs`.
- **Log do teste:**
  - `llmMs` dos turnos continua na faixa de 1,0 a 1,6 s: o campo novo não pesa;
  - nenhum turno com `timeout` enquanto houver `card summary`.
