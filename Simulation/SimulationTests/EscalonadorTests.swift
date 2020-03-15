
import XCTest
@testable import Simulation

class EscalonadorTests: XCTestCase {

    var sut: Escalonador!
    
    let fila = Fila(
        taxaEntrada: Tempo(inicio: 1, fim: 2),
        taxaSaida: Tempo(inicio: 2, fim: 4),
        kendall: Kendall(c: 2, k: 4, n: 25),
        random: .init())
    
    func testQueue() {
        // given: inicializado
        sut = .init()
        
        // when: um evento for consutado
        let evento = sut.proximo()
        
        // then: nao deve retornar eventos
        XCTAssertNil(evento)
        
        // when: o tempo for consutado
        let tempo = sut.tempo
        
        // then: o tempo deve estar zerado
        XCTAssertEqual(tempo, 0)
    }
    
    func testAddQueue() {
        // given: inicializado
        sut = .init()
        
        // when: um evento for adcionado
        let evento = Evento(tipo: .none, tempo: 3, acao: {_ in}, fila: fila)
        sut.adicionar(evento)
        
        // then: o tempo nao deve ser atualizado
        XCTAssertEqual(sut.tempo, 0)
        
        // then: deve retornar um evento
        XCTAssertNotNil(sut.proximo())
        
        // then: o tempo deve ser atualizado
        XCTAssertEqual(sut.tempo, 3)
        
        // when: um evento for adcionado
        let evt0 = Evento(tipo: .none, tempo: 5, acao: {_ in}, fila: fila)
        sut.adicionar(evt0)
        let evt1 = Evento(tipo: .none, tempo: 2, acao: {_ in}, fila: fila)
        sut.adicionar(evt1)
        
        // then: deve retornar um evento
        XCTAssertNotNil(sut.proximo())
        
        // then: o tempo deve ser atualizado
        XCTAssertEqual(sut.tempo, 5)
        
        // then: deve retornar um evento
        XCTAssertNotNil(sut.proximo())
        
        // then: o tempo deve ser atualizado
        XCTAssertEqual(sut.tempo, 8)
    }
    
    func testOrderedAddQueue() {
        // given: inicializado
        sut = .init()

        // when: um evento for adcionado
        let evt0 = Evento(tipo: .none, tempo: 5, acao: {_ in}, fila: fila)
        sut.adicionar(evt0)
        let evt1 = Evento(tipo: .none, tempo: 2, acao: {_ in}, fila: fila)
        sut.adicionar(evt1)
        let evt2 = Evento(tipo: .none, tempo: 1, acao: {_ in}, fila: fila)
        sut.adicionar(evt2)

        // then: deve retornar o evento pelo menor tempo
        XCTAssertEqual(sut.proximo()!.tempo, 1)
        XCTAssertEqual(sut.proximo()!.tempo, 2)
        XCTAssertEqual(sut.proximo()!.tempo, 5)
    }
}
