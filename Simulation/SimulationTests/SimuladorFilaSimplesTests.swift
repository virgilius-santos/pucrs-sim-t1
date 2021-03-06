
@testable import Simulation
import XCTest

class SimuladorFilaSimplesTests: XCTestCase {
    var sut: Simulador!
    var valoresFixos: [Double]!
    var randomSpy: CongruenteLinear!
    var filaSpy1: Fila!

    override func setUp() {
        valoresFixos = [1, 0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881]

        randomSpy = .init(
            maxIteracoes: valoresFixos.count,
            valoresFixos: valoresFixos
        )

        filaSpy1 = .init(nome: "Q1",
                         kendall: .init(c: 1, k: 3, n: valoresFixos.count),
                         taxaEntrada: (inicio: 1, fim: 2),
                         taxaSaida: (inicio: 3, fim: 6))

        sut = SimuladorSimples(fila: filaSpy1,
                               random: randomSpy)

        sut.simular()
    }

    override func tearDown() {
        sut = nil
        valoresFixos = nil
        randomSpy = nil
        filaSpy1 = nil
    }

    func test_filaSimples_loopCompleto() {
        XCTAssertEqual(sut.processados[0].t, 2.0)
        XCTAssertEqual(sut.processados[0].i, 0)
        XCTAssertEqual(sut.processados[0].tipo, .chegada)
        XCTAssertEqual(sut.processados[1].t, 3.8851)
        XCTAssertEqual(sut.processados[1].i, 2)
        XCTAssertEqual(sut.processados[1].tipo, .chegada)
        XCTAssertEqual(sut.processados[2].t, 5.0494)
        XCTAssertEqual(sut.processados[2].i, 3)
        XCTAssertEqual(sut.processados[2].tipo, .chegada)
        XCTAssertEqual(sut.processados[3].t, 5.9828)
        XCTAssertEqual(sut.processados[3].i, 1)
        XCTAssertEqual(sut.processados[3].tipo, .saida)
        XCTAssertEqual(sut.processados[4].t, 6.6036)
        XCTAssertEqual(sut.processados[4].i, 4)
        XCTAssertEqual(sut.processados[4].tipo, .chegada)
        XCTAssertEqual(sut.processados[5].t, 8.3257)
        XCTAssertEqual(sut.processados[5].i, 6)
        XCTAssertEqual(sut.processados[5].tipo, .chegada)

        XCTAssertEqual(sut.eventos[0].t, 11.0267)
        XCTAssertEqual(sut.eventos[0].i, 5)
        XCTAssertEqual(sut.eventos[0].tipo, .saida)
        XCTAssertEqual(sut.eventos[1].t, 10.3138, accuracy: 0.0001)
        XCTAssertEqual(sut.eventos[1].i, 7)
        XCTAssertEqual(sut.eventos[1].tipo, .chegada)

        let filas = sut.filas
        XCTAssertEqual(filas[0].contador[0], 2, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[1], 1.8851, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[2], 1.7851, accuracy: 0.0001)
        XCTAssertEqual(filas[0].contador[3], 2.6555, accuracy: 0.0001)
        XCTAssertEqual(filas[0].perdas, 1)

        let T = sut.T
        XCTAssertEqual(T, 8.3257)
    }
}
