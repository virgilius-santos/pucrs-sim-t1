import Foundation
import Simulation

func FilaSimples(
    valoresFixos: [Double] = [],
    taxaEntrada: Tempo,
    taxaSaida: Tempo,
    kendall: Kendall
) {
    
    let random = CongruenteLinear(maxIteracoes: kendall.n, valoresFixos: valoresFixos)

    let fila = Fila(
        taxaEntrada: taxaEntrada,
        taxaSaida: taxaSaida,
        kendall: kendall)

    let sut = SimuladorSimples(fila: fila, random: random)

    let estatisticas = sut.simular()
    sut.imprimir(estatisticas: estatisticas)
}

func FilaEncadeada(
    valoresFixos: [Double] = [],
    taxaEntradaFila1: Tempo,
    taxaSaidaFila1: Tempo,
    kendallFila1: Kendall,
    taxaEntradaFila2: Tempo,
    taxaSaidaFila2: Tempo,
    kendallFila2: Kendall
) {
    
    let random = CongruenteLinear(maxIteracoes: kendallFila1.n, valoresFixos: valoresFixos)

    let filaDeEntrada = Fila(
        taxaEntrada: taxaEntradaFila1,
        taxaSaida: taxaSaidaFila1,
        kendall: kendallFila1)

    let filaDeSaida = Fila(
        taxaEntrada: taxaEntradaFila2,
        taxaSaida: taxaSaidaFila2,
        kendall: kendallFila2)

    let sut = SimuladorEncadeado(
        filaDeEntrada: filaDeEntrada,
        filaDeSaida: filaDeSaida,
        random: random)

    let estatisticas = sut.simular()
    sut.imprimir(estatisticas: estatisticas)
}
