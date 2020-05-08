
import Foundation

public class SimuladorSimples {
    
    let simulador: NovoSimulador
    
    public init(
        fila: Fila,
        random rnd: CongruenteLinear,
        escalonador: Escalonador = Escalonador()
    ) {
        
        simulador = .init(
            semente: Config.CongruenteLinear.semente,
            maxIteracoes: rnd.maxIteracoes,
            valoresFixos: rnd.valoresFixos)
        
        qs = [
            
            // configuração da fila 3
            simulador.gerarFila(nome: "Q\(fila.id)",
                                c: fila.kendall.c,
                                k: fila.kendall.k,
                                taxaEntrada: (fila.taxaEntrada.inicio, fila.taxaEntrada.fim),
                                taxaSaida: (fila.taxaSaida.inicio, fila.taxaSaida.fim)),
        ]
    }
    
    public func simular() {
        simulador.processar()
    }
}
