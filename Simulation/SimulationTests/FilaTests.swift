
import XCTest
@testable import Simulation

class FilaTests: XCTestCase {

    var sut: Fila!
    
    func testChegada_QtdFila_aoIniciar_deveSerZero() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2),
                    random: CongruenteLinear())
        
        // then: o tamanho deve estar zerado
        XCTAssertEqual(sut.quantDaFila, 0)
        
        // then: a perda deve estar zerada
        XCTAssertEqual(sut.perdas, 0)
    }
    
    func testChegada_QtdFila_aposChegada_deveSerAtualizada() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2),
                    random: CongruenteLinear())
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: o tamanho deve ser atualizado
        XCTAssertEqual(sut.quantDaFila, 1)
        
        // when: uma nova chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: o tamanho deve ser atualizado
        XCTAssertEqual(sut.quantDaFila, 2)
    }
    
    func testChegada_Perdas_aposChegada_deveSerAtualizada() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 1),
                    random: CongruenteLinear())
        
        // then: a perda deve estar zerada
        XCTAssertEqual(sut.perdas, 0)
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: a perda deve estar zerada
        XCTAssertEqual(sut.perdas, 0)
        
        // when: uma nova chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: a perda deve estar ser atualizada
        XCTAssertEqual(sut.perdas, 1)
    }
    
    func testAgendarSaida_deveSerChamada_comServidoresLivres() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2),
                    random: CongruenteLinear())
        
        var exp = expectation(description: "agendarSaida")
        var tempoDeSaida: Bool?
        
        sut.agendarSaida = {
            tempoDeSaida = true
            exp.fulfill()
        }
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o tempo de saida deve ser passao
        XCTAssertEqual(tempoDeSaida, true)
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: .zero)
        
        exp = expectation(description: "agendarSaida")
        tempoDeSaida = nil
        
        sut.agendarSaida = {
            tempoDeSaida = true
            exp.fulfill()
        }
        
        // when: uma saida eh solicitada
        sut.saida(tempo: .zero)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o tempo de saida deve ser passao
        XCTAssertEqual(tempoDeSaida, true)
    }
    
    func testAgendarSaida_naoDeveSerChamada_comServidoresCheio() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2),
                    random: CongruenteLinear())
        
        sut.chegada(tempo: .zero)
        
        let exp = expectation(description: "agendarSaida")
        exp.isInverted = true
        
        var tempoDeSaida: Bool?
        
        sut.agendarSaida = {
            tempoDeSaida = true
            exp.fulfill()
        }
        
        // when: uma chegada eh registrada
        sut.chegada(tempo: .zero)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o tempo de saida deve ser passao
        XCTAssertNil(tempoDeSaida)
    }
    
    func testAgendarSaida_naoDeveSerChamada_comFilaVazia() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1, k: 2),
                    random: CongruenteLinear())
        
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
    
    func testSaida() {
        
        // given: dado que foi inicializado
        sut = .init(taxaEntrada: Tempo(inicio: 1, fim: 2),
                    taxaSaida: Tempo(inicio: 3, fim: 6),
                    kendall: Kendall(c: 1),
                    random: CongruenteLinear())
        
        // when: a saida eh chamada com a fila vazia
        sut.saida(tempo: .zero)
        
        // then: o tamanho deve estar zerado
        XCTAssertEqual(sut.quantDaFila, 0)
        
        // then: a perda deve estar zerada
        XCTAssertEqual(sut.perdas, 0)
        
        // when: duas chegadas são registrada
        sut.chegada(tempo: .zero)
        sut.chegada(tempo: .zero)
        
        // when: uma saida eh solicitada
        
        let exp = expectation(description: "agendarSaida")
        var tempoDeSaida: Bool?
        
        sut.agendarSaida = {
            tempoDeSaida = true
            exp.fulfill()
        }
        
        sut.saida(tempo: .zero)
        
        // then: o agendamento deve ser chamado
        waitForExpectations(timeout: 2, handler: nil)
        
        // then: o tamanho deve ser atualizado
        XCTAssertEqual(sut.quantDaFila, 1)
        
        // then: o tempo de saida deve ser passao
        XCTAssertEqual(tempoDeSaida, true)
    }
}
