
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
        sut = .init()
        
        //when: o primeiro valoe
        let valor = sut.valor
        let normalizado = sut.uniformizado
        
        let primeiroCalculo: UInt = 7623276
        let segundoCalculo: Double = 0.028678834438323975
        
        //then: deve retornar o valor usando a semente
        XCTAssertEqual(valor, primeiroCalculo)
        
        //then: deve retornar o valor normalizado
        XCTAssertEqual(normalizado, segundoCalculo)
    }
    
    func testSecondCalc() {
        //given: inicializado
        sut = .init()

        //when: o proximo é chamado
        let valor0 = sut.valor
        let valor1 = sut.valor
        let valor2 = sut.valor
        
        let uniformizado0 = sut.uniformizado
        let uniformizado1 = sut.uniformizado
        let uniformizado2 = sut.uniformizado
        
        
        //then: deve retornar valores diferentes
        XCTAssertNotEqual(valor0, valor1)
        XCTAssertNotEqual(valor0, valor2)
        XCTAssertNotEqual(valor1, valor2)
        
        XCTAssertNotEqual(uniformizado0, uniformizado1)
        XCTAssertNotEqual(uniformizado0, uniformizado2)
        XCTAssertNotEqual(uniformizado1, uniformizado2)
    }
}
