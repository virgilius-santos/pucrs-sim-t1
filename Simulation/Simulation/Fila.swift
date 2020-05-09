
import Foundation

public class Fila {
    let nome: String
    let c: Int
    let k: Int
    let taxaEntrada: (inicio: Double, fim: Double)
    let taxaSaida: (inicio: Double, fim: Double)
    let transicoes: [(nomeDaFila: String, taxa: Double)]

    let semRoteamento: Bool

    var qtdDaFila: Int = .zero
    var contador: [Double] = []
    var perdas: Int = .zero

    var contabilizarTempo: ActionVoid?

    var filaDataSource: ((String) -> Fila?)?

    var randomDataSource: ((_ inicio: Double, _ fim: Double) -> Double?)?

    var agendarEvento: Agendamento? {
        didSet {
            agendarChegadaAutomatica()
        }
    }

    public init(
        nome: String,
        c: Int,
        k: Int = .max,
        taxaEntrada: (inicio: Double, fim: Double) = (.zero, .zero),
        taxaSaida: (inicio: Double, fim: Double),
        transicoes: [(nomeDaFila: String, taxa: Double)] = []
    ) {
        self.nome = nome
        self.c = c
        self.k = k
        self.taxaEntrada = taxaEntrada
        self.taxaSaida = taxaSaida
        self.transicoes = transicoes
        semRoteamento = transicoes.isEmpty
            || (transicoes.count == 1 && transicoes[0].taxa == 1)
    }

    // MARK: Função saidas das filas

    func saidaDaFila() {
        qtdDaFila -= 1
        if qtdDaFila >= c { transicaoEntreFilas() }
    }

    // MARK: Função de entradas das filas

    func entradaNaFila() {
        if qtdDaFila < k {
            qtdDaFila += 1
            if qtdDaFila <= c { transicaoEntreFilas() }
        } else {
            perdas += 1
        }
    }

    // MARK: Função de chegada nas filas

    func agendarChegadaAutomatica() {
        if
            taxaEntrada.fim - taxaEntrada.inicio > 0,
            let r = randomDataSource?(taxaEntrada.inicio, taxaEntrada.fim) {
            agendarEvento?(transicaoDeChegadaAutomatica, r, .chegada)
        }
    }

    // MARK: Função de transição

    func transicaoDeChegadaAutomatica() {
        contabilizarTempo?()
        entradaNaFila()
        agendarChegadaAutomatica()
    }

    func transicaoEntreFilas() {
        if
            let r1 = semRoteamento ? 1 : randomDataSource?(0, 1),
            let r2 = randomDataSource?(taxaSaida.inicio, taxaSaida.fim) {
            let evt: ActionVoid

            var aux: Double = 0
            for t in transicoes {
                if r1 <= t.taxa + aux {
                    evt = evento(filaDataSource?(t.nomeDaFila))
                    agendarEvento?(evt, r2, .transicao)
                    return
                } else {
                    aux += t.taxa
                }
            }
            evt = evento()
            agendarEvento?(evt, r2, .saida)
        }
    }

    // MARK: Função para gerar evento

    func evento(_ filaDeDestino: Fila? = nil) -> ActionVoid {
        return { [saidaDaFila, contabilizarTempo] in
            contabilizarTempo?()
            saidaDaFila()
            filaDeDestino?.entradaNaFila()
        }
    }

    func atualizarContador(delta: Double) {
        if qtdDaFila < contador.count {
            contador[qtdDaFila] += delta
        } else {
            contador.append(delta)
        }
    }
}
