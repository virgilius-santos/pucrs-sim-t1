
import Foundation

public class SimuladorSimples: Simulador {
    public init(
        fila: Fila,
        random rnd: CongruenteLinear
    ) {
        super.init(
            random: rnd,
            filas: [fila]
        )
    }
}
