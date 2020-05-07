
import Foundation
import Simulation

enum Simuladores {
    case simples, tendam, rede
}

func exec(_ tipoSimulador: Simuladores) -> [Fila] {
    switch tipoSimulador {
        case .tendam:
            return FilaEncadeada(
                valoresFixos: [0.5],
                taxaEntradaFila1: Tempo(inicio: 2, fim: 3),
                taxaSaidaFila1: Tempo(inicio: 2, fim: 5),
                kendallFila1: Kendall(c: 2, k: 3, n: 100000),
                taxaSaidaFila2: Tempo(inicio: 3, fim: 5),
                kendallFila2: Kendall(c: 1, k: 3, n: 100000))

//        case .simples1:
//            return FilaSimples(
//                valoresFixos: [0.5],
//                taxaEntrada: Tempo(inicio: 2, fim: 4),
//                taxaSaida: Tempo(inicio: 3, fim: 5),
//                kendall: Kendall(
//                    a: "G",
//                    b: "G",
//                    c: 1,
//                    k: 5,
//                    n: 100000,
//                    d: 10))
//
//        case .simples2:
//            return FilaSimples(
//                valoresFixos: [0.5],
//                taxaEntrada: Tempo(inicio: 2, fim: 4),
//                taxaSaida: Tempo(inicio: 3, fim: 5),
//                kendall: Kendall(
//                    a: "G",
//                    b: "G",
//                    c: 2,
//                    k: 5,
//                    n: 100000,
//                    d: 10))

        case .simples:
            return FilaSimples(
                valoresFixos: [1, ],//0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881],
                taxaEntrada: Tempo(inicio: 1, fim: 2),
                taxaSaida: Tempo(inicio: 3, fim: 6),
                kendall: Kendall(
                    a: "G",
                    b: "G",
                    c: 1,
                    k: 3,
                    n: 100000,
                    d: 10))
        
        case .rede:
            return FilaRede()
    }
}

// para mudar as configurações do congruente,
// altere os valores abaixo

//        Config.CongruenteLinear.a = 9
//        Config.CongruenteLinear.c = 9
//        Config.CongruenteLinear.M = 9
//        Config.CongruenteLinear.semente = 9

var sementes: [UInt] = [29, 86, 46, 53, 42]
var filas: [Fila]

//filas = [Fila]()
//for i in 0 ..< 5 {
//    Config.CongruenteLinear.semente = sementes[i]
//    filas += exec(.simples)
//}
//filas.imprimir()
//
//filas = [Fila]()
//for i in 0 ..< 1 {
//    Config.CongruenteLinear.semente = sementes[i]
//    filas += exec(.simples1)
//}
//filas.imprimir()
//
//filas = [Fila]()
//for i in 0 ..< 1 {
//    Config.CongruenteLinear.semente = sementes[i]
//    filas += exec(.simples2)
//}
//filas.imprimir()

filas = [Fila]()
for i in 0 ..< sementes.count {
    Config.CongruenteLinear.semente = sementes[i]
    filas += exec(.rede)
}
filas.imprimir()
