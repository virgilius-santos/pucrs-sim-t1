
import Foundation
import Simulation

enum Simuladores {
    case simples, encadeado
    case simples1
}

// para mudar as configurações do congruente,
// altere os valores abaixo

//        Config.CongruenteLinear.a = 9
//        Config.CongruenteLinear.c = 9
//        Config.CongruenteLinear.M = 9
//        Config.CongruenteLinear.semente = 9

let tipoSimulador = Simuladores.simples
print("simulador escolhido: ", tipoSimulador)
switch tipoSimulador {
    case .simples1:
        FilaSimples(
            valoresFixos: [
                0.5,
                0.9921,
                0.0004,
                0.5534,
                0.2761,
                0.3398,
                0.8963,
                0.9023,
                0.0132,
                0.4569,
                0.5121,
                0.9208,
                0.0171,
                0.2299,
                0.8545,
                0.6001,
                0.2921
            ],
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 3, fim: 6),
            kendall: Kendall(
                a: "G",
                b: "G",
                c: 1,
                k: 3,
                n: 8,
                d: 10))
    case .simples:
        FilaSimples(
            valoresFixos: [1, 0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881],
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 3, fim: 6),
            kendall: Kendall(
                a: "G",
                b: "G",
                c: 1,
                k: 3,
                n: 8,
                d: 10))
    
    case .encadeado:
        FilaEncadeada(
            valoresFixos: [
                0.5,
                0.9921,
                0.0004,
                0.5534,
                0.2761,
                0.3398,
                0.8963,
                0.9023,
                0.0132,
                0.4569,
                0.5121,
                0.9208,
                0.0171,
                0.2299,
                0.8545,
                0.6001,
                0.2921
            ],
            taxaEntradaFila1: Tempo(inicio: 2, fim: 3),
            taxaSaidaFila1: Tempo(inicio: 2, fim: 5),
            kendallFila1: Kendall(
                a: "G",
                b: "G",
                c: 2,
                k: 3,
                n: 17,
                d: 0),
            taxaEntradaFila2: Tempo(inicio: 1, fim: 3),
            taxaSaidaFila2: Tempo(inicio: 3, fim: 5),
            kendallFila2: Kendall(
                a: "G",
                b: "G",
                c: 1,
                k: 3,
                n: 0,
                d: 0)
    )
}
