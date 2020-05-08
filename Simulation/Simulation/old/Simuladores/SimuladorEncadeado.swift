
import Foundation

public class SimuladorEncadeado {
    
    let simulador: Simulador
    
    public init(
        filaDeEntrada: Fila,
         filaDeSaida: Fila,
         random: CongruenteLinear,
         escalonador: Escalonador = Escalonador()
    ) {
        
        simulador = Simulador(
            configDeEventos: [
                
                // gera a primeira chegada no escalonador
                .chegada(fila: filaDeEntrada),
                
                // configurar a saida da fila de entrada
                // configurar a chegada da fila de saida
                .transicao(origem: filaDeEntrada,
                           destino: filaDeSaida),
                
                // configurar a saida da fila
                .saida(fila: filaDeSaida),
                
            ],
            random: random,
            escalonador: escalonador)
    }
    
    public func simular() {
        simulador.simular()
    }
}
