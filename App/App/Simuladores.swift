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

func FilaRede() -> [Fila] {
    
    let kendallFila1 = Kendall(c: 1, n: 100000)
    
    let random = CongruenteLinear(maxIteracoes: kendallFila1.n,
                                  valoresFixos: [2.0/3])
    
    let fila1 = Fila(
        id: 0,
        tipoDeFila: .rede,
        taxaEntrada: Tempo(inicio: 1, fim: 4),
        taxaSaida: Tempo(inicio: 1, fim: 1.5),
        kendall: kendallFila1)
    
    let fila2 = Fila(
        id: 1,
        tipoDeFila: .rede,
        taxaSaida: Tempo(inicio: 5, fim: 10),
        kendall: Kendall(c: 3, k: 5))
    
    let fila3 = Fila(
        id: 2,
        tipoDeFila: .rede,
        taxaSaida: Tempo(inicio: 2, fim: 8),
        kendall: Kendall(c: 10, k: 20))
    
    let sut = Simulador(
        configDeEventos: [
            
            .chegada(fila: fila1),
            
            .transicaoRede(origem: fila1,
                           destinos: [(fila2, 0.8), (fila3, 0.2)]),
            
            .transicaoRede(origem: fila2,
                           destinos: [(fila1, 0.3), (fila3, 0.5)]),
            
            .transicaoRede(origem: fila3,
                           destinos: [(fila2, 0.7)]),
            
        ],
        random: random)
    
    let _ = sut.simular()
    return [fila1, fila2, fila3]
}
