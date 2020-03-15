
import Foundation

public class FilaEncadeadaPonderada: Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    let filaDeEntrada: Fila
    let filaDeSaida: Fila
    let taxaDeSaida: Double
    
    public init(filaDeEntrada: Fila,
                filaDeSaida: Fila,
                random: CongruenteLinear,
                taxaDeSaida: Double,
                escalonador: Escalonador = Escalonador()) {
        self.filaDeEntrada = filaDeEntrada
        self.filaDeSaida = filaDeSaida
        self.random = random
        self.escalonador = escalonador
        self.taxaDeSaida = taxaDeSaida
    }
    
    public func simular() -> [Estatistica] {
        
        configurar(agendamentos: [
            
            // gera a primeira chegada no escalonador
            .chegada(fila: filaDeEntrada),
            
            // configurar a saida da fila de entrada
            // configurar a chegada da fila de saida
            .transicaoPonderada(entrada: filaDeEntrada,
                                saida: filaDeSaida,
                                taxa: taxaDeSaida),
            
            // configurar a saida da fila
            .saida(fila: filaDeSaida),
        ])
        
        // roda a simulacao
        rodarSimulacaoCompleta()
        
        return filaDeEntrada.dados.estatisticas + filaDeSaida.dados.estatisticas
    }
}
