
import XCTest
@testable import Simulation

class SimuladorTests: XCTestCase {

    var sut: Simulador!
    
    func testConfigurarAgendamentoDeSaida() {
        let random = CongruenteLinear()
        
        let fila = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeSaida(fila)
        
        XCTAssertNotNil(fila.agendarSaida)
        
        fila.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
    }
    
    func testConfigurarAgendamentoDeTransicao() {
        let random = CongruenteLinear()
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeTransicao(
            filaDeEntrada: fila1Spy,
            filaDeSaida: fila2Spy)
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
    }
    
    func testConfigurarAgendamentoDeTransicaoPonderado() {
        let random = CongruenteLinear()
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeTransicao(
            filaDeEntrada: fila1Spy,
            filaDeSaida: fila2Spy,
            saida: 1)
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .saida)
    }
    
    func testGerarEventoSaida() {
        let random = CongruenteLinear()
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.gerarEventoSaida(filaSpy)
        
        let evento = escalonadorSpy.eventoSpy
        
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .saida)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.saidaTempoSpy, 6)
    }
    
    func testGerarEventoChegada() {
        let random = CongruenteLinear()
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.gerarEventoChegada(filaSpy)
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .chegada)
        XCTAssertEqual(evento!.tempo, 42)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.chegadaTempoSpy, 6)
    }
    
    func testGerarEventoTransicao() {
        let random = CongruenteLinear()
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        sut.gerarEventoTransicao(filaDeEntrada: fila1Spy,
                                 filaDeSaida: fila2Spy)
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .transicao)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === fila1Spy)
        
        evento!.acao(6)
        
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 6)
        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 6)
    }
    
    func testProcessarEventoComUmaChegada() {
        
        let random = CongruenteLinear()
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        var acaoSpy: Bool?
        
        let evento = Evento(tipo: .chegada,
                            tempo: 78,
                            acao: { tempo in acaoSpy = true },
                            fila: filaSpy)
        
        sut.processarEvento(evento)
        
        XCTAssertEqual(acaoSpy, true)
        XCTAssertEqual(escalonadorSpy.adicionarChamadoSpy, true)
        
    }
    
    func testProcessarEventoComUmaSaida() {
      
        let random = CongruenteLinear()
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25),
            random: random)
        
        let escalonadorSpy = EscalonadorSpy()
        sut = SimuladorDummy(escalonador: escalonadorSpy)
        
        var acaoSpy: Bool?
        
        let evento = Evento(tipo: .saida,
                            tempo: 78,
                            acao: { tempo in acaoSpy = true },
                            fila: filaSpy)
        
        sut.processarEvento(evento)
        
        XCTAssertEqual(acaoSpy, true)
        XCTAssertNil(escalonadorSpy.adicionarChamadoSpy)
    }
    
    class SimuladorDummy: Simulador {
        var random: CongruenteLinear = .init()
        let escalonador: Escalonador
        
        init(escalonador: Escalonador) {
            self.escalonador = escalonador
        }
        
        func simular() -> [Estatistica] {
            []
        }
    }
    
    class EscalonadorSpy: Escalonador {
        var adicionarChamadoSpy: Bool?
        var eventoSpy: Evento?
        override func adicionar(_ evento: Evento) {
            adicionarChamadoSpy = true
            eventoSpy = evento
        }
    }
    
    class FilaSpy: Fila {
        
        var saidaTempoSpy: Double?
        var chegadaTempoSpy: Double?
        override var proximaSaida: Double {
            return 56
        }
        
        override var proximaChegada: Double {
            return 42
        }
        
        override func saida(tempo: Double) {
            saidaTempoSpy = tempo
        }
        
        override func chegada(tempo: Double) {
            chegadaTempoSpy = tempo
        }
    }
}
