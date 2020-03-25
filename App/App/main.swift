
import Foundation
import Simulation

enum Simuladores {
    case simples, encadeado
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
                d: 10)
    )
    
    case .encadeado:
        FilaEncadeada(
            taxaEntradaFila1: Tempo(inicio: 1, fim: 2),
            taxaSaidaFila1: Tempo(inicio: 2, fim: 4),
            kendallFila1: Kendall(
                a: "G",
                b: "G",
                c: 2,
                k: 4,
                n: 4,
                d: 0),
            taxaEntradaFila2: Tempo(inicio: 1, fim: 2),
            taxaSaidaFila2: Tempo(inicio: 2, fim: 4),
            kendallFila2: Kendall(
                a: "G",
                b: "G",
                c: 2,
                k: 4,
                n: 0,
                d: 0)
    )
}
