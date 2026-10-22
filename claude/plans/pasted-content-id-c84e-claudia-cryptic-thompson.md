# Nota simples da spec do Agente de Cobrança no vault (e volta ao Plan Mode)

## Contexto

O Cauê está fechando a spec do **agente de cobrança para inadimplentes** dos franqueados do Cartão de
Todos (GeniAI). O motivo do projeto é que, desde 01/10/2026, a Meta cobra também as respostas de
serviço, então cada resposta do robô custa. Ele pediu uma **nota simples no vault, só para anotar a
spec** ("nada robusto por enquanto"). Saio do Plan Mode só para isso e volto a ele logo depois, para
continuar a spec uma pergunta por vez.

## O que vou fazer

1. Carregar a skill `obsidian-second-brain`, porque o AGENTS.md do vault manda.
2. **Criar `Projects/Active/Agente de Cobrança - Inadimplentes CDT.md`**. Já busquei antes e não há
   nota sobre cobrança ou inadimplência. O frontmatter é o mínimo (`date`, `tags: [project, geniai,
   cobranca]`, `status: planning`). O conteúdo é curto:
   - **O que é**: um parágrafo com o contexto, o desenho de referência
     (`Downloads/arquitetura agente inadimplente com jev.excalidraw`) e a informação de que começa do
     zero. O protótipo `agente-cobranca-lohanny` fica de fora, mas a lógica é a mesma.
   - **Decisões (2026-10-15/16)**, uma linha cada:
     - serviço próprio no servidor de produção;
     - Agent Bot no Chatwoot;
     - carteira importada no agente;
     - Pix dinâmico de um PSP com webhook;
     - o mesmo PSP, com a conta de cada franquia;
     - o agente dispara a abertura pela API do disparador;
     - toda saída (teto ou Jev) manda o canal externo da franquia;
     - LLM de redação neutro, escolhido por teste (o candidato é Groq `gpt-oss-120b`).
   - **Dúvidas abertas**:
     - a política de negociação por franquia (confirmar com o gestor do CDT);
     - o teto de mensagens (provisório: 3, e a 4ª manda o canal externo);
     - a stack (alinhar com o Tech Lead);
     - qual PSP.
   - **Stack: Go x Python, os porquês**:
     - a tabela curta de onde vai o tempo de um turno;
     - a conclusão de que a linguagem fica abaixo de 1% do turno;
     - os pontos a favor de cada uma;
     - a minha recomendação: Go no serviço e Python nos scripts de calibração;
     - a posição do Tech Lead (Go) e a dele (Python).
   - **Achados**:
     - o disparador só envia template e não recebe resposta;
     - a planilha do disparador é posicional;
     - problema vizinho, só reportado: o faturamento do disparador conta a mensagem de serviço a R$ 0.
   - **Próximo**: continuar a spec.
3. **Ligações mínimas**: uma linha em `index.md` (Recent Notes) e uma em `log.md` (`## 2026-10-16`).
4. **Memória do Claude**: `agente-cobranca-inadimplentes.md` (ponteiro para a nota, decisões,
   dúvidas) e uma linha no `MEMORY.md`.
5. **Voltar ao Plan Mode** (`EnterPlanMode`) e seguir com as perguntas que faltam:
   - onde fica o repositório e quem coda junto;
   - o workspace;
   - a janela de contato;
   - a LGPD no Jev (ZDR/No Training);
   - o mapeamento entre franquia, conta e inbox do Chatwoot.

## Verificação

- Reler a nota e conferir os wikilinks no `index.md` e no `log.md`.
- Não tocar em nenhum outro arquivo do vault.
