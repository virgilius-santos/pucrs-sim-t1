
import Foundation

public struct Evento {
    enum Tipo: String, CustomStringConvertible {
        case chegada, saida, none, transicao
        var description: String { self.rawValue}
    }
    
    let tipo: Tipo
    let tempo: Double
    let acao: ActionTime
    let fila: Fila
}
