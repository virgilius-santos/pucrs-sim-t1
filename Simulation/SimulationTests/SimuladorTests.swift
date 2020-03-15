
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
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy)
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
        
        escalonadorSpy.eventoSpy!.acao(4)
        XCTAssertNil(fila1Spy.chegadaTempoSpy)
        XCTAssertNil(fila2Spy.saidaTempoSpy)
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 4)
        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 4)
    }
    
    func testConfigurarAgendamentoDeTransicaoComSaida() {
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
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy,
            saida: 1)
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .saida)
        
        escalonadorSpy.eventoSpy!.acao(7)
        XCTAssertNil(fila1Spy.chegadaTempoSpy)
        XCTAssertNil(fila2Spy.saidaTempoSpy)
        XCTAssertNil(fila2Spy.chegadaTempoSpy)
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 7)
    }
    
    func testConfigurarAgendamentoDeTransicaoComRetorno() {
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
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy,
            retorno: 1)
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
        
        escalonadorSpy.eventoSpy!.acao(7)
        XCTAssertNil(fila2Spy.saidaTempoSpy)
        XCTAssertNil(fila2Spy.chegadaTempoSpy)
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 7)
        XCTAssertEqual(fila1Spy.chegadaTempoSpy, 7)
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
        
        sut.gerarEventoTransicao(filaDeOrigem: fila1Spy,
                                 filaDeDestino: fila2Spy)
        
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
        
        init(escalonador: Escalonador) {
            super.init(agendamentos: [], random: .init(), escalonador: escalonador)
        }
        
        override func simular() -> [Estatistica] {
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
