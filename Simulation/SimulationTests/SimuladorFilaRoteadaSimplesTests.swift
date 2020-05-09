
@testable import Simulation
import XCTest

class SimuladorFilaRoteadaSimplesTests: XCTestCase {
    var sut: NovoSimulador!
    var valoresFixos: [Double]!
    var randomSpy: CongruenteLinear!
    var filaSpy1: Fila!
    var filaSpy2: Fila!

    override func setUp() {
        valoresFixos = [
            1, 0.2176, 0.0103, 0.1109, 0.3456, 0.9910, 0.2323, 0.9211, 0.0322,
            0.1211, 0.5131, 0.7208, 0.9172, 0.9922, 0.8324, 0.5011, 0.2931
        ]

        randomSpy = .init(
            maxIteracoes: valoresFixos.count,
            valoresFixos: valoresFixos
        )

        filaSpy1 = .init(nome: "Q1",
                         c: 2,
                         k: 4,
                         taxaEntrada: (inicio: 2, fim: 3),
                         taxaSaida: (inicio: 4, fim: 7),
                         transicoes: [ ("Q2", 0.7) ])

        filaSpy2 = .init(nome: "Q2",
                         c: 1,
                         taxaSaida: (inicio: 4, fim: 8))
    }

    override func tearDown() {
        sut = nil
        valoresFixos = nil
        randomSpy = nil
        filaSpy1 = nil
        filaSpy2 = nil
    }

    func test_NovoSimulador() {
        NovoSimulador(random: .init(semente: 1, maxIteracoes: 100000),
                      filas: [
                        Fila(nome: "Q1",
                             c: 1,
                             taxaEntrada: (1, 4),
                             taxaSaida: (1, 1.5),
                             transicoes: [ ("Q2", 0.8), ("Q3", 0.2) ]),

                        Fila(nome: "Q2",
                             c: 3,
                             k: 5,
                             taxaSaida: (5, 10),
                             transicoes: [ ("Q1", 0.3), ("Q3", 0.5) ]),

                        Fila(nome: "Q3",
                             c: 2,
                             k: 8,
                             taxaSaida: (10, 20),
                             transicoes: [ ("Q2", 0.7) ]),
                      ])

            .simular()
        XCTAssertEqual(Config.CongruenteLinear.semente, 1)

        XCTAssertEqual(filas[0].contador[0], 14293.9554, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[1], 20750.3363, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[2], 4814.4276, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[3], 456.7931, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[4], 23.8438, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[5], 0.3625, accuracy: 0.0001)
        XCTAssertEqual(filas[0].perdas, 0)

        XCTAssertEqual(filas[1].contador[0], 37.2795, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[1], 351.3668, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[2], 2298.9544, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[3], 8182.9876, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[4], 15442.3387, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[5], 14026.7916, accuracy: 0.0001)
        XCTAssertEqual(filas[1].perdas, 4830)

        XCTAssertEqual(filas[2].contador[0], 15.0888, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[1], 1.9752, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[2], 1.1781, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[3], 8.0773, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[4], 34.5039, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[5], 150.5435, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[6], 2835.8364, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[7], 12830.8987, accuracy: 0.0001)
        XCTAssertEqual(filas[2].contador[8], 24461.6167, accuracy: 0.0001)
        XCTAssertEqual(filas[2].perdas, 6570)

        XCTAssertEqual(T, 40339.72, accuracy: 0.01)
    }

    func test_filaRede_loopCompleto() {
        setupFilaRede()

        XCTAssertEqual(filas[0].perdas, 0)
        XCTAssertEqual(filas[1].perdas, 0)

        XCTAssertEqual(sut.processados[0].t, 3)
        XCTAssertEqual(sut.processados[0].tipo, .chegada)
        XCTAssertEqual(sut.processados[0].i, 0)
        XCTAssertEqual(sut.processados[1].t, 5.1109)
        XCTAssertEqual(sut.processados[1].tipo, .chegada)
        XCTAssertEqual(sut.processados[1].i, 2)
        XCTAssertEqual(sut.processados[2].t, 7.0309)
        XCTAssertEqual(sut.processados[2].tipo, .transicao)
        XCTAssertEqual(sut.processados[2].i, 1)
        XCTAssertEqual(sut.processados[3].t, 7.3432, accuracy: 0.0001)
        XCTAssertEqual(sut.processados[3].tipo, .chegada)
        XCTAssertEqual(sut.processados[3].i, 4)
        XCTAssertEqual(sut.processados[4].t, 9.8563)
        XCTAssertEqual(sut.processados[4].tipo, .chegada)
        XCTAssertEqual(sut.processados[4].i, 7)
        XCTAssertEqual(sut.processados[5].t, 11.7065, accuracy: 0.0001)
        XCTAssertEqual(sut.processados[5].tipo, .transicao)
        XCTAssertEqual(sut.processados[5].i, 6)
        XCTAssertEqual(sut.processados[6].t, 12.0839)
        XCTAssertEqual(sut.processados[6].tipo, .transicao)
        XCTAssertEqual(sut.processados[6].i, 3)
        XCTAssertEqual(sut.processados[7].t, 12.5771)
        XCTAssertEqual(sut.processados[7].tipo, .chegada)
        XCTAssertEqual(sut.processados[7].i, 8)

        XCTAssertEqual(sut.eventos[0].t, 18.6831, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[0].tipo, .saida)
        XCTAssertEqual(sut.eventos[0].i, 9)
        XCTAssertEqual(sut.eventos[1].t, 18.0804, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[1].tipo, .saida)
        XCTAssertEqual(sut.eventos[1].i, 10)
        XCTAssertEqual(sut.eventos[2].t, 14.8702, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[2].tipo, .chegada)
        XCTAssertEqual(sut.eventos[2].i, 11)
        XCTAssertEqual(sut.eventos[3].t, 14.7153, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[3].tipo, .saida)
        XCTAssertEqual(sut.eventos[3].i, 5)

        XCTAssertEqual(T, 12.5771)
    }

    func setupFilaRede() {
        sut = .init(random: randomSpy,
                    filas: [ filaSpy1, filaSpy2, ] )

        sut.simular()
    }
}
