
import XCTest
@testable import Simulation

class ConfigTests: XCTestCase {

    func testParse() {
        let filaDummy = Fila(tipoDeFila: TipoDeFila.simples)
        
        let array: [Fila] = [
            Config.Evento.chegada(fila: filaDummy).filas,
            Config.Evento.saida(fila: filaDummy).filas,
            Config.Evento.transicao(origem: filaDummy, destino: filaDummy).filas,
            Config.Evento.transicaoPonderada(origem: filaDummy, destino: filaDummy, taxa: 0).filas,
            Config.Evento.transicaoPonderadaComRetorno(origem: filaDummy, destino: filaDummy, saida: 0, retorno: 0).filas,
            
            Config.Evento.transicaoRede(origem: filaDummy, destinos: [(filaDummy, 0), (filaDummy, 0)]).filas,
            ]
            .flatMap { $0 }
        
        XCTAssertEqual(array.count, 11)
        XCTAssertEqual(Set<Fila>(array).count, 1)
    }
}
