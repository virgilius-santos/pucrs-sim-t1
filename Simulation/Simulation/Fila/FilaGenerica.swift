
import Foundation

public class FilaGenerica: Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    let agendamentos: [Agendamento]
    
    public init(agendamentos: [Agendamento],
                random: CongruenteLinear,
                escalonador: Escalonador = Escalonador()) {
        self.agendamentos = agendamentos
        self.random = random
        self.escalonador = escalonador
    }
    
    public func simular() -> [Estatistica] {
        
        configurar(agendamentos: agendamentos)
        
        // roda a simulacao
        rodarSimulacaoCompleta()
        
        return agendamentos.flatMap { $0.estatisticas }
    }
}

