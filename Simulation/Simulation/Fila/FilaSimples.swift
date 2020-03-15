
import Foundation

public class FilaSimples: Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    let filaSimples: Fila
    
    public init(fila: Fila,
         random: CongruenteLinear,
         escalonador: Escalonador = Escalonador()) {
        filaSimples = fila
        self.random = random
        self.escalonador = escalonador
    }
    
    public func simular() -> [Estatistica] {
        
        configurar(agendamentos: [
            
            // gera a primeira chegada no escalonador
            .chegada(fila: filaSimples),
            
            // configurar a saida da fila
            .saida(fila: filaSimples),
        ])
        
        // roda a simulacao
        rodarSimulacaoCompleta()
        
        return filaSimples.dados.estatisticas
    }
}
