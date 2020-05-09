
import Foundation

func imprimir() {
    func formatCont(_ contador: [Double]) -> String {
        let total = contador.reduce(0, +)
        return contador
            .enumerated()
            .reduce("") { $0 + "\t" + "\($1.offset.format(4))"
                + "\t" + "\($1.element.format(f: 10, 4))"
                + "\t\t\t\(($1.element * 100 / total).format(f: 3, 2))\n"
            }
    }

    func imprimir(q: Fila) {
        print(
            """
            *******************
            Fila:   \(q.nome) (G/G/\(q.c)\(q.k == .max ? "" : "/\(q.k)")
            Arrival: \(q.taxaEntrada.inicio.format(2, p: 2)) ... \(q.taxaEntrada.fim.format(2, p: 2))
            Service: \(q.taxaSaida.inicio.format(2, p: 2)) ... \(q.taxaSaida.fim.format(2, p: 2))
            *******************
            State           Time             Probability
            \(formatCont(q.contador))

            Number of losses: \(q.perdas)

            *******************

            """
        )
    }

    print(
        """
        =========================================================
        ===============    REPORT (semente: \(Config.CongruenteLinear.semente))   ======================
        =========================================================
        """
    )
    filas.forEach { imprimir(q: $0) }

    print("Simulation average time: \(T.format(f: 6, 2, p: 7))")

    print("=========================================================")
}
