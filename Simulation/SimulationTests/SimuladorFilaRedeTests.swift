
import XCTest
@testable import Simulation

class SimuladorFilaRedeTests: XCTestCase {
    
    var sut: Simulador!
    var valoresFixos: [Double]!
    var randomSpy: CongruenteLinearSpy!
    var filaSpy1: FilaSpy!
    var filaSpy2: FilaSpy!
    var filaSpy3: FilaSpy!
    var escalonadorSpy: EscalonadorSpy!
    
    override func setUp() {
        valoresFixos = [
            2.0/3,
            0.8, 0.2, 0.1, 0.9, 0.3, 0.4, 0.7,
            0.8, 0.2, 0.1, 0.9, 0.3, 0.4, 0.7,
            0.8, 0.2, 0.1, 0.9, 0.3, 0.4, 0.7,
        ]
        
        let kendall = Kendall(c: 1, n: valoresFixos.count)
        
        randomSpy = CongruenteLinearSpy(
            maxIteracoes: kendall.n,
            valoresFixos: valoresFixos)
        
        filaSpy1 = FilaSpy(
            id: 1,
            tipoDeFila: .rede,
            taxaEntrada: Tempo(inicio: 1, fim: 4),
            taxaSaida: Tempo(inicio: 1, fim: 1.5),
            kendall: kendall)
        
        filaSpy2 = FilaSpy(
            id: 2,
            tipoDeFila: .rede,
            taxaSaida: Tempo(inicio: 5, fim: 10),
            kendall: Kendall(c: 3, k: 5))
        
        filaSpy3 = FilaSpy(
            id: 3,
            tipoDeFila: .rede,
            taxaSaida: Tempo(inicio: 2, fim: 8),
            kendall: Kendall(c: 10, k: 20))
        
        escalonadorSpy = EscalonadorSpy()
    }
    
    override func tearDown() {
        sut = nil
        valoresFixos = nil
        randomSpy = nil
        filaSpy1 = nil
        filaSpy2 = nil
        filaSpy3 = nil
        escalonadorSpy = nil
    }
    
    func test_filaRede_transicao() {
        
        valoresFixos = [
            0.9, 0.2, 0.6,
        ]
        
        randomSpy = CongruenteLinearSpy(
            maxIteracoes: 10,
            valoresFixos: valoresFixos)
        
        sut = Simulador(
            configDeEventos: [
                
                .transicaoRede(origem: filaSpy2,
                               destinos: [(filaSpy1, 0.3), (filaSpy3, 0.5)]),
                
            ],
            random: randomSpy,
            escalonador: escalonadorSpy)
        
        sut.configurar()
        
        let agendarSaida = filaSpy2.agendarSaida
        XCTAssertNotNil(agendarSaida)
        
        agendarSaida?()
        agendarSaida?()
        agendarSaida?()
        
        let eventos = escalonadorSpy.eventoSpy
        
        XCTAssertEqual(eventos.count, 3)
        
        XCTAssertEqual(eventos[0].tipo, .saida)
        XCTAssertEqual(eventos[1].tipo, .transicao)
        XCTAssertEqual(eventos[2].tipo, .transicao)
        
        eventos[0].acao(0.6)
        XCTAssertEqual(filaSpy2.saidaTempoSpy.count, 1)
        XCTAssertEqual(filaSpy2.saidaTempoSpy[0], 0.6)
        XCTAssertEqual(filaSpy1.chegadaTempoSpy.count, 0)
        XCTAssertEqual(filaSpy3.chegadaTempoSpy.count, 0)
        clearSpy()
        
        eventos[1].acao(0.7)
        XCTAssertEqual(filaSpy2.saidaTempoSpy.count, 1)
        XCTAssertEqual(filaSpy2.saidaTempoSpy[0], 0.7)
        XCTAssertEqual(filaSpy1.chegadaTempoSpy.count, 1)
        XCTAssertEqual(filaSpy1.chegadaTempoSpy[0], 0.7)
        XCTAssertEqual(filaSpy3.chegadaTempoSpy.count, 0)
        clearSpy()
        
        eventos[2].acao(0.8)
        XCTAssertEqual(filaSpy2.saidaTempoSpy.count, 1)
        XCTAssertEqual(filaSpy2.saidaTempoSpy[0], 0.8)
        XCTAssertEqual(filaSpy1.chegadaTempoSpy.count, 0)
        XCTAssertEqual(filaSpy3.chegadaTempoSpy.count, 1)
        XCTAssertEqual(filaSpy3.chegadaTempoSpy[0], 0.8)
        clearSpy()
        
    }
    
    func test_filaRede_loopCompleto() {

        setupFilaRede()

        for i in 0 ..< 16 {
            XCTAssertTrue(sut.rodarPassoDaSimulacao(), "index: \(i)")
        }

        XCTAssertFalse(sut.rodarPassoDaSimulacao(), "ultimo step")

        let randoms = randomSpy.uniformizadoSpy
        
        let valoresFixos = self.valoresFixos.enumerated()
        valoresFixos
            .forEach { XCTAssertEqual(randoms[$0.offset], $0.element) }
        
        XCTAssertEqual(filaSpy1.perdasSpy, -1)
        XCTAssertEqual(filaSpy2.perdasSpy, -1)
        XCTAssertEqual(filaSpy3.perdasSpy, -1)
        
        XCTAssertFalse(filaSpy1 == filaSpy2)
        XCTAssertFalse(filaSpy1 == filaSpy3)
        XCTAssertFalse(filaSpy2 == filaSpy3)
        
        let estatisticasFila1 = filaSpy1.dados.estatisticaAtual
        
        let eventos = escalonadorSpy.eventoSpy
        XCTAssertEqual(eventos[0].tempo, 3)
        XCTAssertEqual(eventos[0].tipo, .chegada)
       
        XCTAssertEqual(estatisticasFila1.perdas, 0)
        XCTAssertEqual(estatisticasFila1.tempo, 14.9, accuracy: 0.0001)
    }
    
    func executarEventos(pulando: Int) {
        for _ in 0 ..< pulando {
            XCTAssertTrue(sut.rodarPassoDaSimulacao())
        }
        
        clearSpy()
        
        XCTAssertTrue(sut.rodarPassoDaSimulacao())
    }
    
    func clearSpy() {
        filaSpy1.chegadaTempoSpy = []
        filaSpy1.saidaTempoSpy = []
        filaSpy1.proximaChegadaSpy = []
        filaSpy1.proximaSaidaSpy = []
        filaSpy1.perdasSpy = -1
        
        filaSpy2.chegadaTempoSpy = []
        filaSpy2.saidaTempoSpy = []
        filaSpy2.proximaChegadaSpy = []
        filaSpy2.proximaSaidaSpy = []
        filaSpy2.perdasSpy = -1
        
        filaSpy3.chegadaTempoSpy = []
        filaSpy3.saidaTempoSpy = []
        filaSpy3.proximaChegadaSpy = []
        filaSpy3.proximaSaidaSpy = []
        filaSpy3.perdasSpy = -1
        
        randomSpy.uniformizadoSpy = []
        escalonadorSpy.eventoSpy = []
        escalonadorSpy.proximoSpy = []
        escalonadorSpy.filaSpy = []
    }
    
    func setupFilaRede() {
        sut = Simulador(
            configDeEventos: [
                
                // gera a primeira chegada no escalonador
                .chegada(fila: filaSpy1),
                
                .transicaoRede(origem: filaSpy1,
                               destinos: [(filaSpy2, 0.8), (filaSpy3, 0.2)]),

                .transicaoRede(origem: filaSpy2,
                               destinos: [(filaSpy1, 0.3), (filaSpy3, 0.5)]),

                .transicaoRede(origem: filaSpy3,
                               destinos: [(filaSpy2, 0.7)]),
                
            ],
            random: randomSpy,
            escalonador: escalonadorSpy)
        
        sut.configurar()
    }
    
    class EscalonadorSpy: Escalonador {
        var eventoSpy: [Evento] = []
        var proximoSpy: [(tempo: Double, evt: Evento?)] = []
        var filaSpy: [KeyValue] = []
        
        override func adicionar(_ evento: Evento) {
            super.adicionar(evento)
            eventoSpy.append(evento)
            filaSpy = fila
        }
        
        override func proximo() -> Evento? {
            let proximo = super.proximo()
            proximoSpy.append((tempo, proximo))
            filaSpy = fila
            return proximo
        }
    }
    
    class FilaSpy: Fila {
        
        var saidaTempoSpy: [Double] = []
        var chegadaTempoSpy: [Double] = []
        var proximaChegadaSpy: [Double] = []
        var proximaSaidaSpy: [Double] = []
        var agendarSaidaSpy: [(ActionVoid)?] = []
        var perdasSpy: Int = -1
        
        override var agendarSaida: (ActionVoid)? {
            didSet {
                agendarSaidaSpy.append(agendarSaida)
            }
        }
        
        override var perdas: Int {
            didSet {
                perdasSpy = perdas
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
