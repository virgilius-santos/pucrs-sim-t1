
import Foundation

public struct Estatistica: CustomStringConvertible {
    
    let filaID: Int
    let quantDaFila: Int
    let perdas: Int
    let evento: Evento.Tipo
    let tempo: Double
    let contatores: [Int : Double]
    
    public var description: String {
        var str = String()
        str += "id: \(filaID.format())"
        str += "evt: \(evento.description.format(10))"
        str += "qtd: \(quantDaFila.format())"
        str += "perdas: \(perdas.format())"
        str += "t: \(tempo.format().format(7))"
        str += "conts: \(contatores.values.map({ ($0*100.0/tempo).format() }))\n*****"
        return str
    }
}

private extension Double {
    func format() -> String {
        return String(format: "%2.2f", self)
    }
}

private extension String {
    func format(_ lenght: Int = 5) -> String {
        return self.padding(toLength: lenght, withPad: " ", startingAt: 0)
    }
}

private extension Int {
    func format(_ lenght: Int = 5) -> String {
        return "\(self)".padding(toLength: lenght, withPad: " ", startingAt: 0)
    }
}
