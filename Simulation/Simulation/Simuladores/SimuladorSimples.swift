
import Foundation

public class SimuladorSimples {
    
    let simulador: Simulador
    
    public init(
        fila: Fila,
        random: CongruenteLinear,
        escalonador: Escalonador = Escalonador()
    ) {
        
        simulador = Simulador(
            configDeEventos: [
                
                // gera a primeira chegada no escalonador
                .chegada(fila: fila),
                
                // configurar a saida da fila
                .saida(fila: fila),
                
            ],
            random: random,
            escalonador: escalonador)
    }
    
    public func simular() -> [GerenciadorEstatisticas] {
        return simulador.simular()
    }
}
