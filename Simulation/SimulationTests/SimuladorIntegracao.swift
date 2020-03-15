
import XCTest
@testable import Simulation

class SimuladorIntegracao: XCTestCase {
    
    func testFilaSimples() {
        
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
        
        let sut = FilaSimples(fila: fila, random: random)
        
        let estatisticas = sut.simular()
        
        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }
    }
    
    func testFilaEncadeada() {
        
        // para mudar as configurações do congruente,
        // altere os valores abaixo
        
        //        Config.CongruenteLinear.a
        //        Config.CongruenteLinear.c
        //        Config.CongruenteLinear.M
        //        Config.CongruenteLinear.semente
        
        let random = CongruenteLinear()
        
        let filaDeEntrada = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 4),
            random: random)
        
        let filaDeSaida = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0),
            random: random)
        
        let sut = FilaEncadeada(
            filaDeEntrada: filaDeEntrada,
            filaDeSaida: filaDeSaida,
            random: random)
                
        let estatisticas = sut.simular()
        
        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }
    }
    
    func testFilaEncadeadaPonderada() {
        
        // para mudar as configurações do congruente,
        // altere os valores abaixo
        
        //        Config.CongruenteLinear.a
        //        Config.CongruenteLinear.c
        //        Config.CongruenteLinear.M
        //        Config.CongruenteLinear.semente
        
        let random = CongruenteLinear()
        
        let filaDeEntrada = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 4),
            random: random)
        
        let filaDeSaida = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0),
            random: random)
        
        let sut = FilaEncadeadaPonderada(
            filaDeEntrada: filaDeEntrada,
            filaDeSaida: filaDeSaida,
            random: random,
            taxaDeSaida: 0.8)
        
        let estatisticas = sut.simular()
        
        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }
    }
}
