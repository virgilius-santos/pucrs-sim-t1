
import Foundation

private var _id: Int = -1

public class Fila {
    let taxaEntrada: Tempo
    let taxaSaida: Tempo
    let kendall: Kendall
    let random: CongruenteLinear
    let id: Int = {
        _id += 1
        return _id
    }()
    /// sera acionado sempre que um agendamento de saida for necessario
    var agendarSaida: (ActionVoid)?
    
    /// proxima saida que ocorrerá na fila
    var proximaSaida: Double {
        taxaSaida.tempo(uniformizado: random.uniformizado)
    }
    
    /// proxima chegada que ocorrerá na fila
    var proximaChegada: Double {
        taxaEntrada.tempo(uniformizado: random.uniformizado)
    }
    
    /// verifica se pode ocorrer mais um evento de chegada
    var temProximoEventoDeChegada: Bool { iteracoes < kendall.n }
    
    /// guarda as informações da fila em relcao ao ultimo tempo passado,
    /// seja na entrada ou saida
    let dados: GerenciadorEstatisticas
    
    /// quantidade de elementos na fila
    private(set) var quantDaFila: Int = .zero
    
    /// quantidade de perdas da fila
    private(set) var perdas: Int = .zero
    
    /// quantidade de chegadas que a fila recebeu
    private(set) var iteracoes: Int = .zero
    
    public init(taxaEntrada: Tempo, taxaSaida: Tempo, kendall: Kendall, random: CongruenteLinear) {
        self.taxaEntrada = taxaEntrada
        self.taxaSaida = taxaSaida
        self.kendall = kendall
        self.random = random
        self.dados = .init(id: id, capacidade: kendall.k)
    }
    
    /// aciona um evento de chegada na fila, disparando um ag de saida qdo necessario
    func chegada(tempo: Double) {
        iteracoes += 1
        
        updateEstatisticas(evt: .chegada, tempo: tempo)
        
        guard quantDaFila < kendall.k else {
            perdas += 1
            return
        }
        
        quantDaFila += 1
        if quantDaFila <= kendall.c {
            agendarSaida?()
        }
    }
    
    /// aciona um evento de saida na fila, disparando um ag de saida qdo necessario
    func saida(tempo: Double) {
        guard quantDaFila > 0 else {
            return
        }
        
        updateEstatisticas(evt: .saida, tempo: tempo)
        
        quantDaFila -= 1
        if quantDaFila >= kendall.c, let agendarSaida = agendarSaida {
            agendarSaida()
        }
    }
    
    /// atualiza as estatisticas de acordo com o tipo e tempo recebido
    /// o tempo é incrementado no indice de acordo com a quantidade de pessoal na fila
    /// p.ex. se a fila esta vazia, o arrray na posicao 0 terá o tempo incrementado
    /// p.ex. se tem uma pessoa na fila esta vazia, o arrray na posicao 1 terá o tempo incrementado
    func updateEstatisticas(evt: Evento.Tipo, tempo: Double) {
        dados.updateEstatisticas(
            evt: evt,
            tempo: tempo,
            quantDaFila: quantDaFila,
            perdas: perdas)
    }
}
