
import XCTest
@testable import Simulation

class FilaTests: XCTestCase {

    var sut: Fila!
    
    func testChegada_QtdFila_aoIniciar_deveSerZero() {
        
        // given: dado que foi inicializado
        sut = .init()
        
        // then: o tamanho deve estar zerado
        XCTAssertEqual(sut.quantDaFila, 0)
        
        // then: a perda deve estar zerada
        XCTAssertEqual(sut.perdas, 0)
    }
    
    func test_Fila_processamentoDeChegada() {
        let dadosSpy = GerenciadorEstatisticasSpy(id: 0)
        
        // given: dado que foi inicializado
        sut = .init(kendall: Kendall(c: 1, k: 2), dados: dadosSpy)
        
        let exp = expectation(description: "agendarSaida")

        sut.agendarSaida = {
            exp.fulfill()
        }
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: 13)
        sut.chegada(tempo: 17)
        sut.chegada(tempo: 19)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o numero de registros deve ser 3
        XCTAssertEqual(dadosSpy.evtSpy.count, 3)
        
        // then: todas chegadas
        XCTAssertEqual(dadosSpy.evtSpy[0], .chegada)
        XCTAssertEqual(dadosSpy.evtSpy[1], .chegada)
        XCTAssertEqual(dadosSpy.evtSpy[2], .chegada)
        
        // then: a quantAnteriorDaFila deve ser atualizado
        XCTAssertEqual(dadosSpy.quantAnteriorDaFilaSpy[0], 0)
        XCTAssertEqual(dadosSpy.quantAnteriorDaFilaSpy[1], 1)
        XCTAssertEqual(dadosSpy.quantAnteriorDaFilaSpy[2], 2)
        
        // then: a quantDaFilaSpy deve ser atualizado
        XCTAssertEqual(dadosSpy.quantDaFilaSpy[0], 1)
        XCTAssertEqual(dadosSpy.quantDaFilaSpy[1], 2)
        
        // then: a quantDaFilaSpy não deve ser atualizado qdo ocorre uma perda
        XCTAssertEqual(dadosSpy.quantDaFilaSpy[2], 2)
        
        // then: a perda deve ser informada
        XCTAssertEqual(dadosSpy.perdasSpy[0], 0)
        XCTAssertEqual(dadosSpy.perdasSpy[1], 0)
        XCTAssertEqual(dadosSpy.perdasSpy[2], 1)
        
        // then: o tempo deve ser informado
        XCTAssertEqual(dadosSpy.tempoSpy[0], 13)
        XCTAssertEqual(dadosSpy.tempoSpy[1], 17)
        XCTAssertEqual(dadosSpy.tempoSpy[2], 19)
    }
    
    func test_Fila_processamentoDeSaida() {
        let dadosSpy = GerenciadorEstatisticasSpy(id: 0)
        
        // given: dado que foi inicializado
        sut = .init(kendall: Kendall(c: 1, k: 2), dados: dadosSpy)
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: 13)
        sut.chegada(tempo: 17)
        
        let exp = expectation(description: "agendarSaida")

        sut.agendarSaida = {
            exp.fulfill()
        }
        
        sut.saida(tempo: 2)
        sut.saida(tempo: 3)
        sut.saida(tempo: 5)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o numero de registros deve ser 4
        XCTAssertEqual(dadosSpy.evtSpy.count, 4)
        
        // then: as saidas devem ser registradas
        XCTAssertEqual(dadosSpy.evtSpy[2], .saida)
        XCTAssertEqual(dadosSpy.evtSpy[3], .saida)
        
        // then: a quantAnteriorDaFila deve ser atualizado
        XCTAssertEqual(dadosSpy.quantAnteriorDaFilaSpy[2], 2)
        XCTAssertEqual(dadosSpy.quantAnteriorDaFilaSpy[3], 1)
        
        // then: a quantDaFilaSpy deve ser atualizado
        XCTAssertEqual(dadosSpy.quantDaFilaSpy[2], 1)
        XCTAssertEqual(dadosSpy.quantDaFilaSpy[3], 0)
        
        // then: o tempo deve ser informado
        XCTAssertEqual(dadosSpy.tempoSpy[2], 2)
        XCTAssertEqual(dadosSpy.tempoSpy[3], 3)
    }
    
    func test_Fila_AgendarSaida_naoDeveSerChamada_comFilaVazia() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2))
        
        let exp = expectation(description: "agendarSaida")
        exp.isInverted = true
        
        var tempoDeSaida: Bool?
        
        sut.agendarSaida = {
            tempoDeSaida = true
            exp.fulfill()
        }
        
        // when: uma chegada eh registrada
        sut.saida(tempo: .zero)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o tempo de saida deve ser passao
        XCTAssertNil(tempoDeSaida)
    }
    
    func test_Fila_calculo() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6))
        
        // when: a saida eh chamada com a fila vazia
        let chegada = sut.proximaChegada(randomUniformizado: 0.5)
        
        // then: o tamanho deve estar zerado
        XCTAssertEqual(chegada, 1.5)
        
        // when: a saida eh chamada com a fila vazia
        let saida = sut.proximaSaida(randomUniformizado: 0.5)
        
        // then: o tamanho deve estar zerado
        XCTAssertEqual(saida, 4.5)
    }
    
    class GerenciadorEstatisticasSpy: GerenciadorEstatisticas {
        var evtSpy: [Evento.Tipo] = []
        var tempoSpy: [Double] = []
        var quantAnteriorDaFilaSpy: [Int] = []
        var quantDaFilaSpy: [Int] = []
        var perdasSpy: [Int] = []
               
        override func updateEstatisticas(evt: Evento.Tipo,
                                         tempo: Double,
                                         quantAnteriorDaFila: Int,
                                         quantDaFila: Int,
                                         perdas: Int) {
            evtSpy.append( evt)
            tempoSpy.append( tempo)
            quantAnteriorDaFilaSpy.append( quantAnteriorDaFila)
            quantDaFilaSpy.append( quantDaFila)
            perdasSpy.append( perdas)
        }
    }
}
