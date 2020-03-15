
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
            agendamentos: [
                
                // gera a primeira chegada no escalonador
                .chegada(fila: filaDeEntrada),
                
                // configurar a saida da fila de entrada
                // configurar a chegada da fila de saida
                .transicao(entrada: filaDeEntrada,
                           saida: filaDeSaida),
                
                // configurar a saida da fila
                .saida(fila: filaDeSaida),
                
            ],
            random: random,
            escalonador: escalonador)
    }
    
    public func simular() -> [Estatistica] {
        return simulador.simular()
    }
    
    public func imprimir(estatisticas: [Estatistica]) {
        simulador.imprimir(estatisticas: estatisticas)
    }
}
