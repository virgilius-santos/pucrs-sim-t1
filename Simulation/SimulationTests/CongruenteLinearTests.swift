
import XCTest
@testable import Simulation

class CongruenteLinearTests: XCTestCase {

    var sut: CongruenteLinear!
    
    let a = Config.CongruenteLinear.a
    let c = Config.CongruenteLinear.c
    let M = Config.CongruenteLinear.M
    let semente = Config.CongruenteLinear.semente
    
    func testFisrtCalc() {
        //given: inicializado
        sut = CongruenteLinear(maxIteracoes: 20)
        
        //when: o primeiro valoe
        let valor = sut.uniformizado()
        let normalizado = sut.uniformizado()
        
        let primeiroCalculo: Double = 0.45438265800476074
        let segundoCalculo: Double = 0.028678834438323975
        
        //then: deve retornar o valor usando a semente
        XCTAssertEqual(valor, primeiroCalculo)
        
        //then: deve retornar o valor normalizado
        XCTAssertEqual(normalizado, segundoCalculo)
    }
    
    func testSecondCalc() {
        //given: inicializado
        sut = .init(maxIteracoes: 20)

        //when: o proximo é chamado
        let uniformizado0 = sut.uniformizado()
        let uniformizado1 = sut.uniformizado()
        let uniformizado2 = sut.uniformizado()
        
        
        //then: deve retornar valores diferentes
        XCTAssertNotEqual(uniformizado0, uniformizado1)
        XCTAssertNotEqual(uniformizado0, uniformizado2)
        XCTAssertNotEqual(uniformizado1, uniformizado2)
    }
    
    func testRetornarValores() {
        //given: inicializado
        sut = .init(maxIteracoes: 3, valoresFixos: [0.1, 0.2])
        
        //when: o proximo é chamado
        let uniformizados: [Double?] = [
            sut.uniformizado(),
            sut.uniformizado(),
            sut.uniformizado(),
            sut.uniformizado(),
        ]
        
        let primeiroCalculo: Double = 0.45438265800476074
        
        //then: deve retornar valores diferentes
        XCTAssertEqual(uniformizados[0], 0.1)
        XCTAssertEqual(uniformizados[1], 0.2)
        XCTAssertEqual(uniformizados[2], primeiroCalculo)
        XCTAssertNil(uniformizados[3])
    }
}
