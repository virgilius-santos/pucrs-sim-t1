
import Foundation

public class SimuladorSimples {
    
    let simulador: NovoSimulador
    
    public init(
        fila: Fila,
        random rnd: CongruenteLinear
    ) {
        
        simulador = .init(
            random: rnd,
            filas: [ fila, ]
        )
    }
    
    public func simular() {
        simulador.simular()
    }
}
