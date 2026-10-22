# Spec — Simulador de Investimento em Studios (identidade ADR Empreendimentos)

Data: 2026-10-13 · Autor: Cauê Franco · Status: **para sua revisão**

---

## 0. Como ler este documento

Esta é a **proposta completa do projeto**: o que vamos construir, para quem, como o cálculo funciona,
de onde vêm os dados, quais tecnologias usamos e por quê, como provamos que funciona e o que fica de
fora. Ela vem antes de qualquer código. Depois que você aprovar, ela vira `docs/spec.md` no
repositório e só então escrevemos o **plano de implementação** (o passo a passo de construção), que
também passa pela sua revisão.

Termos que aparecem o tempo todo (o glossário completo vira `docs/glossario.md`):

| Termo | Em uma frase |
|---|---|
| **Na planta** | Comprar o imóvel antes de ficar pronto, pagando durante a obra. |
| **Chaves** | A entrega do imóvel. A partir daí ele pode gerar renda. |
| **INCC** | Índice Nacional de Custo da Construção. Corrige as parcelas pagas durante a obra. |
| **IPCA** | Inflação oficial. Reajusta diária e aluguel ano a ano. |
| **CDI** | Taxa de referência da renda fixa. "Rende mais que o CDI?" é a pergunta do investidor. |
| **Tesouro IPCA+** | Título público que paga inflação + um juro real fixo. Segundo termo de comparação. |
| **Fluxo de caixa** | A lista, mês a mês, de quanto dinheiro sai (−) e entra (+) do bolso do investidor. |
| **TIR** | Taxa Interna de Retorno: a "taxa de juros" que o investimento rendeu, considerando quando cada real saiu e entrou. Compara direto com o CDI. |
| **VPL** | Valor Presente Líquido: quanto o investimento vale hoje, descontando o futuro pela taxa do CDI. VPL > 0 = bateu o CDI. |
| **Payback** | Em quantos meses a renda devolve o que saiu do bolso. |
| **Yield** | Renda líquida de um ano ÷ custo do imóvel. É o "aluguel em % ao ano". |
| **Ocupação** | % das noites do mês em que o studio está alugado na temporada. |
| **Sazonalidade** | O padrão de meses fortes e fracos do turismo (janeiro cheio, maio vazio). |
| **Valor venal** | Valor do imóvel para a prefeitura; base do IPTU. Costuma ser menor que o de mercado. |
| **ITBI** | Imposto municipal pago na compra do imóvel. |
| **Premissa** | Um número que o usuário informa ou aceita como padrão (ex.: ocupação 55%). O resultado depende delas. |

---

## 1. Contexto e objetivo

### O problema
A ADR Empreendimentos (João Pessoa/PB) vende **studios compactos de alto padrão (16 a 39 m²) na
orla** — Bessa, Cabo Branco, Jardim Oceania, Intermares (Cabedelo) — com o discurso "Compactos
inteligentes. Alto padrão. **Alta rentabilidade**". Quem compra é, em boa parte, **investidor**. Mas
"alta rentabilidade" é promessa, não número. O investidor quer saber:

> **"Se eu comprar este studio na planta, quanto ele rende de verdade — e isso é melhor do que deixar
> o dinheiro no CDI?"**

### A solução
Um **simulador web** com a identidade visual da ADR. O investidor ajusta as premissas (preço, forma de
pagamento, diária, ocupação, aluguel, valorização) e vê na hora:

- o **fluxo de caixa mês a mês**, da assinatura na planta até a venda;
- **aluguel por temporada (Airbnb) × aluguel tradicional**, lado a lado;
- **TIR, VPL, payback, yield** e o **patrimônio final** comparado com **CDI** e **Tesouro IPCA+**;
- quanto do retorno veio do **aluguel** e quanto da **valorização**;
- **cenários** pessimista / base / otimista e um **mapa de sensibilidade** (TIR por ocupação × diária).

### O que ele demonstra na vaga
- **Coleta de dados públicos** por API e arquivos (Banco Central, ANAC, FipeZAP, Tesouro) e tratamento
  com pandas — inclusive reduzir um arquivo de 360 MB a uma tabela de sazonalidade.
- **Modelagem** de um problema de negócio real (matemática financeira + sazonalidade).
- **Indicadores** que o mercado imobiliário usa (TIR, VPL, payback, yield).
- **Visualização e narrativa** (notebooks de estudo de caso + app).
- **Engenharia**: testes automatizados, API, CI, documentação, reprodutibilidade.

### Para quem
**Investidor comprador.** Linguagem simples, números em R$ e %, e cada premissa com explicação e fonte
ao passar o mouse.

### O que é sucesso
1. Você abre o app na entrevista, muda uma premissa e explica por que o número mudou.
2. Todo número do app é rastreável: fórmula em `docs/metodologia.md`, premissa com fonte em
   `docs/premissas.md`.
3. O notebook de estudo de caso chega a uma conclusão defendível (ex.: "nas premissas base, temporada
   rende X% a.a. contra Y% do tradicional e Z% do CDI; o resultado depende sobretudo da ocupação").
4. Tudo roda na sua máquina com comandos documentados.

---

## 2. Decisões já tomadas (nesta conversa)

| # | Decisão | Por quê |
|---|---|---|
| D1 | Público: **investidor comprador** | História mais clara e demonstrável. |
| D2 | Compra **na planta**: entrada + parcelas mensais corrigidas pelo INCC + **saldo à vista nas chaves** | Fluxo essencial; financiamento bancário fica fora. |
| D3 | Renda: **temporada × tradicional**, lado a lado | A comparação é o achado mais interessante. |
| D4 | **Venda no fim do horizonte** (padrão 10 anos após as chaves) com valorização | Sem venda, a TIR fica subestimada e a comparação com renda fixa é injusta. |
| D5 | **Python** em tudo que é dado e cálculo (pipeline, motor, API FastAPI, notebooks); **Next.js + React** no front | Pedido seu. O "cérebro" fica em Python (o que a vaga avalia) e o front mostra seu lado full stack. Mesmo padrão do chatbot (FastAPI + Next.js 16). |
| D6 | **Identidade visual da ADR**, como se fosse um app deles, **sem aviso** de protótipo | Decisão sua. Mitigação: repositório **privado desde o primeiro commit**. |
| D7 | **Local primeiro**; deploy é fase opcional depois | Repo privado não funciona no painel Dokku; a apresentação roda na sua máquina. |
| D8 | Mora em `Vault_01/workspace-simulador-adr/` (padrão `workspace-standard`); código em `repo/` = clone de `cauedev30/simulador-adr` (privado) | Pedido seu: memória junto, contexto isolado, como o workspace do chatbot. |
| D9 | Código, documentação e commits em **português** | Você vai ler e apresentar; vaga brasileira. |
| D10 | **Escopo completo**, construído em **dois marcos**: o Marco 1 já é apresentável | Você escolheu a completa; a data da entrevista ainda é desconhecida. |
| D11 | ⚠ **Proposta minha, confira:** projeções de longo prazo (CDI, IPCA, INCC) usam a **média anual dos últimos 10 anos** como padrão, e o valor atual aparece como referência no campo | O horizonte é de ~13 anos; usar o CDI de hoje (13,65%) por 13 anos deixaria o imóvel injustamente ruim; a média de 10 anos é mais defensável. É só o padrão: o usuário muda. |

---

## 3. O que o investidor vê

Página principal (`/`) com o visual da ADR e página de método (`/como-calculamos`).

```
┌──────────────────────────────────────────────────────────────────────────┐
│  [logo ADR]                                   Simulador · Como calculamos │
├──────────────────────────────────────────────────────────────────────────┤
│  Seu studio na orla rende quanto?                                         │
│  Cenário:  [ Pessimista ] [ Base ] [ Otimista ]                           │
├────────────────────────┬─────────────────────────────────────────────────┤
│ PREMISSAS              │  RESULTADO                                       │
│ ▸ Imóvel e pagamento   │  ┌ TIR ─────┐┌ Patrimônio ┐┌ Payback ┐┌ Yield ┐ │
│   preço, m², entrada,  │  │Temp 14%  ││ vs CDI     ││ 8 anos  ││ 7,1%  │ │
│   parcelas, chaves     │  │Trad  9%  ││ +R$ 180 mil││         ││       │ │
│ ▸ Temporada (Airbnb)   │  └──────────┘└────────────┘└─────────┘└───────┘ │
│   diária, ocupação,    │  [Gráfico] Patrimônio no tempo:                  │
│   taxas, custos        │     temporada × tradicional × CDI × IPCA+        │
│ ▸ Aluguel tradicional  │  [Gráfico] Renda líquida mês a mês (sazonalidade)│
│ ▸ Venda e comparação   │  [Gráfico] De onde veio o retorno:               │
│   horizonte, valoriz., │     aluguel × valorização × custos               │
│   CDI, IPCA+           │  [Mapa]    TIR por ocupação × diária             │
│ (cada campo: ⓘ com     │  [Tabela]  Fluxo mês a mês (expansível) + CSV    │
│  explicação e fonte)   │                                                  │
└────────────────────────┴─────────────────────────────────────────────────┘
```
(Os números do desenho são ilustrativos.)

- Mudar uma premissa recalcula em até ~1 s (chamada à API com pequena espera para não disparar a cada
  tecla).
- Os botões de cenário trocam um conjunto de premissas de uma vez.
- `/como-calculamos` explica as fórmulas e fontes em linguagem simples (versão curta de
  `docs/metodologia.md`) e mostra os gráficos de contexto: INCC × IPCA × CDI dos últimos anos e a
  curva de sazonalidade do aeroporto de João Pessoa.
- Funciona no celular (as premissas viram uma gaveta acima dos resultados).

---

## 4. Como o cálculo funciona (modelo financeiro)

Tudo é calculado **mês a mês**, em reais nominais. `docs/metodologia.md` repete cada fórmula com um
**exemplo numérico resolvido** do início ao fim.

### 4.1 Linha do tempo
- **Mês 0**: assinatura do contrato (data-base; padrão = mês atual, ajustável).
- **Meses 1 a P**: obra (P = prazo de obra em meses; padrão 36).
- **Mês P**: chaves.
- **Meses P+1 a P+12·N**: operação (N = anos de horizonte após as chaves; padrão 10).
- **Último mês**: venda.
- Cada mês tem data real de calendário: precisamos do mês do ano (sazonalidade) e do número de dias.

### 4.2 Pagamento na planta (D2)
Premissas: preço de tabela, entrada %, parcelas % (em k parcelas mensais, k ≤ P), saldo nas chaves %
(**entrada + parcelas + chaves = 100%**, validado), INCC projetado (% a.a.).

- `incc_mensal = (1 + incc_anual)^(1/12) − 1` e `fator_incc(m) = (1 + incc_mensal)^m`
- **Entrada** (mês 0) = entrada% × preço, sem correção.
- **Parcela** (meses 1..k) = (parcelas% × preço ÷ k) × fator_incc(m).
- **Saldo das chaves** (mês P) = chaves% × preço × fator_incc(P).
- **Custos de aquisição** (mês P): ITBI% e registro/escritura% sobre o preço.
- **Mobília e enxoval** (mês P): um valor por modalidade.

Simplificação documentada: o INCC real tem defasagem de 1 a 2 meses e o índice pós-chaves depende do
contrato; ignoramos (o saldo é quitado nas chaves).

### 4.3 Renda por temporada (Airbnb) — por mês de operação
- `ocupação_mês = min(ocupação_média × índice_sazonal[mês do ano], ocupação_máxima)` — o índice vem da
  ANAC (seção 5) e tem média 1,0; ocupação máxima padrão 95%.
- `noites = dias_do_mês × ocupação_mês`
- **Diária** = o que o hóspede paga por noite; reajustada pelo IPCA a cada 12 meses de operação.
- **Receita bruta** = noites × diária.
- **Custos**: taxa da plataforma (% da receita), gestão/anfitrião (% da receita), limpeza
  (noites ÷ estadia média × custo por estadia), condomínio, IPTU ÷ 12, contas fixas (energia, internet,
  streaming), reserva de manutenção (R$/mês).
- **IR** (pessoa física, carnê-leão): alíquota × (receita − plataforma − gestão − condomínio − IPTU).
  Simplificação: uma alíquota informada (padrão 27,5%, a alíquota marginal de quem já tem outra renda);
  a tabela progressiva e a redução da Lei 15.270/2025 ficam fora.
- **Renda líquida** = receita − custos − IR. Pode ser negativa num mês fraco; o modelo aceita.

### 4.4 Renda por aluguel tradicional — por mês de operação
- **Aluguel** reajustado pelo IPCA a cada 12 meses.
- **Vacância** como valor esperado: recebido = aluguel × (1 − vacância%).
- Condomínio e IPTU são do inquilino, **exceto** na vacância: custo = vacância% × (condomínio + IPTU÷12).
- **Administração** da imobiliária: % do aluguel recebido.
- **IR**: alíquota × (recebido − administração).
- **Renda líquida** = recebido − administração − custo de vacância − IR.

### 4.5 Venda (D4)
- `valor_de_venda = preço × (1 + valorização_anual)^(meses_totais ÷ 12)`, contando desde o mês 0.
- **Corretagem**: % sobre a venda.
- **IR sobre ganho de capital**: 15% × max(0, venda − corretagem − custo de aquisição); custo de
  aquisição = tudo que foi pago pelo imóvel + ITBI + registro. Simplificação: sem os fatores redutores
  da lei; a mobília não entra na venda.

### 4.6 Indicadores (para cada modalidade)
Fluxo do investidor: pagamentos (−), rendas líquidas (+/−), venda líquida (+).

| Indicador | Cálculo | Observação |
|---|---|---|
| **TIR a.a.** | taxa mensal r que zera Σ fluxo_m ÷ (1+r)^m; anualizada `(1+r)^12 − 1` | Implementada por nós (bisseção), testada contra casos conhecidos. Sem solução → "indefinida", com explicação. |
| **VPL** | Σ fluxo_m ÷ (1 + cdi_líquido_mensal)^m | VPL > 0 = bateu o CDI. |
| **Payback** | 1º mês em que o acumulado **sem a venda** fica ≥ 0 | Se não acontece no horizonte: "não se paga só com aluguel em N anos". |
| **Exposição máxima** | menor valor do fluxo acumulado | "Quanto do seu bolso fica empatado no pior momento." |
| **Yield líquido** | renda líquida dos 12 primeiros meses de operação ÷ custo total de aquisição | |
| **Composição do retorno** | soma das rendas líquidas · ganho líquido na venda · custos totais | "Veio do aluguel ou da valorização?" |

### 4.7 Comparação com CDI e Tesouro IPCA+ (justa)
Pergunta: *"e se cada real que eu coloquei no imóvel tivesse ido para a renda fixa?"*
- **Patrimônio na renda fixa** = cada pagamento do imóvel aplicado na data em que saiu, rendendo até o
  fim do horizonte.
- **Patrimônio no imóvel** = venda líquida + rendas líquidas reaplicadas na mesma renda fixa até o fim
  (assim os dois lados têm o dinheiro "trabalhando" o tempo todo).
- **CDI**: taxa projetada (padrão D11). **IPCA+**: `(1 + IPCA)(1 + juro_real) − 1`, com o juro real do
  título Tesouro IPCA+ de vencimento mais próximo do fim do horizonte (seção 5).
- As duas **líquidas de 15% de IR** (aplicação longa). Simplificação: IR como redução da taxa, não no
  resgate.

### 4.8 Cenários e sensibilidade
- **Cenários**: pessimista / base / otimista são conjuntos de premissas guardados no arquivo de
  premissas padrão, cada um com justificativa (tabela na seção 5.3).
- **Sensibilidade**: grade da TIR da temporada para ocupação (40% a 90%, passo 10) × diária (−30% a
  +30%, passo 10%), mostrada como mapa de calor. Responde "a partir de que ocupação vale a pena?".

---

## 5. Dados

Fontes **verificadas em 2026-10-13** (endereços testados; detalhes técnicos em `docs/dados.md`).

### 5.1 Fontes que o pipeline baixa

| Fonte | O quê | Como | Para quê |
|---|---|---|---|
| **Banco Central — SGS** | INCC-M (série 7456), IPCA (433), CDI acumulado no mês (4391), todos mensais | API JSON pública `api.bcb.gov.br/dados/serie/bcdata.sgs.{código}/dados`. Mensais vêm inteiras (o limite de 10 anos só vale para séries diárias). | Padrões de INCC, IPCA e CDI (D11); gráfico de contexto; notebook 01. |
| **ANAC — Dados Estatísticos do Transporte Aéreo** | Passageiros por empresa × mês × rota, 2000 a 2026 (`Dados_Estatisticos.csv`, **360 MB**, separador `;`, primeira linha "Atualizado em") | Download único para `data/raw/` (fora do git); leitura em pedaços com pandas, filtro do aeroporto de João Pessoa (**SBJP**, origem ou destino), soma de passageiros pagos + grátis. Resultado: ~320 linhas. | **Índice sazonal**: média de cada mês do ano ÷ média geral, sem 2020–2021 (pandemia) e sem ano incompleto. Conferido: jul/2026 ficou a ~1% do número da Aena. |
| **FipeZAP** | Preço de venda (R$/m²), aluguel (R$/m²) e rental yield de João Pessoa | Planilha pública `fipezap-serieshistoricas.xlsx`, aba "João Pessoa" (venda desde 2018; locação desde 2022) | Padrão de **valorização** (média anual da série) e do **aluguel tradicional** (yield × preço). |
| **Tesouro Transparente** | Taxas diárias dos títulos do Tesouro Direto (CSV de ~14 MB) | Download; filtro "Tesouro IPCA+"; última taxa de cada vencimento | **Juro real** do benchmark IPCA+. |

O pipeline: `python -m pipeline.atualizar [bcb|anac|fipezap|tesouro|tudo]`. Ele tenta de novo quando a
API falha (o firewall do Banco Central devolve erro intermitente), confere o formato da resposta,
descarta o mês corrente incompleto e grava `data/processed/*.csv`, que **vão para o git** — o app e os
notebooks funcionam sem internet e sem baixar os 360 MB de novo.

### 5.2 Fontes de referência (lidas à mão, citadas no dicionário de premissas)
- **AirDNA** (12 meses até set/2026): João Pessoa 7.143 anúncios, ocupação 56%, diária US$ 51;
  Cabedelo ocupação 48%.
- **Airbtics** (fev/2025–jan/2026): João Pessoa ocupação 58%, diária R$ 224.
- **Boletim de Ocupação Hoteleira PBTur/UFPB** (jul/2026): jan 88%, fev 76%, mar 83%, abr 70%, jul 73%
  — usado no notebook 02 para **validar** a curva da ANAC (hotel ≠ Airbnb, mas o desenho do ano deve
  bater).
- **Airbnb Brasil**: taxa única de 16% (a taxa dividida de 4% está sendo descontinuada).
- **Imprensa local (Paraíba Business)**: gestora 15–30%, condomínio de unidade pequena na orla
  R$ 500–700, energia R$ 150–250, m² em Cabo Branco ~R$ 20,3 mil (sem metodologia).
- **Lei Complementar 53/2008 (JP)**: IPTU residencial 1% do valor venal.
- **Receita Federal**: tabela do IR 2026.
- **Inside Airbnb**: **não serve** (no Brasil só cobre Rio e São Paulo).

### 5.3 Premissas padrão (valores iniciais propostos)

Ficam em `backend/data/premissas_padrao.json`, cada uma com valor, unidade, faixa válida, descrição,
fonte e data. "Estimativa" = sem fonte oficial, rotulada assim no app.

| Grupo | Premissa | Base | Pessimista | Otimista | Origem |
|---|---|---|---|---|---|
| Imóvel | Área | 20 m² | | | Faixa dos studios da ADR (16–39 m²) |
| | Preço de tabela | R$ 380.000 (R$ 19 mil/m²) | | | Estimativa (imprensa: ~R$ 20,3 mil/m² em Cabo Branco) |
| Pagamento | Entrada / parcelas / chaves | 15% / 35% em 36× / 50% | | | Estimativa de mercado (ajuste pela tabela de vendas) |
| | Prazo de obra | 36 meses | | | Estimativa (entregas da ADR em 2028–2029) |
| | INCC projetado | média 10 anos (BCB) | | | D11 |
| Aquisição | ITBI | 3% | | | Imprensa; **conferir no Código Tributário Municipal** na fase de dados |
| | Registro e escritura | 1% | | | Estimativa |
| Temporada | Ocupação média | 55% | 45% | 65% | AirDNA 56% / Airbtics 58% |
| | Diária | R$ 250 | R$ 210 | R$ 290 | Airbtics R$ 224 (média geral) · flat no Booking R$ 289 |
| | Ocupação máxima no mês | 95% | | | Estimativa |
| | Taxa da plataforma | 16% | | | Airbnb (taxa única) |
| | Gestão | 20% | | | Imprensa (15–30%) |
| | Estadia média / limpeza | 3 noites / R$ 80 | | | Estimativa |
| | Contas fixas | R$ 250/mês | | | Imprensa (energia R$ 150–250) + internet |
| | Mobília e enxoval | R$ 35.000 | | | Estimativa |
| Tradicional | Aluguel | yield FipeZAP × preço (≈ R$ 2.100) | | | FipeZAP JP (0,56% a.m.) |
| | Vacância | 8% | 15% | 4% | Estimativa (≈ 1 mês/ano) |
| | Administração | 10% | | | Estimativa de mercado |
| | Mobília | R$ 25.000 | | | Estimativa |
| Ambos | Condomínio | R$ 600/mês | | | Imprensa (R$ 500–700) |
| | IPTU | 0,5% do preço ao ano | | | LC 53/2008: 1% do valor venal; venal ≈ 50% do mercado (estimativa) |
| | Manutenção | R$ 100/mês | | | Estimativa |
| | Alíquota de IR sobre aluguel | 27,5% | | | Receita Federal (alíquota marginal) |
| Venda | Horizonte após as chaves | 10 anos | | | D4 |
| | Valorização anual | média FipeZAP JP | = IPCA (ganho real zero) | média + 2 p.p. | FipeZAP |
| | Corretagem | 6% | | | Padrão de mercado |
| | IR ganho de capital | 15% | | | Receita Federal |
| Renda fixa | CDI | média 10 anos (BCB) | | | D11 (atual: 13,65% a.a.) |
| | IPCA | média 10 anos (BCB) | | | D11 |
| | Juro real IPCA+ | taxa do título mais próximo do horizonte | | | Tesouro (IPCA+ 2035: 6,66% em 09/10/2026) |

### 5.4 Limitações dos dados (ditas no README e no app)
- Não há dado público de Airbnb por bairro nem por tipo de imóvel (studio); ocupação e diária são da
  cidade inteira.
- A sazonalidade de Airbnb não é pública; usamos passageiros do aeroporto, validados com a ocupação
  hoteleira.
- O FipeZAP de João Pessoa não tem recorte por bairro; a orla custa ~2,4× a média da cidade.
- Custos de condomínio e de gestora vêm de imprensa.

---

## 6. Arquitetura e stack

```
  Fontes públicas              Python (backend)                        Navegador
  ───────────────              ────────────────────────────────        ──────────
  Banco Central ───┐           pipeline/ → baixa, limpa, salva
  ANAC (360 MB) ───┤                       data/processed/*.csv ──┐
  FipeZAP ─────────┼─────────►             premissas_padrao.json  │
  Tesouro ─────────┘                                              ▼
                               simulador/ (motor de cálculo puro, testado)
                                    ▲                    ▲
                     api/ (FastAPI) │                    │ notebooks/ (estudo de caso)
                                    │ JSON
                                    ▼
                               frontend/ (Next.js + React) ──────►  investidor
```

**Regra central:** o **motor** (`simulador/`) é Python puro — recebe premissas, devolve resultado, não
sabe nada de web nem de download. A API e os notebooks **usam o mesmo motor**, então o número do
notebook é o número do app.

### Estrutura do repositório (`repo/`)
```
simulador-adr/
├── README.md                 estudo de caso: problema → dados → solução → achados → como rodar
├── docs/                     spec, metodologia, premissas, dados, arquitetura, glossário,
│                             apresentacao, decisoes/
├── backend/
│   ├── simulador/            premissas, pagamento, renda_temporada, renda_tradicional, venda,
│   │                         indicadores, comparacao, sensibilidade, simulacao
│   ├── pipeline/             bcb, anac, fipezap, tesouro, sazonalidade, atualizar
│   ├── api/                  main (FastAPI), rotas, esquemas
│   ├── data/                 raw/ (fora do git) · processed/ (no git) · premissas_padrao.json
│   ├── tests/                + fixtures/ com amostras pequenas das fontes
│   └── requirements.txt
├── notebooks/                01_indicadores · 02_sazonalidade · 03_estudo_de_caso
├── frontend/                 Next.js (App Router) + TypeScript
└── .github/workflows/ci.yml
```

### Stack e o porquê de cada peça
| Peça | Escolha | Por quê |
|---|---|---|
| Linguagem de dados | **Python 3.12** (já instalado) | Requisito da vaga e seu. |
| Tratamento | **pandas**, **numpy** | Padrão de mercado para analista de dados. |
| Download | **requests** | APIs e arquivos públicos sem autenticação. |
| Planilha FipeZAP | **openpyxl** | Leitor de `.xlsx` usado pelo pandas. |
| Premissas | **pydantic** | Premissas tipadas e validadas (faixas, soma = 100%). |
| API | **FastAPI** + **uvicorn** | Mesmo padrão do chatbot; documentação automática em `/docs`. |
| Notebooks | **Jupyter** + **matplotlib** | matplotlib aparece no GitHub (Plotly não). |
| Testes / estilo | **pytest**, **ruff** | Testes do motor, pipeline e API; código padronizado. |
| Front | **Next.js 16 + React + TypeScript**, **Tailwind CSS** | Pedido seu; mesmo stack do chatbot. |
| Gráficos (front) | **Recharts** | Gráficos React simples, inclusive o mapa de calor (feito com células). |
| Node | 24 (instalado), npm | |
| Ambiente Python | `venv` + `pip` | Sem ferramenta extra para aprender agora. |
| CI | GitHub Actions | Testes + lint + build a cada push (repo privado tem 2.000 min/mês grátis). |

Sem banco de dados: os dados são pequenos e cabem em CSV versionado.

A máquina tem ~8 GB de RAM: para apresentar, o front sobe com `npm run build` + `npm run start`
(mais leve que `npm run dev`), e a leitura da ANAC é em pedaços para não estourar memória.

---

## 7. API (contrato)

| Método e rota | Faz | Resposta |
|---|---|---|
| `GET /premissas/padrao` | Premissas padrão + cenários | Cada premissa com valor, unidade, faixa, descrição, fonte e data — o front monta o formulário a partir disso. |
| `POST /simulacoes` | Roda a simulação | Tabela mensal por modalidade, indicadores, comparação com CDI e IPCA+, composição do retorno. |
| `POST /simulacoes/sensibilidade` | Grade ocupação × diária | Matriz de TIR. |
| `GET /indicadores/historico` | INCC, IPCA e CDI tratados | Gráfico de contexto em `/como-calculamos`. |
| `GET /sazonalidade` | Índice sazonal por mês + passageiros | Gráfico de sazonalidade em `/como-calculamos`. |

Erros: premissa inválida → **422** com mensagem em português por campo ("Entrada + parcelas + chaves
precisa somar 100%; hoje soma 95%"). Documentação interativa em `http://localhost:8000/docs`.

---

## 8. Front (identidade ADR)

- **Identidade extraída do site** (adrempreendimentos.com): paleta preto e branco (`#000000`,
  `#FFFFFF`, cinza `#7A7A7A`); títulos em **Brinnan** (fonte paga → substituta parecida, escolhida na
  implementação); textos em **Lexend Deca** e **Roboto** (Google Fonts); logo branco do site; estética
  de orla como nas páginas deles. Ajuste fino com a skill de design **impeccable** (copiada do workspace
  do chatbot) e a skill **dataviz** nos gráficos.
- Componentes: painel de premissas agrupado, cartões de indicador, gráfico de patrimônio, gráfico de
  renda mensal, gráfico de composição, mapa de calor, tabela mensal com exportar CSV, botões de
  cenário, tooltips com explicação + fonte.
- Estados: carregando (esqueleto), API fora do ar (mensagem clara + tentar de novo), premissa inválida
  (campo destacado com a mensagem da API), TIR indefinida (explicação no cartão).
- Tipos TypeScript escritos à mão em `frontend/lib/tipos.ts`, espelhando os esquemas da API.

---

## 9. Testes e critério de aceite

**Motor (pytest)**, com valores calculados à mão:
- TIR de fluxo conhecido (−100 hoje, +110 em 12 meses → 10% a.a.); fluxo sem solução → "indefinida".
- Pagamento: com INCC 0%, as partes somam o preço; com INCC, cada parcela bate com a fórmula.
- Temporada com índice sazonal 1,0 em todos os meses = conta conferida à mão; teto de ocupação respeitado.
- Tradicional: vacância 0% → recebido = aluguel; vacância 100% → só custo.
- Venda: valorização 0% e custos 0 → venda = preço; IR nunca negativo.
- Comparação: imóvel que rende exatamente o CDI líquido → VPL ≈ 0.
- Sensibilidade: TIR cresce com a ocupação (monotonia).
- Validação: entrada + parcelas + chaves ≠ 100% → erro.

**Pipeline**: testes com amostras pequenas salvas em `tests/fixtures/` (sem internet no teste):
filtro SBJP, índice sazonal com média 1,0, descarte do mês incompleto, leitura da aba do FipeZAP.
**API**: TestClient do FastAPI — 200 com premissas padrão; 422 com premissa inválida.
**Front**: `npm run lint` + `npm run build` sem erro; verificação no navegador.

**Critério de aceite rodável** ("pronto" = saída disto colada na spec do workspace):

Marco 1:
1. `cd backend && python -m pytest` → tudo verde.
2. `python -m pipeline.atualizar bcb` e `... anac` → `data/processed/` com as colunas esperadas.
3. `uvicorn api.main:app` + `POST /simulacoes` com as premissas padrão → 200 com TIR, VPL e payback.
4. `cd frontend && npm run build` → sem erro.
5. No navegador (`localhost:3000`): "Pessimista" derruba a TIR; mudar a ocupação mexe no gráfico mensal.
6. Notebook 03 executa do zero (`jupyter nbconvert --execute`) e o número principal dele é igual ao que
   a API devolve para as mesmas premissas.

Marco 2 (além do Marco 1):
7. `python -m pipeline.atualizar tudo` → também FipeZAP e Tesouro processados.
8. Mapa de sensibilidade, gráfico de composição, tabela + CSV e `/como-calculamos` funcionando no navegador.
9. Notebooks 01, 02 e 03 executam do zero.
10. CI verde no GitHub no último commit.

---

## 10. Documentação entregue

| Arquivo | Conteúdo | Marco |
|---|---|---|
| `README.md` | O estudo de caso em uma página: problema, pergunta, dados, solução, prints, achados, como rodar, stack. | 1 (completo no 2) |
| `docs/spec.md` | Este documento. | 1 |
| `docs/metodologia.md` | Cada fórmula em linguagem simples, com **exemplo numérico resolvido** do início ao fim, e a lista de simplificações. | 1 |
| `docs/premissas.md` | Dicionário: cada premissa, padrão, unidade, fonte, data, por que esse valor. | 1 |
| `docs/glossario.md` | Termos de finanças e de dados do projeto. | 1 |
| `docs/apresentacao.md` | Roteiro de 5 minutos para a entrevista + perguntas prováveis e respostas. | 1 |
| `docs/dados.md` | Cada fonte: o que é, como baixamos, como limpamos, limitações. | 2 |
| `docs/arquitetura.md` | Como as peças conversam, com diagrama. | 2 |
| `docs/decisoes/` | Um arquivo por decisão técnica (contexto, decisão, consequências). | 2 |
| `notebooks/03_estudo_de_caso` | Studio típico: temporada × tradicional × CDI × IPCA+, cenários, sensibilidade, **conclusões e recomendação**. | 1 (sensibilidade e IPCA+ no 2) |
| `notebooks/01_indicadores` | INCC × IPCA × CDI: por que o INCC importa para quem compra na planta. | 2 |
| `notebooks/02_sazonalidade` | Do arquivo de 360 MB ao índice sazonal, validado com o boletim hoteleiro. | 2 |

---

## 11. Marcos de entrega (D10)

**Marco 1 — núcleo apresentável.** Workspace e repo; pipeline Banco Central + ANAC; premissas padrão
com fonte (valores do FipeZAP digitados à mão, com fonte); motor completo (pagamento, temporada,
tradicional, venda, indicadores, comparação com CDI, cenários); API `GET /premissas/padrao` e
`POST /simulacoes`; página principal com premissas, cartões, gráfico de patrimônio, gráfico de renda
mensal e cenários; notebook 03; README, metodologia, premissas, glossário e roteiro de apresentação;
testes do motor e da API. **Aqui você já pode apresentar.**

**Marco 2 — completa.** Pipeline FipeZAP e Tesouro (padrões passam a vir dos dados); benchmark IPCA+;
sensibilidade (rota + mapa de calor); composição do retorno; tabela mensal + CSV; `/como-calculamos`
com as rotas de histórico e sazonalidade; notebooks 01 e 02; `dados.md`, `arquitetura.md`,
`decisoes/`; CI.

---

## 12. Fora de escopo

Financiamento bancário do saldo; compra de imóvel pronto; parcelas intermediárias (balões); preço real
dos empreendimentos da ADR (são premissas editáveis); raspagem de portais (ZAP/OLX); tabela progressiva
completa do IR, redução da Lei 15.270/2025 e reforma tributária (IBS/CBS sobre locação); dado de
Airbnb por bairro; login, banco de dados, salvar simulações; deploy público (fase posterior).

---

## 13. Riscos e limitações

- **As premissas mandam no resultado**: ocupação, diária e valorização são estimativas, não dados da
  ADR. Cada campo mostra fonte e data.
- **Identidade da ADR sem aviso de protótipo** (D6): risco de alguém tomar o app como oficial.
  Mitigação: repo privado desde o primeiro commit e app só local. **Antes de qualquer deploy público,
  esta decisão volta para você.**
- **Fontes instáveis**: a API do Banco Central falha às vezes (o pipeline tenta de novo); o CSV da ANAC
  pode mudar de colunas (o teste de pipeline acusa). Os dados processados ficam no git, então o app
  nunca depende delas ao vivo.
- **Simplificações tributárias e de correção** (4.2 a 4.7), todas listadas em `docs/metodologia.md`.

---

## 14. Workspace e repositório

- `Vault_01/workspace-simulador-adr/` criado com
  `python "C:/Users/Administrator/Desktop/workspace-standard/workspace.py" new <caminho>`:
  `AGENTS.md`, `CLAUDE.md`, `current-state.md`, `session-log.md`, `decisions/`, `specs/`, `memory/`,
  `.agents/skills/` (com a impeccable copiada do chatbot), `secrets/`. Git local, sem remoto (como o do
  chatbot).
- `repo/` = clone de `github.com/cauedev30/simulador-adr`, **privado**, ignorado pelo git do workspace.
- Divisão: o **produto** (spec, metodologia, decisões técnicas) mora em `repo/docs/` — é portfólio. A
  **operação** (estado atual, decisões D6 e D7, log de sessões) mora no workspace.
- Limites no `AGENTS.md`: commit como `cauedev30 <cauefranco01@gmail.com>`, sem `Co-Authored-By`,
  com `cd "C:/..."`; perguntar antes de tornar o repo público ou fazer deploy; perguntar antes de
  escrever no vault fora do workspace.

---

## 15. Depois que você aprovar — só documentação, nenhum código

O que roda ao aprovar é **commitar e subir a documentação para o GitHub**. Nenhum código do projeto é
escrito nesta etapa.

1. Criar o workspace e o repo privado `cauedev30/simulador-adr`; clonar em `repo/`.
2. Salvar esta spec como `repo/docs/spec.md` e um `README.md` curto (o que é o projeto, status
   "em especificação", link para a spec); criar a spec de trabalho
   `specs/2026-10-13-simulador-v1.md` no workspace (intenção, critério de aceite, fora de escopo,
   apontando para a do repo); registrar D6 e D7 em `decisions/`.
3. Commit no repo (pt-BR, autor `cauedev30`, sem `Co-Authored-By`) e **push para o GitHub** (repo
   privado); conferir com `gh repo view` que está privado e que os arquivos subiram. Commit local no
   workspace.
4. `workspace.py check` → 0 erro.
5. Atualizar a memória da vaga com o endereço do workspace.
6. **Você lê `repo/docs/spec.md` uma última vez.** Com o seu ok, escrevo o **plano de implementação**
   (skill writing-plans), dividido nos dois marcos, que também passa pela sua revisão antes de qualquer
   código.

---

## 16. Autorrevisão desta spec (feita)

- **Pendências**: nenhuma seção em aberto. Duas conferências viram tarefa explícita da fase de dados:
  ITBI de João Pessoa (3% de imprensa → Código Tributário Municipal) e o valor final de cada
  "estimativa", que segue rotulada no app se não houver fonte melhor.
- **Coerência**: D4 (venda) aparece em 4.5, 4.6 e 4.7; D11 aparece em 5.3; os itens do Marco 2 batem
  entre as seções 7, 9, 10 e 11; a comparação com IPCA+ (4.7) depende do pipeline do Tesouro (5.1),
  ambos no Marco 2 — no Marco 1 a comparação é só com o CDI.
- **Escopo**: grande, mas é um produto só; os dois marcos dão um ponto apresentável no meio. Um plano de
  implementação com duas partes dá conta.
- **Ambiguidades resolvidas**: "diária" = o que o hóspede paga por noite (a taxa de 16% sai dela);
  payback **não** conta a venda; IR sobre aluguel é alíquota única informada; renda fixa líquida de 15%.
- **Ponto para sua atenção**: D11 é proposta minha (média de 10 anos como padrão). Se preferir usar o
  CDI atual, é uma troca de padrão, sem mudança no desenho.
