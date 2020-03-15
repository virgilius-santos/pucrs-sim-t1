import Foundation
import Simulation

func FilaSimples(
    taxaEntrada: Tempo,
    taxaSaida: Tempo,
    kendall: Kendall
) {
    
    let random = CongruenteLinear()
    
    let fila = Fila(
        taxaEntrada: taxaEntrada,
        taxaSaida: taxaSaida,
        kendall: kendall,
        random: random)
    
    let sut = FilaSimples(fila: fila, random: random)
    
    let estatisticas = sut.simular()
    sut.imprimir(estatisticas: estatisticas)
}

func FilaEncadeada(
    taxaEntradaFila1: Tempo,
    taxaSaidaFila1: Tempo,
    kendallFila1: Kendall,
    taxaEntradaFila2: Tempo,
    taxaSaidaFila2: Tempo,
    kendallFila2: Kendall
) {
    
    let random = CongruenteLinear()
    
    let filaDeEntrada = Fila(
        taxaEntrada: taxaEntradaFila1,
        taxaSaida: taxaSaidaFila1,
        kendall: kendallFila1,
        random: random)
    
    let filaDeSaida = Fila(
        taxaEntrada: taxaEntradaFila2,
        taxaSaida: taxaSaidaFila2,
        kendall: kendallFila2,
        random: random)
    
    let sut = FilaEncadeada(
        filaDeEntrada: filaDeEntrada,
        filaDeSaida: filaDeSaida,
        random: random)
    
    let estatisticas = sut.simular()
    sut.imprimir(estatisticas: estatisticas)
}
