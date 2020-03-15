
import Foundation
import Simulation

// para mudar as configurações do congruente,
// altere os valores abaixo

//        Config.CongruenteLinear.a = 9
//        Config.CongruenteLinear.c = 9
//        Config.CongruenteLinear.M = 9
//        Config.CongruenteLinear.semente = 9

FilaSimples(
    taxaEntrada: Tempo(inicio: 1, fim: 2),
    taxaSaida: Tempo(inicio: 2, fim: 4),
    kendall: Kendall(
        a: "G",
        b: "G",
        c: 1,
        k: 10,
        n: 10,
        d: 10)
    )

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

