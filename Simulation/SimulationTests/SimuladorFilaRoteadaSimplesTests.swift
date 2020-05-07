
import XCTest
@testable import Simulation

class SimuladorFilaRoteadaSimplesTests: XCTestCase {
    
    var sut: Simulador!
    var valoresFixos: [Double]!
    var kendall: Kendall!
    var randomSpy: CongruenteLinearSpy!
    var filaSpy1: FilaSpy!
    var filaSpy2: FilaSpy!
    var escalonadorSpy: EscalonadorSpy!
    
    override func setUp() {
        valoresFixos = [
            1, 0.2176, 0.0103, 0.1109, 0.3456, 0.9910, 0.2323, 0.9211, 0.0322,
            0.1211 , 0.5131, 0.7208, 0.9172, 0.9922, 0.8324, 0.5011, 0.2931
        ]
        
        kendall = Kendall(c: 2, k: 4, n: valoresFixos.count)
        
        randomSpy = CongruenteLinearSpy(
            maxIteracoes: kendall.n,
            valoresFixos: valoresFixos)
        
        filaSpy1 = FilaSpy(
            id: 1,
            tipoDeFila: .tandem,
            taxaEntrada: Tempo(inicio: 2, fim: 3),
            taxaSaida: Tempo(inicio: 4, fim: 7),
            kendall: kendall)
        
        filaSpy2 = FilaSpy(
            id: 2,
            tipoDeFila: .tandem,
            taxaSaida: Tempo(inicio: 4, fim: 8),
            kendall: Kendall(c: 1))
        
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
    
    func test_filaRede_loopCompleto() {
        
        setupFilaRede()
        
        for i in 0 ..< 8 {
            XCTAssertTrue(sut.rodarPassoDaSimulacao(), "index: \(i)")
        }
        
        XCTAssertFalse(sut.rodarPassoDaSimulacao())
        XCTAssertFalse(sut.rodarPassoDaSimulacao())
        
        let chegadas1 = filaSpy1.chegadaTempoSpy
        let saidas1 = filaSpy1.saidaTempoSpy
        let proximaChegadas1 = filaSpy1.proximaChegadaSpy
        let proximaSaida1 = filaSpy1.proximaSaidaSpy
        
        let chegadas2 = filaSpy2.chegadaTempoSpy
        let saidas2 = filaSpy2.saidaTempoSpy
        let proximaChegadas2 = filaSpy2.proximaChegadaSpy
        let proximaSaida2 = filaSpy2.proximaSaidaSpy
        
        let randoms = randomSpy.uniformizadoSpy
        
        let eventos = escalonadorSpy.eventoSpy
        let proximos = escalonadorSpy.proximoSpy
        let filas = escalonadorSpy.filaSpy
        
        self.valoresFixos
            .enumerated()
            .forEach { XCTAssertEqual(randoms[$0.offset], $0.element) }

        XCTAssertEqual(filaSpy1.perdasSpy, -1)
        XCTAssertEqual(filaSpy2.perdasSpy, -1)

        XCTAssertFalse(filaSpy1 == filaSpy2)

        XCTAssertEqual(proximos[0].tempo, 3)
        XCTAssertEqual(proximos[0].evt!.tipo, .chegada)
        XCTAssertEqual(proximos[0].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[1].tempo, 5.1109)
        XCTAssertEqual(proximos[1].evt!.tipo, .chegada)
        XCTAssertEqual(proximos[1].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[2].tempo, 7.0309)
        XCTAssertEqual(proximos[2].evt!.tipo, .transicao)
        XCTAssertEqual(proximos[2].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[3].tempo, 7.3432, accuracy: 0.0001)
        XCTAssertEqual(proximos[3].evt!.tipo, .chegada)
        XCTAssertEqual(proximos[3].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[4].tempo, 9.8563)
        XCTAssertEqual(proximos[4].evt!.tipo, .chegada)
        XCTAssertEqual(proximos[4].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[5].tempo, 11.7065, accuracy: 0.0001)
        XCTAssertEqual(proximos[5].evt!.tipo, .transicao)
        XCTAssertEqual(proximos[5].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[6].tempo, 12.0839)
        XCTAssertEqual(proximos[6].evt!.tipo, .transicao)
        XCTAssertEqual(proximos[6].evt!.fila, filaSpy1)
        XCTAssertEqual(proximos[7].tempo, 12.5771)
        XCTAssertEqual(proximos[7].evt!.tipo, .chegada)
        XCTAssertEqual(proximos[7].evt!.fila, filaSpy1)

        XCTAssertEqual(filas[0].tempo, 18.6831, accuracy: 0.0001)
        XCTAssertEqual(filas[0].evento.tipo, .saida)
        XCTAssertEqual(filas[1].tempo, 18.0804, accuracy: 0.0001)
        XCTAssertEqual(filas[1].evento.tipo, .saida)
        XCTAssertEqual(filas[2].tempo, 14.8702, accuracy: 0.0001)
        XCTAssertEqual(filas[2].evento.tipo, .chegada)
        XCTAssertEqual(filas[3].tempo, 14.7153, accuracy: 0.0001)
        XCTAssertEqual(filas[3].evento.tipo, .saida)

        XCTAssertEqual(eventos[0].tempo, 3)
        XCTAssertEqual(eventos[0].tipo, .chegada)
        XCTAssertEqual(eventos[1].tempo, 4.0309)
        XCTAssertEqual(eventos[1].tipo, .transicao)
        XCTAssertEqual(eventos[2].tempo, 2.1109)
        XCTAssertEqual(eventos[2].tipo, .chegada)
        XCTAssertEqual(eventos[3].tempo, 6.9730, accuracy: 0.0001)
        XCTAssertEqual(eventos[3].tipo, .transicao)
        XCTAssertEqual(eventos[4].tempo, 2.2323)
        XCTAssertEqual(eventos[4].tipo, .chegada)
        XCTAssertEqual(eventos[5].tempo, 7.6844)
        XCTAssertEqual(eventos[5].tipo, .saida)
        XCTAssertEqual(eventos[6].tempo, 4.3633)
        XCTAssertEqual(eventos[6].tipo, .transicao)
        XCTAssertEqual(eventos[7].tempo, 2.5131)
        XCTAssertEqual(eventos[7].tipo, .chegada)
        XCTAssertEqual(eventos[8].tempo, 2.7208)
        XCTAssertEqual(eventos[8].tipo, .chegada)
        XCTAssertEqual(eventos[9].tempo, 6.9766, accuracy: 0.0001)
        XCTAssertEqual(eventos[9].tipo, .saida)
        XCTAssertEqual(eventos[10].tempo, 5.5033, accuracy: 0.0001)
        XCTAssertEqual(eventos[10].tipo, .saida)
        XCTAssertEqual(eventos[11].tempo, 2.2931, accuracy: 0.0001)
        XCTAssertEqual(eventos[11].tipo, .chegada)
        
        XCTAssertEqual(chegadas1.count, 5)
        XCTAssertEqual(proximaChegadas1.count, 6)
        XCTAssertEqual(saidas1.count, 3)
        XCTAssertEqual(proximaSaida1.count, 5)
        
        XCTAssertEqual(chegadas2.count, 3)
        XCTAssertEqual(proximaChegadas2.count, 0)
        XCTAssertEqual(saidas2.count, 0)
        XCTAssertEqual(proximaSaida2.count, 1)
        
        XCTAssertEqual(proximos.count, 8)
        XCTAssertEqual(filas.count, 4)
        XCTAssertEqual(eventos.count, 12)
        
        XCTAssertEqual(randoms.count, 17)
        
        XCTAssertEqual(filaSpy1.dados.estatisticaAtual.tempo, 12.5771, accuracy: 0.0001)
        XCTAssertEqual(filaSpy1.dados.estatisticaAtual.evento, .chegada)
        XCTAssertEqual(filaSpy1.dados.estatisticaAtual.quantDaFila, 2)
        XCTAssertEqual(filaSpy2.dados.estatisticaAtual.tempo, 12.5771, accuracy: 0.0001)
        XCTAssertEqual(filaSpy2.dados.estatisticaAtual.evento, .chegada)
        XCTAssertEqual(filaSpy2.dados.estatisticaAtual.quantDaFila, 3)
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
                               destinos: [(filaSpy2, 0.7)]),
                
                .saida(fila: filaSpy2),
                
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
