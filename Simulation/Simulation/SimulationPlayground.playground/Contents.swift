import UIKit
import Simulation

var str = "Hello, playground"

func testSimuladorSimples() {
    
    // para mudar as configurações do congruente,
    // altere os valores abaixo
    
    //        Config.CongruenteLinear.a
    //        Config.CongruenteLinear.c
    //        Config.CongruenteLinear.M
    //        Config.CongruenteLinear.semente
    
    let random = CongruenteLinear()
    
    let fila = Fila(
        taxaEntrada: Tempo(inicio: 1, fim: 2),
        taxaSaida: Tempo(inicio: 2, fim: 4),
        kendall: Kendall(c: 2, k: 4, n: 25),
        random: random)
    
    let sut = SimuladorSimples(fila: fila, random: random)
    
    let estatisticas = sut.simular()
}

//func testSimuladorFilaEncadeada() {
//
//    // para mudar as configurações do congruente,
//    // altere os valores abaixo
//
//    //        Config.CongruenteLinear.a
//    //        Config.CongruenteLinear.c
//    //        Config.CongruenteLinear.M
//    //        Config.CongruenteLinear.semente
//
//    let random = CongruenteLinear()
//
//    let filaDeEntrada = Fila(
//        taxaEntrada: Tempo(inicio: 1, fim: 2),
//        taxaSaida: Tempo(inicio: 2, fim: 4),
//        kendall: Kendall(c: 2, k: 4, n: 4),
//        random: random)
//
//    let filaDeSaida = Fila(
//        taxaEntrada: Tempo(inicio: 1, fim: 2),
//        taxaSaida: Tempo(inicio: 2, fim: 4),
//        kendall: Kendall(c: 2, k: 4, n: 0),
//        random: random)
//
//    let sut = SimuladorFilaEncadeada(
//        filaDeEntrada: filaDeEntrada,
//        filaDeSaida: filaDeSaida,
//        random: random)
//
//    let estatisticas = sut.simular()
//
//    estatisticas.forEach { estatistica in
//        XCTAssertEqual(estatistica.contatores.reduce(0, +), estatistica.tempo)
//    }
//}

testSimuladorSimples()
