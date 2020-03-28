import Foundation
import Simulation

func FilaSimples(
    valoresFixos: [Double] = [],
    taxaEntrada: Tempo,
    taxaSaida: Tempo,
    kendall: Kendall
) -> [Fila] {
    
    let random = CongruenteLinear(maxIteracoes: kendall.n,
                                  valoresFixos: valoresFixos)

    let fila = Fila(
        id: 0,
        tipoDeFila: .simples,
        taxaEntrada: taxaEntrada,
        taxaSaida: taxaSaida,
        kendall: kendall)

    let sut = SimuladorSimples(fila: fila, random: random)

    let _ = sut.simular()
    return [fila]
}

func FilaEncadeada(
    valoresFixos: [Double] = [],
    taxaEntradaFila1: Tempo,
    taxaSaidaFila1: Tempo,
    kendallFila1: Kendall,
    taxaSaidaFila2: Tempo,
    kendallFila2: Kendall
) -> [Fila] {
    
    let random = CongruenteLinear(maxIteracoes: kendallFila1.n,
                                  valoresFixos: valoresFixos)

    let filaDeEntrada = Fila(
        id: 0,
        tipoDeFila: .tandem,
        taxaEntrada: taxaEntradaFila1,
        taxaSaida: taxaSaidaFila1,
        kendall: kendallFila1)

    let filaDeSaida = Fila(
        id: 1,
        tipoDeFila: .tandem,
        taxaSaida: taxaSaidaFila2,
        kendall: kendallFila2)

    let sut = SimuladorEncadeado(
        filaDeEntrada: filaDeEntrada,
        filaDeSaida: filaDeSaida,
        random: random)

    let _ = sut.simular()
    return [filaDeEntrada, filaDeSaida]
}
