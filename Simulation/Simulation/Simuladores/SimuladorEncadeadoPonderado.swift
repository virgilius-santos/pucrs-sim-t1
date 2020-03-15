
import Foundation

public class SimuladorEncadeadoPonderado {
    
    let simulador: Simulador
    
    public init(filaDeEntrada: Fila,
                filaDeSaida: Fila,
                random: CongruenteLinear,
                taxaDeSaida: Double,
                escalonador: Escalonador = Escalonador()) {
        
        simulador = Simulador(
            agendamentos: [
                
                // gera a primeira chegada no escalonador
                .chegada(fila: filaDeEntrada),
                
                // configurar a saida da fila de entrada
                // configurar a chegada da fila de saida
                .transicaoPonderada(entrada: filaDeEntrada,
                                    saida: filaDeSaida,
                                    taxa: taxaDeSaida),
                
                // configurar a saida da fila
                .saida(fila: filaDeSaida),
                
            ],
            random: random,
            escalonador: escalonador)
    }
    
    public func simular() -> [Estatistica] {
        return simulador.simular()
    }
}
