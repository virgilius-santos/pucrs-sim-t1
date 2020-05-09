
import Foundation

public class SimuladorEncadeado {
    let simulador: NovoSimulador

    public init(
        filaDeEntrada: Fila,
        filaDeSaida: Fila,
        random rnd: CongruenteLinear
    ) {
        simulador = .init(
            random: rnd,
            filas: [ filaDeEntrada, filaDeSaida, ]
        )
    }
}
