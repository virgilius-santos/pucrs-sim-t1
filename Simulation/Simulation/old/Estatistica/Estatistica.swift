
import Foundation

public class Estatistica {
    var filaID: Int
    var quantDaFila: Int
    var perdas: Int
    var evento: Evento.Tipo
    var tempo: Double
    var contatores: [Int: Double]

    init(
        filaID: Int,
        quantDaFila: Int,
        perdas: Int,
        evento: Evento.Tipo,
        tempo: Double,
        contatores: [Int: Double]
    ) {
        self.filaID = filaID
        self.quantDaFila = quantDaFila
        self.perdas = perdas
        self.evento = evento
        self.tempo = tempo
        self.contatores = contatores
    }
}
