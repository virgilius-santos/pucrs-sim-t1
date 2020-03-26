
import XCTest
@testable import Simulation

class SimuladorTests: XCTestCase {

    var sut: Simulador!
    
    func testTransicaoPonderadaComRetornoParaSaida() {

        let fila = Fila(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))

        let escalonadorSpy = EscalonadorSpy()

        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila,
                                                                        destino: fila,
                                                                        saida: 1,
                                                                        retorno: 0)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)

        sut.simular()
        
        XCTAssertNotNil(fila.agendarSaida)

        fila.agendarSaida!()

        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
    }
    
    func testTransicaoPonderadaComRetornoParaORetorno() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila1Spy,
                                                                        destino: fila2Spy,
                                                                        saida: 0,
                                                                        retorno: 1)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
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
    
    func testTransicaoPonderadaComRetornoParaProximaFila() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila1Spy,
                                                                        destino: fila2Spy,
                                                                        saida: 0,
                                                                        retorno: 0)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
        XCTAssertNotNil(fila1Spy.agendarSaida)
        
        fila1Spy.agendarSaida!()
        
        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
        
        escalonadorSpy.eventoSpy!.acao(7)
        XCTAssertNil(fila2Spy.saidaTempoSpy)
        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 7)
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 7)
        XCTAssertNil(fila1Spy.chegadaTempoSpy)
    }
    
    func testTransicaoPonderadaParaFila() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.transicaoPonderada(origem: fila1Spy,
                                                              destino: fila2Spy,
                                                              taxa: 0)],
                        random: .init(maxIteracoes: 10),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
        fila1Spy.agendarSaida!()
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .transicao)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === fila1Spy)
        
        evento!.acao(6)
        
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 6)
        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 6)
    }
    
    func testTransicaoPonderadaParaSaida() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.transicaoPonderada(origem: fila1Spy,
                                                              destino: fila2Spy,
                                                              taxa: 1)],
                        random: .init(maxIteracoes: 10),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
        fila1Spy.agendarSaida!()
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .saida)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === fila1Spy)
        
        evento!.acao(6)
        
        XCTAssertEqual(fila1Spy.saidaTempoSpy, 6)
        XCTAssertNil(fila2Spy.chegadaTempoSpy)
    }
    
    func testTransicaoParaSegundaFila() {
        
        let fila1Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let fila2Spy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 0))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.transicao(origem: fila1Spy, destino: fila2Spy)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
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
    
    func testEventoSaida() {
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        sut = Simulador(configDeEventos: [.saida(fila: filaSpy)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
        filaSpy.agendarSaida!()
        
        let evento = escalonadorSpy.eventoSpy
        
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .saida)
        XCTAssertEqual(evento!.tempo, 56)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.saidaTempoSpy, 6)
    }
    
    func testEventoChegada() {
        
        let filaSpy = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 2, fim: 4),
            kendall: Kendall(c: 2, k: 4, n: 25))
        
        let escalonadorSpy = EscalonadorSpy()
        
        sut = Simulador(configDeEventos: [.chegada(fila: filaSpy)],
                        random: .init(maxIteracoes: 1),
                        escalonador: escalonadorSpy)
        
        sut.simular()
        
        let evento = escalonadorSpy.eventoSpy
        XCTAssertNotNil(evento)
        XCTAssertEqual(evento!.tipo, .chegada)
        XCTAssertEqual(evento!.tempo, 42)
        XCTAssert(evento!.fila === filaSpy)
        
        evento!.acao(6)
        
        XCTAssertEqual(filaSpy.chegadaTempoSpy, 6)
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
