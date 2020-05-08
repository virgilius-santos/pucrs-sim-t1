
import Foundation
import Simulation

func filaSimples() -> NovoSimulador {
    print("\n\nFILA SIMPLES\n")
    let v = [1, 0.3276, 0.8851, 0.1643, 0.5542, 0.6813, 0.7221, 0.9881]
    return NovoSimulador(
        random: .init(semente: 1, maxIteracoes: v.count, valoresFixos: v),
        filas: [
            Fila(nome: "Q1",
                 c: 1,
                 k: 3,
                 taxaEntrada: (inicio: 1, fim: 2),
                 taxaSaida: (inicio: 3, fim: 6)),
        ]
    )
    
}

func filaTandem() -> NovoSimulador {
    
    print("\n\nFILA TANDEM\n")
    let v = [
        0.5, 0.9921, 0.0004, 0.5534, 0.2761 , 0.3398, 0.8963, 0.9023, 0.0132,
        0.4569, 0.5121, 0.9208, 0.0171, 0.2299, 0.8545, 0.6001, 0.2921
    ]
    
    return NovoSimulador(
        random: .init(semente: 1, maxIteracoes: v.count, valoresFixos: v),
        filas: [
            Fila(nome: "Q1",
                 c: 2,
                 k: 3,
                 taxaEntrada: (inicio: 2, fim: 3),
                 taxaSaida: (inicio: 2, fim: 5),
                 transicoes: [ ("Q2", 1) ]),
            
            Fila(nome: "Q2",
                 c: 1,
                 k: 3,
                 taxaSaida: (inicio: 3, fim: 5))
        ]
    )
    
}

func filaRede() -> NovoSimulador {
    print("\n\nFILA EM REDE\n")
    return NovoSimulador(
        random: .init(semente: 1, maxIteracoes: 100000, valoresFixos: []),
        filas: [
            Fila(nome: "Q1",
                 c: 1,
                 taxaEntrada: (1, 4),
                 taxaSaida: (1, 1.5),
                 transicoes: [ ("Q2", 0.8), ("Q3", 0.2) ]),
            
            Fila(nome: "Q2",
                 c: 3,
                 k: 5,
                 taxaSaida: (5, 10),
                 transicoes: [ ("Q1", 0.3), ("Q3", 0.5) ]),
            
            Fila(nome: "Q3",
                 c: 2,
                 k: 8,
                 taxaSaida: (10, 20),
                 transicoes: [ ("Q2", 0.7) ]),
        ]
    )
}

filaSimples().simular()
filaTandem().simular()
filaRede().simular()
