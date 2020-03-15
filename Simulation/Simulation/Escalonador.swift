
import Foundation

public class Escalonador {
    
    typealias KeyValue = (tempo: Double, evento: Evento)
    
    private(set) var tempo: Double = 0
    
    private var fila: [KeyValue] = []
    
    public init() {}
    
    /// adiciona um evento ao escalonador
    func adicionar(_ evento: Evento) {
        fila.append((tempo + evento.tempo, evento))
        fila.sort(by: { $0.tempo > $1.tempo })
    }
    
    /// retorna o proximo evento que tem o tempo mais proximo
    func proximo() -> Evento? {
        if let ultimo = fila.popLast() {
            tempo = ultimo.tempo
            return ultimo.evento
        }
        return nil
    }
}
