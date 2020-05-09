
import Foundation
import Simulation

func filaSimples() -> Simulador {
    print("\n\nFILA SIMPLES\n")
    let v = [1, 0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881]
    return SimuladorSimples(
        fila: Fila(nome: "Q1",
                   kendall: .init(c: 1, k: 3, n: v.count),
                   taxaEntrada: (inicio: 1, fim: 2),
                   taxaSaida: (inicio: 3, fim: 6)),
        random: .init(semente: 1, maxIteracoes: v.count, valoresFixos: v)
    )
}

func filaTandem() -> Simulador {
    print("\n\nFILA TANDEM\n")
    let v = [
        0.5, 0.9921, 0.0004, 0.5534, 0.2761, 0.3398, 0.8963, 0.9023, 0.0132,
        0.4569, 0.5121, 0.9208, 0.0171, 0.2299, 0.8545, 0.6001, 0.2921
    ]

    return SimuladorTandem(
        filaDeEntrada: Fila(nome: "Q1",
                            kendall: .init(c: 2, k: 3, n: v.count),
                            taxaEntrada: (inicio: 2, fim: 3),
                            taxaSaida: (inicio: 2, fim: 5),
                            transicoes: [("Q2", 1)]),
        filaDeSaida: Fila(nome: "Q2",
                          kendall: .init(c: 1, k: 3),
                          taxaSaida: (inicio: 3, fim: 5)),
        random: .init(semente: 1, maxIteracoes: v.count, valoresFixos: v)
    )
}

func filaRede() -> Simulador {
    print("\n\nFILA EM REDE\n")
    let maxIteracoes = 100_000
    return Simulador(
        random: .init(semente: 1, maxIteracoes: maxIteracoes, valoresFixos: []),
        filas: [
            Fila(nome: "Q1",
                 kendall: .init(c: 1, n: maxIteracoes),
                 taxaEntrada: (1, 4),
                 taxaSaida: (1, 1.5),
                 transicoes: [("Q2", 0.8), ("Q3", 0.2)]),

            Fila(nome: "Q2",
                 kendall: .init(c: 3, k: 5),
                 taxaSaida: (5, 10),
                 transicoes: [("Q1", 0.3), ("Q3", 0.5)]),

            Fila(nome: "Q3",
                 kendall: .init(c: 2, k: 8),
                 taxaSaida: (10, 20),
                 transicoes: [("Q2", 0.7)])
        ]
    )
}

filaSimples().simular()
filaTandem().simular()
filaRede().simular()
