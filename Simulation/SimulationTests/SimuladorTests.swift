
import XCTest
@testable import Simulation

class SimuladorTests: XCTestCase {

    var sut: Simulador!
    var valoresFixos: [Double]!
    var kendall: Kendall!
    var randomSpy: CongruenteLinearSpy!
    var filaSpy1: FilaSpy!
    var filaSpy2: FilaSpy!
    var escalonadorSpy: EscalonadorSpy!
    
    override func setUp() {
        valoresFixos = [1, 0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881]
        
        kendall = Kendall(c: 1, k: 3, n: valoresFixos.count)
        
        randomSpy = CongruenteLinearSpy(
            maxIteracoes: kendall.n,
            valoresFixos: valoresFixos)
        
        filaSpy1 = FilaSpy(
            taxaEntrada: Tempo(inicio: 1, fim: 2),
            taxaSaida: Tempo(inicio: 3, fim: 6),
            kendall: kendall)
        
        filaSpy2 = FilaSpy(
            taxaEntrada: Tempo(inicio: 2, fim: 3),
            taxaSaida: Tempo(inicio: 2, fim: 5),
            kendall: Kendall(c: 2, k: 3))
        
        escalonadorSpy = EscalonadorSpy()
    }
    
    override func tearDown() {
        sut = nil
        valoresFixos = nil
        kendall = nil
        randomSpy = nil
        filaSpy1 = nil
        filaSpy2 = nil
        escalonadorSpy = nil
    }
    
//    func testTransicaoPonderadaComRetornoParaSaida() {
//
//        let fila = Fila(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila,
//                                                                        destino: fila,
//                                                                        saida: 1,
//                                                                        retorno: 0)],
//                        random: .init(maxIteracoes: 1),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        XCTAssertNotNil(fila.agendarSaida)
//
//        fila.agendarSaida!()
//
//        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
//    }
    
//    func testTransicaoPonderadaComRetornoParaORetorno() {
//
//        let fila1Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let fila2Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 0))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila1Spy,
//                                                                        destino: fila2Spy,
//                                                                        saida: 0,
//                                                                        retorno: 1)],
//                        random: .init(maxIteracoes: 1),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        XCTAssertNotNil(fila1Spy.agendarSaida)
//
//        fila1Spy.agendarSaida!()
//
//        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
//        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
//
//        escalonadorSpy.eventoSpy!.acao(7)
//        XCTAssertNil(fila2Spy.saidaTempoSpy)
//        XCTAssertNil(fila2Spy.chegadaTempoSpy)
//        XCTAssertEqual(fila1Spy.saidaTempoSpy, 7)
//        XCTAssertEqual(fila1Spy.chegadaTempoSpy, 7)
//    }
    
//    func testTransicaoPonderadaComRetornoParaProximaFila() {
//
//        let fila1Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let fila2Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 0))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicaoPonderadaComRetorno(origem: fila1Spy,
//                                                                        destino: fila2Spy,
//                                                                        saida: 0,
//                                                                        retorno: 0)],
//                        random: .init(maxIteracoes: 1),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        XCTAssertNotNil(fila1Spy.agendarSaida)
//
//        fila1Spy.agendarSaida!()
//
//        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
//        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
//
//        escalonadorSpy.eventoSpy!.acao(7)
//        XCTAssertNil(fila2Spy.saidaTempoSpy)
//        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 7)
//        XCTAssertEqual(fila1Spy.saidaTempoSpy, 7)
//        XCTAssertNil(fila1Spy.chegadaTempoSpy)
//    }
    
//    func testTransicaoPonderadaParaFila() {
//
//        let fila1Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let fila2Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 0))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicaoPonderada(origem: fila1Spy,
//                                                              destino: fila2Spy,
//                                                              taxa: 0)],
//                        random: .init(maxIteracoes: 10),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        fila1Spy.agendarSaida!()
//
//        let evento = escalonadorSpy.eventoSpy
//        XCTAssertNotNil(evento)
//        XCTAssertEqual(evento!.tipo, .transicao)
//        XCTAssertEqual(evento!.tempo, 56)
//        XCTAssert(evento!.fila === fila1Spy)
//
//        evento!.acao(6)
//
//        XCTAssertEqual(fila1Spy.saidaTempoSpy, 6)
//        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 6)
//    }
    
//    func testTransicaoPonderadaParaSaida() {
//
//        let fila1Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let fila2Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 0))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicaoPonderada(origem: fila1Spy,
//                                                              destino: fila2Spy,
//                                                              taxa: 1)],
//                        random: .init(maxIteracoes: 10),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        fila1Spy.agendarSaida!()
//
//        let evento = escalonadorSpy.eventoSpy
//        XCTAssertNotNil(evento)
//        XCTAssertEqual(evento!.tipo, .saida)
//        XCTAssertEqual(evento!.tempo, 56)
//        XCTAssert(evento!.fila === fila1Spy)
//
//        evento!.acao(6)
//
//        XCTAssertEqual(fila1Spy.saidaTempoSpy, 6)
//        XCTAssertNil(fila2Spy.chegadaTempoSpy)
//    }
    
//    func testTransicaoParaSegundaFila() {
//
//        let fila1Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 25))
//
//        let fila2Spy = FilaSpy(
//            taxaEntrada: Tempo(inicio: 1, fim: 2),
//            taxaSaida: Tempo(inicio: 2, fim: 4),
//            kendall: Kendall(c: 2, k: 4, n: 0))
//
//        let escalonadorSpy = EscalonadorSpy()
//
//        sut = Simulador(configDeEventos: [.transicao(origem: fila1Spy, destino: fila2Spy)],
//                        random: .init(maxIteracoes: 1),
//                        escalonador: escalonadorSpy)
//
//        sut.simular()
//
//        XCTAssertNotNil(fila1Spy.agendarSaida)
//
//        fila1Spy.agendarSaida!()
//
//        XCTAssertTrue(escalonadorSpy.adicionarChamadoSpy!)
//        XCTAssertEqual(escalonadorSpy.eventoSpy!.tipo, .transicao)
//
//        escalonadorSpy.eventoSpy!.acao(4)
//        XCTAssertNil(fila1Spy.chegadaTempoSpy)
//        XCTAssertNil(fila2Spy.saidaTempoSpy)
//        XCTAssertEqual(fila1Spy.saidaTempoSpy, 4)
//        XCTAssertEqual(fila2Spy.chegadaTempoSpy, 4)
//    }
    
    func testConfigEventosFilaSimples() {
        
        setupFilaSimples()
        
        let eventos = escalonadorSpy.eventoSpy
        let randoms = randomSpy.uniformizadoSpy
        let proximaChegadas = filaSpy1.proximaChegadaSpy
        
        XCTAssertEqual(eventos.count, 1)
        XCTAssertEqual(randoms.count, 1)
        XCTAssertEqual(proximaChegadas.count, 1)
        
        XCTAssertEqual(eventos[0].tipo, .chegada)
        XCTAssertEqual(randoms[0], valoresFixos[0])
        XCTAssertEqual(proximaChegadas[0], 2)
        XCTAssertEqual(eventos[0].tempo, 2)
        XCTAssertEqual(eventos[0].fila, filaSpy1)
        
        XCTAssertNotNil(filaSpy1.agendarSaida)
    }
    
    func testPrimeiroEvento() {
        
        setupFilaSimples()
        
        executarEventos(pulando: 0)
        
        let chegadas = filaSpy1.chegadaTempoSpy
        let saidas = filaSpy1.saidaTempoSpy
        let randoms = randomSpy.uniformizadoSpy
        let eventos = escalonadorSpy.eventoSpy
        let proximaChegadas = filaSpy1.proximaChegadaSpy
        let proximaSaida = filaSpy1.proximaSaidaSpy

        // chegada na fila
        XCTAssertEqual(chegadas[0], 2)
        
        // agendamento de saida
        XCTAssertEqual(randoms[0], valoresFixos[1])
        XCTAssertEqual(eventos[0].tipo, .saida)
        XCTAssertEqual(eventos[0].tempo, 3.9828)
        XCTAssertEqual(eventos[0].fila, filaSpy1)
        
        // agendamento de chegada
        XCTAssertEqual(eventos[1].tipo, .chegada)
        XCTAssertEqual(randoms[1], valoresFixos[2])
        XCTAssertEqual(proximaChegadas[0], 1.8851)
        XCTAssertEqual(proximaSaida[0], 3.9828)
        XCTAssertEqual(eventos[1].tempo, 1.8851)
        XCTAssertEqual(eventos[1].fila, filaSpy1)
        
        XCTAssertEqual(chegadas.count, 1)
        XCTAssertEqual(saidas.count, 0)
        XCTAssertEqual(eventos.count, 2)
        XCTAssertEqual(randoms.count, 2)
        XCTAssertEqual(proximaChegadas.count, 1)
        XCTAssertEqual(proximaSaida.count, 1)
    }
    
    func testSegundoEvento() {
        
        setupFilaSimples()
        
        executarEventos(pulando: 1)
        
        let chegadas = filaSpy1.chegadaTempoSpy
        let saidas = filaSpy1.saidaTempoSpy
        let randoms = randomSpy.uniformizadoSpy
        let eventos = escalonadorSpy.eventoSpy
        let proximaChegadas = filaSpy1.proximaChegadaSpy
        let proximaSaida = filaSpy1.proximaSaidaSpy
        
        // chegada na fila
        XCTAssertEqual(chegadas[0], 3.8851)
        
        // agendamento de chegada
        XCTAssertEqual(eventos[0].tipo, .chegada)
        XCTAssertEqual(randoms[0], valoresFixos[3])
        XCTAssertEqual(proximaChegadas[0], 1.1643)
//        XCTAssertEqual(proximaSaida[0], 3.9828)
        XCTAssertEqual(eventos[0].tempo, 1.1643)
        XCTAssertEqual(eventos[0].fila, filaSpy1)
        
        XCTAssertEqual(chegadas.count, 1)
        XCTAssertEqual(saidas.count, 0)
        XCTAssertEqual(eventos.count, 1)
        XCTAssertEqual(randoms.count, 1)
        XCTAssertEqual(proximaChegadas.count, 1)
        XCTAssertEqual(proximaSaida.count, 0)
    }
    
    func testTerceiroEvento() {
        
        setupFilaSimples()
        
        executarEventos(pulando: 3)
        
        let chegadas = filaSpy1.chegadaTempoSpy
        let saidas = filaSpy1.saidaTempoSpy
        let randoms = randomSpy.uniformizadoSpy
        let eventos = escalonadorSpy.eventoSpy
        let proximaChegadas = filaSpy1.proximaChegadaSpy
        let proximaSaida = filaSpy1.proximaSaidaSpy
        
        // chegada na fila
        XCTAssertEqual(saidas[0], 5.9828)
        
        // agendamento de saida
        XCTAssertEqual(randoms[0], valoresFixos[5])
        XCTAssertEqual(eventos[0].tipo, .saida)
        XCTAssertEqual(eventos[0].tempo, 5.0439)
        XCTAssertEqual(eventos[0].fila, filaSpy1)
        
        // agendamento de chegada
//        XCTAssertEqual(eventos[0].tipo, .chegada)
//        XCTAssertEqual(randoms[0], valoresFixos[4])
//        XCTAssertEqual(proximaChegadas[0], 1.5542)
//        XCTAssertEqual(proximaSaida[0], 3.9828)
//        XCTAssertEqual(eventos[0].tempo, 1.5542)
//        XCTAssertEqual(eventos[0].fila, filaSpy1)
        
        XCTAssertEqual(chegadas.count, 0)
        XCTAssertEqual(saidas.count, 1)
        XCTAssertEqual(eventos.count, 1)
        XCTAssertEqual(randoms.count, 1)
        XCTAssertEqual(proximaChegadas.count, 0)
        XCTAssertEqual(proximaSaida.count, 1)
    }
    
    func executarEventos(pulando: Int) {
        for _ in 0 ..< pulando {
            XCTAssertTrue(sut.rodarPassoDaSimulacao())
        }
        
        filaSpy1.chegadaTempoSpy = []
        filaSpy1.saidaTempoSpy = []
        randomSpy.uniformizadoSpy = []
        escalonadorSpy.eventoSpy = []
        filaSpy1.proximaChegadaSpy = []
        filaSpy1.proximaSaidaSpy = []
        
        XCTAssertTrue(sut.rodarPassoDaSimulacao())
    }
    
    func setupFilaSimples() {
        sut = Simulador(
            configDeEventos: [
                .chegada(fila: filaSpy1),
                .saida(fila: filaSpy1),
            ],
            random: randomSpy,
            escalonador: escalonadorSpy)
        
        sut.configurar()
    }
    
    class EscalonadorSpy: Escalonador {
        var eventoSpy: [Evento] = []
        override func adicionar(_ evento: Evento) {
            super.adicionar(evento)
            eventoSpy.append(evento)
        }
    }
    
    class FilaSpy: Fila {
        
        var saidaTempoSpy: [Double] = []
        var chegadaTempoSpy: [Double] = []
        var proximaChegadaSpy: [Double] = []
        var proximaSaidaSpy: [Double] = []
        var agendarSaidaSpy: [(ActionVoid)?] = []
        
        override var agendarSaida: (ActionVoid)? {
            didSet {
                agendarSaidaSpy.append(agendarSaida)
            }
        }
        
        override func saida(tempo: Double) {
            super.saida(tempo: tempo)
            saidaTempoSpy.append(tempo)
        }
        
        override func chegada(tempo: Double) {
            super.chegada(tempo: tempo)
            chegadaTempoSpy.append(tempo)
        }
        
        override func proximaChegada(randomUniformizado: Double) -> Double {
            let proximaChegada = super.proximaChegada(randomUniformizado: randomUniformizado)
            proximaChegadaSpy.append(proximaChegada)
            return proximaChegada
        }
        
        override func proximaSaida(randomUniformizado: Double) -> Double {
            let proximaSaida = super.proximaSaida(randomUniformizado: randomUniformizado)
            proximaSaidaSpy.append(proximaSaida)
            return proximaSaida
        }
    }
    
    class CongruenteLinearSpy: CongruenteLinear {
        
        var uniformizadoSpy: [Double?] = []
        
        override func uniformizado() -> Double? {
            let uniformizado = super.uniformizado()
            uniformizadoSpy.append(uniformizado)
            return uniformizado
        }
    }
}
