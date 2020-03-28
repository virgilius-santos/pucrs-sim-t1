
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
        
        let kendall = Kendall(c: 2, k: 4, n: 25)
        
        let random = CongruenteLinear(maxIteracoes: kendall.n)
        
        let fila = Fila(
            tipoDeFila: .simples,
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: kendall)
        
        let sut = SimuladorSimples(fila: fila, random: random)
        
        sut.simular()
        
        let estatisticas: [Estatistica] = fila.dados.estatisticas
        
        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }
        
        XCTAssertEqual(estatisticas.count, 23)
    }
    
    func testFilaEncadeada() {

        // para mudar as configurações do congruente,
        // altere os valores abaixo

        //        Config.CongruenteLinear.a
        //        Config.CongruenteLinear.c
        //        Config.CongruenteLinear.M
        //        Config.CongruenteLinear.semente

        let kendall = Kendall(c: 2, k: 4, n: 25)
        
        let random = CongruenteLinear(maxIteracoes: kendall.n)

        let filaDeEntrada = Fila(
            tipoDeFila: .tandem,
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: kendall)

        let filaDeSaida = Fila(
            tipoDeFila: .tandem,
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))

        let sut = SimuladorEncadeado(
            filaDeEntrada: filaDeEntrada,
            filaDeSaida: filaDeSaida,
            random: random)

        sut.simular()
        
        let estatisticas: [Estatistica] = filaDeEntrada.dados.estatisticas
            + filaDeSaida.dados.estatisticas

        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }
        
        XCTAssertEqual(estatisticas.count, 30)
    }
    
    func testFilaEncadeadaPonderada() {

        // para mudar as configurações do congruente,
        // altere os valores abaixo

        //        Config.CongruenteLinear.a
        //        Config.CongruenteLinear.c
        //        Config.CongruenteLinear.M
        //        Config.CongruenteLinear.semente

        let kendall = Kendall(c: 2, k: 4, n: 25)
        
        let random = CongruenteLinear(maxIteracoes: kendall.n)

        let filaDeEntrada = Fila(
            tipoDeFila: .tandem,
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: kendall)

        let filaDeSaida = Fila(
            tipoDeFila: .tandem,
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))

        let sut = SimuladorEncadeadoPonderado(
            filaDeEntrada: filaDeEntrada,
            filaDeSaida: filaDeSaida,
            random: random,
            taxaDeSaida: 0.8)

        sut.simular()
        
        let estatisticas: [Estatistica] = filaDeEntrada.dados.estatisticas
            + filaDeSaida.dados.estatisticas

        estatisticas.forEach { estatistica in
            XCTAssertEqual(estatistica.contatores.values.reduce(0, +), estatistica.tempo)
        }

        XCTAssertEqual(estatisticas.count, 26)
    }
}
