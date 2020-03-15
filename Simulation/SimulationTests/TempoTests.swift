
import XCTest
@testable import Simulation

class TempoTests: XCTestCase {

    func testCalculoDeTempo() {
        // given: dado que um tempo é setado
        let sut = Tempo(inicio: 4, fim: 7)
        
        // when: um tempo eh requisitado
        let tempo = sut.tempo(uniformizado: 0.3)
        
        // then: o tempo deve ser retornar entre o valor inicial e final
        XCTAssertEqual(tempo, 4.9)
    }
}
