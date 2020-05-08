
import Foundation
import Simulation

NovoSimulador(
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
).simular()
