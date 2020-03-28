
import Foundation

public struct Estatistica {
    let filaID: Int
    let quantDaFila: Int
    let perdas: Int
    let evento: Evento.Tipo
    let tempo: Double
    let contatores: [Int : Double]
}
