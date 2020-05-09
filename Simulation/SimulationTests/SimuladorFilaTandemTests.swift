
@testable import Simulation
import XCTest

class SimuladorFilaTandemTests: XCTestCase {
    var sut: NovoSimulador!
    var valoresFixos: [Double]!
    var kendall: Kendall!
    var randomSpy: CongruenteLinear!
    var filaSpy1: Fila!
    var filaSpy2: Fila!

    override func setUp() {
        valoresFixos = [
            0.5, 0.9921, 0.0004, 0.5534, 0.2761, 0.3398, 0.8963, 0.9023, 0.0132,
            0.4569, 0.5121, 0.9208, 0.0171, 0.2299, 0.8545, 0.6001, 0.2921
        ]

        kendall = Kendall(c: 2, k: 3, n: valoresFixos.count)

        randomSpy = .init(
            maxIteracoes: kendall.n,
            valoresFixos: valoresFixos
        )

        filaSpy1 = .init(nome: "Q1",
                         c: kendall.c,
                         k: kendall.k,
                         taxaEntrada: (inicio: 2, fim: 3),
                         taxaSaida: (inicio: 2, fim: 5),
                         transicoes: [("Q2", 1)])

        filaSpy2 = .init(nome: "Q2",
                         c: 1,
                         k: 3,
                         taxaSaida: (inicio: 3, fim: 5))
    }

    override func tearDown() {
        sut = nil
        valoresFixos = nil
        kendall = nil
        randomSpy = nil
        filaSpy1 = nil
        filaSpy2 = nil
    }

    func test_filaTandem_loopCompleto() {
        setupFilaTandem()

        XCTAssertEqual(filas[0].contador[0], 2.6648, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[1], 7.7764, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[2], 6.2075, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[3], 0.6998, accuracy: 0.0001)
        XCTAssertEqual(filas[0].perdas, 0)
        XCTAssertEqual(filas[1].contador[0], 7.4763, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[1], 0.6843, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[2], 7.6925, accuracy: 0.0001)
        XCTAssertEqual(filas[1].contador[3], 1.4954, accuracy: 0.0001)
        XCTAssertEqual(filas[1].perdas, 1)

        XCTAssertEqual(sut.processados[0].t, 2.5)
        XCTAssertEqual(sut.processados[0].tipo, .chegada)
        XCTAssertEqual(sut.processados[0].i, 0)
        XCTAssertEqual(sut.processados[1].t, 4.5004)
        XCTAssertEqual(sut.processados[1].tipo, .chegada)
        XCTAssertEqual(sut.processados[1].i, 2)
        XCTAssertEqual(sut.processados[2].t, 6.7765)
        XCTAssertEqual(sut.processados[2].tipo, .chegada)
        XCTAssertEqual(sut.processados[2].i, 4)
        XCTAssertEqual(sut.processados[3].t, 7.4763)
        XCTAssertEqual(sut.processados[3].tipo, .transicao)
        XCTAssertEqual(sut.processados[3].i, 1)
        XCTAssertEqual(sut.processados[4].t, 8.1606)
        XCTAssertEqual(sut.processados[4].tipo, .transicao)
        XCTAssertEqual(sut.processados[4].i, 3)
        XCTAssertEqual(sut.processados[5].t, 9.1163)
        XCTAssertEqual(sut.processados[5].tipo, .chegada)
        XCTAssertEqual(sut.processados[5].i, 5)
        XCTAssertEqual(sut.processados[6].t, 11.1559)
        XCTAssertEqual(sut.processados[6].tipo, .transicao)
        XCTAssertEqual(sut.processados[6].i, 8)
        XCTAssertEqual(sut.processados[7].t, 11.5732)
        XCTAssertEqual(sut.processados[7].tipo, .chegada)
        XCTAssertEqual(sut.processados[7].i, 9)
        XCTAssertEqual(sut.processados[8].t, 12.1652)
        XCTAssertEqual(sut.processados[8].tipo, .transicao)
        XCTAssertEqual(sut.processados[8].i, 6)
        XCTAssertEqual(sut.processados[9].t, 12.2809, accuracy: 0.0001)
        XCTAssertEqual(sut.processados[9].tipo, .saida)
        XCTAssertEqual(sut.processados[9].i, 7)
        XCTAssertEqual(sut.processados[10].t, 14.494)
        XCTAssertEqual(sut.processados[10].tipo, .chegada)
        XCTAssertEqual(sut.processados[10].i, 11)
        XCTAssertEqual(sut.processados[11].t, 15.1095)
        XCTAssertEqual(sut.processados[11].tipo, .transicao)
        XCTAssertEqual(sut.processados[11].i, 10)
        XCTAssertEqual(sut.processados[12].t, 15.3151)
        XCTAssertEqual(sut.processados[12].tipo, .saida)
        XCTAssertEqual(sut.processados[12].i, 12)
        XCTAssertEqual(sut.processados[13].t, 17.1837)
        XCTAssertEqual(sut.processados[13].tipo, .transicao)
        XCTAssertEqual(sut.processados[13].i, 13)
        XCTAssertEqual(sut.processados[14].t, 17.3485)
        XCTAssertEqual(sut.processados[14].tipo, .chegada)
        XCTAssertEqual(sut.processados[14].i, 14)

        XCTAssertEqual(sut.eventos[0].t, 20.2248, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[0].i, 16)
        XCTAssertEqual(sut.eventos[0].tipo, .transicao)
        XCTAssertEqual(sut.eventos[1].t, 19.5153, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[1].i, 15)
        XCTAssertEqual(sut.eventos[1].tipo, .saida)

        XCTAssertEqual(T, 17.3485)
    }

    func setupFilaTandem() {
        sut = SimuladorEncadeado(filaDeEntrada: filaSpy1,
                                 filaDeSaida: filaSpy2,
                                 random: randomSpy)
            .simulador

        sut.simular()
    }
}
