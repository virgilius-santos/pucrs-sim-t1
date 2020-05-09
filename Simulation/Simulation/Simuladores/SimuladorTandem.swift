
import Foundation

public class SimuladorTandem: Simulador {
    public init(
        filaDeEntrada: Fila,
        filaDeSaida: Fila,
        random rnd: CongruenteLinear
    ) {
        super.init(
            random: rnd,
            filas: [filaDeEntrada, filaDeSaida]
        )
    }
}
