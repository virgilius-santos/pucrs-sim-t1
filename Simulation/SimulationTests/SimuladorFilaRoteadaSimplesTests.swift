
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
            1, 0.0103, 0.1109, 0.9910, 0.2323, 0.9211,
            0.1211 , 0.5131, 0.7208, 0.9922, 0.5011, 0.2931
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
        clearSpy()
        for i in 0 ..< 9 {
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
        
//        self.valoresFixos
//            .enumerated()
//            .forEach { XCTAssertEqual(randoms[$0.offset], $0.element) }

        XCTAssertEqual(filaSpy1.perdasSpy, -1)
        XCTAssertEqual(filaSpy2.perdasSpy, -1)

        XCTAssertFalse(filaSpy1 == filaSpy2)

//        XCTAssertEqual(proximos[0].tempo, 3)
//        XCTAssertEqual(proximos[0].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[0].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[1].tempo, 4.5004)
//        XCTAssertEqual(proximos[1].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[1].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[2].tempo, 6.7765)
//        XCTAssertEqual(proximos[2].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[2].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[3].tempo, 7.4763)
//        XCTAssertEqual(proximos[3].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[3].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[4].tempo, 8.1606)
//        XCTAssertEqual(proximos[4].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[4].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[5].tempo, 9.1163)
//        XCTAssertEqual(proximos[5].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[5].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[6].tempo, 11.1559)
//        XCTAssertEqual(proximos[6].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[6].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[7].tempo, 11.5732)
//        XCTAssertEqual(proximos[7].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[7].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[8].tempo, 12.1652)
//        XCTAssertEqual(proximos[8].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[8].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[9].tempo, 12.2809, accuracy: 0.0001)
//        XCTAssertEqual(proximos[9].evt!.tipo, .saida)
//        XCTAssertEqual(proximos[9].evt!.fila, filaSpy2)
//        XCTAssertEqual(proximos[10].tempo, 14.494)
//        XCTAssertEqual(proximos[10].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[10].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[11].tempo, 15.1095)
//        XCTAssertEqual(proximos[11].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[11].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[12].tempo, 15.3151)
//        XCTAssertEqual(proximos[12].evt!.tipo, .saida)
//        XCTAssertEqual(proximos[12].evt!.fila, filaSpy2)
//        XCTAssertEqual(proximos[13].tempo, 17.1837)
//        XCTAssertEqual(proximos[13].evt!.tipo, .transicao)
//        XCTAssertEqual(proximos[13].evt!.fila, filaSpy1)
//        XCTAssertEqual(proximos[14].tempo, 17.3485)
//        XCTAssertEqual(proximos[14].evt!.tipo, .chegada)
//        XCTAssertEqual(proximos[14].evt!.fila, filaSpy1)
//
//        XCTAssertEqual(filas[0].tempo, 20.2248, accuracy: 0.0001)
//        XCTAssertEqual(filas[0].evento.tipo, .transicao)
//        XCTAssertEqual(filas[1].tempo, 19.5153, accuracy: 0.0001)
//        XCTAssertEqual(filas[1].evento.tipo, .saida)
//
        XCTAssertEqual(eventos[0].tempo, 4.0309)
        XCTAssertEqual(eventos[0].tipo, .transicao)
        XCTAssertEqual(eventos[1].tempo, 2.1109)
        XCTAssertEqual(eventos[1].tipo, .chegada)
        XCTAssertEqual(eventos[2].tempo, 6.9730, accuracy: 0.0001)
        XCTAssertEqual(eventos[2].tipo, .transicao)
        XCTAssertEqual(eventos[3].tempo, 2.2323)
        XCTAssertEqual(eventos[3].tipo, .chegada)
        XCTAssertEqual(eventos[4].tempo, 7.6844)
        XCTAssertEqual(eventos[4].tipo, .saida)
        XCTAssertEqual(eventos[5].tempo, 2.3398)
        XCTAssertEqual(eventos[5].tipo, .transicao)
        XCTAssertEqual(eventos[6].tempo, 4.6889)
        XCTAssertEqual(eventos[6].tipo, .chegada)
        XCTAssertEqual(eventos[7].tempo, 4.8046)
        XCTAssertEqual(eventos[7].tipo, .chegada)
        XCTAssertEqual(eventos[8].tempo, 2.0396)
        XCTAssertEqual(eventos[8].tipo, .saida)
        XCTAssertEqual(eventos[9].tempo, 2.4569)
        XCTAssertEqual(eventos[9].tipo, .saida)
//        XCTAssertEqual(eventos[10].tempo, 3.5363, accuracy: 0.0001)
//        XCTAssertEqual(eventos[10].tipo, .chegada)
//        XCTAssertEqual(eventos[11].tempo, 2.9208)
//        XCTAssertEqual(eventos[11].tipo, .chegada)
//        XCTAssertEqual(eventos[12].tempo, 3.0342)
//        XCTAssertEqual(eventos[12].tipo, .saida)
//        XCTAssertEqual(eventos[13].tempo, 2.6897)
//        XCTAssertEqual(eventos[13].tipo, .transicao)
//        XCTAssertEqual(eventos[14].tempo, 2.8545)
//        XCTAssertEqual(eventos[14].tipo, .chegada)
//        XCTAssertEqual(eventos[15].tempo, 4.2002)
//        XCTAssertEqual(eventos[15].tipo, .saida)
//        XCTAssertEqual(eventos[16].tempo, 2.8763)
//        XCTAssertEqual(eventos[16].tipo, .transicao)
        
        XCTAssertEqual(chegadas1.count, 5)
        XCTAssertEqual(saidas1.count, 6)
        XCTAssertEqual(proximaChegadas1.count, 3)
        XCTAssertEqual(proximaSaida1.count, 5)
        
        XCTAssertEqual(chegadas2.count, 6)
        XCTAssertEqual(saidas2.count, 1)
        XCTAssertEqual(proximaChegadas2.count, 0)
        XCTAssertEqual(proximaSaida2.count, 3)
        
        XCTAssertEqual(proximos.count, 15)
        XCTAssertEqual(filas.count, 2)
        XCTAssertEqual(eventos.count, 17)
        
        XCTAssertEqual(randoms.count, 17)
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
