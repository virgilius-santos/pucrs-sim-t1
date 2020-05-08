
import Foundation

class Queue {
    let n: String
    let c: Int
    let k: Int
    let taxaEntrada: (inicio: Double, fim: Double)
    let taxaSaida: (inicio: Double, fim: Double)
    
    var qtdDaFila: Int = .zero
    var contador: [Double] = []
    var perdas: Int = .zero
    
    var contabilizarTempo: ActionVoid?
    
    var funcaoDeTransicao: ((Queue) -> Void)?
    
    var funcaoDeAgendamento: Agendamento? {
        didSet {
            if
                taxaEntrada.fim - taxaEntrada.inicio > 0,
                let r = rnd(taxaEntrada.inicio, taxaEntrada.fim), r > 0 {
                funcaoDeAgendamento?(chegadaNaFila, r, .chegada)
            }
        }
    }
    
    init(
        n: String,
        c: Int,
        k: Int,
        taxaEntrada: (inicio: Double, fim: Double),
        taxaSaida: (inicio: Double, fim: Double)
    ) {
        self.n = n
        self.c = c
        self.k = k
        self.taxaEntrada = taxaEntrada
        self.taxaSaida = taxaSaida
    }
    
    // MARK: Função saidas das filas
    
    func saidaDaFila() {
        qtdDaFila -= 1
        if qtdDaFila >= c { funcaoDeTransicao?(self) }
    }
    
    // MARK: Função de entradas das filas
    
    func entradaNaFila() {
        if qtdDaFila < k {
            qtdDaFila += 1
            if qtdDaFila <= c { funcaoDeTransicao?(self) }
        }
        else {
            perdas += 1
        }
    }
    
    func chegadaNaFila() {
        contabilizarTempo?()
        entradaNaFila()
        if
            taxaEntrada.fim - taxaEntrada.inicio > 0,
            let r = rnd(taxaEntrada.inicio, taxaEntrada.fim)
        {
            funcaoDeAgendamento?(chegadaNaFila, r, .chegada)
        }
    }
    
    func evento(_ fila: Queue? = nil) -> ActionVoid {
        return { [saidaDaFila, contabilizarTempo] in
            contabilizarTempo?()
            saidaDaFila()
            fila?.entradaNaFila()
        }
    }
}
