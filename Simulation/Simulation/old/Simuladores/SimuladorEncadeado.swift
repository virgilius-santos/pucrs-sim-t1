
import Foundation

public class SimuladorEncadeado {
    
    let simulador: NovoSimulador
    
    public init(
        filaDeEntrada: Fila,
        filaDeSaida: Fila,
        random rnd: CongruenteLinear,
        escalonador: Escalonador = Escalonador()
    ) {
        
        simulador = .init(
            semente: Config.CongruenteLinear.semente,
            maxIteracoes: rnd.maxIteracoes,
            valoresFixos: rnd.valoresFixos)
        
        qs = [
            
            // configuração da fila 1
            simulador.gerarFila(nome: "Q\(filaDeEntrada.id)",
                c: filaDeEntrada.kendall.c,
                k: filaDeEntrada.kendall.k,
                taxaEntrada: (filaDeEntrada.taxaEntrada.inicio, filaDeEntrada.taxaEntrada.fim),
                taxaSaida: (filaDeEntrada.taxaSaida.inicio, filaDeEntrada.taxaSaida.fim),
                transicoes: [ ("Q\(filaDeSaida.id)", 1) ]),
            
            // configuração da fila 2
            simulador.gerarFila(nome: "Q\(filaDeSaida.id)",
                c: filaDeSaida.kendall.c,
                k: filaDeSaida.kendall.k,
                taxaEntrada: (filaDeSaida.taxaEntrada.inicio, filaDeSaida.taxaEntrada.fim),
                taxaSaida: (filaDeSaida.taxaSaida.inicio, filaDeSaida.taxaSaida.fim)),
        ]
    }
    
    public func simular() {
        simulador.processar()
    }
}
