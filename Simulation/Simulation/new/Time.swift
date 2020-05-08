
import Foundation

// MARK: - Tempo

// tempo de processamento
var T: Double = .zero

// contabiliza os tempos
func contabiliza() {
    
    func update(fila: Queue, delta: Double) {
        if fila.f < fila.contador.count {
            fila.contador[fila.f] += delta
        }
        else {
            fila.contador.append(delta)
        }
    }
    
    let delta: Double = emProcessamento.t - T
    
    qs.forEach { update(fila: $0, delta: delta) }
    
    T += delta
    
    qs.forEach {
        if T != $0.contador.reduce(0, +) {
            fatalError("time wrong")
        }
    }
}
