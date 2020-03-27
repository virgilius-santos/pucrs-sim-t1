
import Foundation

public struct Estatistica: CustomStringConvertible {
    
    let filaID: Int
    let quantDaFila: Int
    let perdas: Int
    let evento: Evento.Tipo
    let tempo: Double
    let contatores: [Int : Double]
    
    public var description: String {
        let conts: [(String, String)] = contatores
            .lazy
            .sorted(by: { $0.key < $1.key })
            .map { ($0.value, ($0.value / tempo) * 100.0) }
            .map { ($0.0.format(4), $0.1.format()) }
        
        var str = String()
        str += "id: \(filaID.format())"
        str += "evt: \(evento.description.format(10))"
        str += "qtd: \(quantDaFila.format())"
        str += "perdas: \(perdas.format())"
        str += "t: \(tempo.format(4).format(12))"
        str += "conts: \(conts)\n*****"
        return str
    }
}

private extension Double {
    func format(_ n: Int = 2) -> String {
        return String(format: "%2.\(n)f", self)
    }
}

private extension String {
    func format(_ lenght: Int = 5) -> String {
        return self.padding(toLength: lenght, withPad: " ", startingAt: 0)
    }
}

private extension Int {
    func format(_ lenght: Int = 7) -> String {
        return "\(self)".padding(toLength: lenght, withPad: " ", startingAt: 0)
    }
}
