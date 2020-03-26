
import XCTest
@testable import Simulation

class SimuladorTests: XCTestCase {

    var sut: Simulador!
    
    func testConfigurarAgendamentoDeSaida() {
        
        let fila = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
                
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeSaida(fila,
                                         randomUniformizado: 0.42)
        
        XCTAssertNotNil(fila.agendarSaida)
        
        fila.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
    }
    
    func testConfigurarAgendamentoDeTransicao() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeTransicao(
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy,
            randomUniformizado: 0.42)
        
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
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeTransicao(
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy,
            saida: 1,
            randomUniformizado: 0.42)
        
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
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.configurarAgendamentoDeTransicao(
            filaDeOrigem: fila1Spy,
            filaDeDestino: fila2Spy,
            retorno: 1,
            randomUniformizado: 0.42)
        
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
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.gerarEventoSaida(filaSpy, randomUniformizado: 0.46)
        
        let evento = escalonadorSpy.eventoSpy
        
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .saida)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.saidaTempoSpy, 6)
    }
    
    func testGerarEventoChegada() {
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.gerarEventoChegada(filaSpy, randomUniformizado: 0.42)
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .chegada)
        XCTAssertEqual(evento!.tempo, 42)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.chegadaTempoSpy, 6)
    }
    
    func testGerarEventoTransicao() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        sut.gerarEventoTransicao(filaDeOrigem: fila1Spy,
                                 filaDeDestino: fila2Spy,
                                 randomUniformizado: 0.46)
        
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
                
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        var acaoSpy: Bool?
        
        let evento = Evento(tipo: .chegada,
                            tempo: 78,
                            acao: { tempo in acaoSpy = true },
                            fila: filaSpy)
        
        sut.processarEvento(evento, randomUniformizado: 0.42)
        
        XCTAssertEqual(acaoSpy, true)
        XCTAssertEqual(escalonadorSpy.adicionarChamadoSpy, true)
        
    }
    
    func testProcessarEventoComUmaSaida() {
              
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [],
                        random: .init(maxIteracoes: 0),
                        escalonador: escalonadorSpy)
        
        var acaoSpy: Bool?
        
        let evento = Evento(tipo: .saida,
                            tempo: 78,
                            acao: { tempo in acaoSpy = true },
                            fila: filaSpy)
        
        sut.processarEvento(evento, randomUniformizado: 0.42)
        
        XCTAssertEqual(acaoSpy, true)
        XCTAssertNil(escalonadorSpy.adicionarChamadoSpy)
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
        
        override func saida(tempo: Double) {
            saidaTempoSpy = tempo
        }
        
        override func chegada(tempo: Double) {
            chegadaTempoSpy = tempo
        }
        
        override func proximaChegada(randomUniformizado: Double) -> Double {
            return 42
        }
        
        override func proximaSaida(randomUniformizado: Double) -> Double {
            return 56
        }
    }
}
