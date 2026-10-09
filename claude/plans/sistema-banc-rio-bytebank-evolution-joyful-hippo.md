# Sistema Bancário ByteBank Evolution (Kotlin)

## Context

Exercício de faculdade de Programação Orientada a Objetos em Kotlin. O enunciado pede um sistema
bancário que crie contas, faça depósitos, saques, transferências, aplique taxa e rendimento, e
guarde um histórico de operações. Tudo direto na `main()`, sem entrada pelo teclado.

O pedido explícito foi: **o mais simples possível, é cadeira de iniciante**. Então o critério de
sucesso aqui não é código elegante de produção, é código que um aluno iniciante escreveria e
conseguiria explicar na frente do professor, cobrindo os conceitos de OO que o enunciado cobra.

Não existe nada de Kotlin na máquina hoje (nenhum `.kt`, sem `kotlinc`, sem Java, sem IntelliJ).
É projeto do zero.

## Decisões já tomadas

- Arquivo único em `C:\Users\Administrator\Downloads\bytebank\Main.kt`.
- Classes, subclasses e `main()` todos no mesmo arquivo.
- Sem comentário de IA, sem cabeçalho gerado, sem `Co-Authored-By`. Código de aluno.

## Estrutura do código

Uma classe-mãe e duas filhas. Só isso, nada de interface ou classe abstrata.

### `open class ContaBancaria(val titular: String, val numero: Int, var saldo: Double)`

O que é comum a toda conta fica aqui, para não repetir código:

- `val historico = mutableListOf<String>()` — a lista de operações.
- `fun depositar(valor: Double)` — recusa valor zero ou negativo com mensagem de erro, senão soma
  no saldo, registra no histórico e imprime sucesso.
- `open fun sacar(valor: Double)` — recusa valor inválido ou maior que o saldo, imprimindo
  "Saldo insuficiente para realizar esta operação!". É o que garante que o saldo nunca fica
  negativo.
- `fun transferir(destino: ContaBancaria, valor: Double)` — checa o saldo, tira daqui, soma no
  destino, e registra nos dois históricos ("enviada" de um lado, "recebida" do outro).
- `open fun exibirDados()` — imprime titular, número e saldo.
- `fun exibirHistorico()` — imprime o cabeçalho e percorre a lista com um `for`.

### `class ContaCorrente(...) : ContaBancaria(...)`

- `override fun exibirDados()` — chama `super.exibirDados()` e acrescenta a linha "Tipo: Conta
  Corrente".
- `fun aplicarTaxaMensal()` — desconta uma taxa fixa (R$ 30,00), só se houver saldo suficiente,
  e registra no histórico. É o comportamento exclusivo dessa conta.

### `class ContaPoupanca(...) : ContaBancaria(...)`

- `override fun exibirDados()` — mesma ideia, "Tipo: Conta Poupança".
- `fun aplicarRendimento()` — soma 0,5% do saldo e registra no histórico. Comportamento
  exclusivo dessa conta.

A diferença entre as duas contas aparece de duas formas, que é o que o professor vai procurar:
método sobrescrito (`exibirDados`) e método próprio de cada filha (taxa contra rendimento).

### `fun main()`

Roteiro que demonstra tudo, na ordem do exemplo do enunciado:

1. Cabeçalho "BANCO BYTEBANK EVOLUTION".
2. Cria uma `ContaCorrente` (Maria Silva, 1001, 2500.0) e uma `ContaPoupanca` (João Souza, 1002).
3. Depósito válido, depósito inválido (valor negativo, para mostrar a regra barrando).
4. Saque válido e saque maior que o saldo, para imprimir "Saldo insuficiente".
5. `aplicarTaxaMensal()` na corrente e `aplicarRendimento()` na poupança, mostrando o novo saldo.
6. Transferência da corrente para a poupança.
7. `exibirDados()` das duas contas, mostrando o polimorfismo.
8. `exibirHistorico()` das duas contas no final.

## Como verificar

Não dá para rodar nesta máquina: não há compilador Kotlin, nem Java, nem IntelliJ instalados.
Duas opções, ambas no seu lado:

- Abrir o arquivo no IntelliJ da faculdade e rodar a `main()`.
- Colar o conteúdo em https://play.kotlinlang.org e apertar Run, que é o teste mais rápido.

Antes de entregar, confira que a saída bate com o esperado: aparece uma mensagem de recusa no
depósito inválido, uma no saque acima do saldo, nenhum saldo fica negativo, e o histórico no
final lista as operações das duas contas.

Se quiser, depois de rodar você me manda a saída ou o erro do compilador e eu ajusto.
