
import Foundation

public enum TipoDeFila: String {
    case simples, tandem, naoDefinida, rede
}

public class Fila {
    
    let id: Int
    
    /// sera acionado sempre que um agendamento de saida for necessario
    var agendarSaida: (ActionVoid)?
    
    /// guarda as informações da fila em relcao ao ultimo tempo passado,
    /// seja na entrada ou saida
    private(set) lazy var dados: GerenciadorEstatisticas = .init(id: id)
    
    /// quantidade de elementos na fila
    private(set) var quantDaFila: Int = .zero
    
    /// quantidade de perdas da fila
    var perdas: Int = .zero
    
    let tipoDeFila: TipoDeFila
    var primeiroTempo: Double?
    
    let taxaEntrada: Tempo
    let taxaSaida: Tempo
    let kendall: Kendall
    
    public init(id: Int,
                tipoDeFila: TipoDeFila,
                taxaEntrada: Tempo = .init(inicio: 0, fim: 0),
                taxaSaida: Tempo,
                kendall: Kendall) {
        self.id = id
        self.taxaEntrada = taxaEntrada
        self.taxaSaida = taxaSaida
        self.kendall = kendall
        self.tipoDeFila = tipoDeFila
    }
    
    init(id: Int = 0,
         tipoDeFila: TipoDeFila = .naoDefinida,
         taxaEntrada: Tempo = .init(inicio: 0, fim: 0),
         taxaSaida: Tempo = .init(inicio: 0, fim: 0),
         kendall: Kendall = .init(),
         dados: GerenciadorEstatisticas? = nil) {
        self.id = id
        self.taxaEntrada = taxaEntrada
        self.taxaSaida = taxaSaida
        self.kendall = kendall
        self.tipoDeFila = tipoDeFila
        if let dados = dados {
            self.dados = dados
        }
    }
    
    /// proxima saida que ocorrerá na fila
    func proximaSaida(randomUniformizado: Double) -> Double {
        taxaSaida.tempo(uniformizado: randomUniformizado)
    }
    
    /// proxima chegada que ocorrerá na fila
    func proximaChegada(randomUniformizado: Double) -> Double {
        taxaEntrada.tempo(uniformizado: randomUniformizado)
    }
    
    /// aciona um evento de chegada na fila, disparando um ag de saida qdo necessario
    func chegada(tempo: Double) {
        if primeiroTempo == nil {
            primeiroTempo = tempo
        }
        
        let quantAnteriorDaFila: Int = quantDaFila
        
        guard quantDaFila < kendall.k else {
            perdas += 1
            updateEstatisticas(evt: .chegada, tempo: tempo, quantAnteriorDaFila: quantAnteriorDaFila)
            return
        }
        
        quantDaFila += 1
        if quantDaFila <= kendall.c {
            agendarSaida?()
        }
        
        updateEstatisticas(evt: .chegada, tempo: tempo, quantAnteriorDaFila: quantAnteriorDaFila)
    }
    
    /// aciona um evento de saida na fila, disparando um ag de saida qdo necessario
    func saida(tempo: Double) {
        guard quantDaFila > 0 else {
            return
        }
        
        let quantAnteriorDaFila: Int = quantDaFila
        
        quantDaFila -= 1
        if quantDaFila >= kendall.c, let agendarSaida = agendarSaida {
            agendarSaida()
        }
        
        updateEstatisticas(evt: .saida, tempo: tempo, quantAnteriorDaFila: quantAnteriorDaFila)
    }
    
    /// atualiza as estatisticas de acordo com o tipo e tempo recebido
    /// o tempo é incrementado no indice de acordo com a quantidade de pessoal na fila
    /// p.ex. se a fila esta vazia, o arrray na posicao 0 terá o tempo incrementado
    /// p.ex. se tem uma pessoa na fila esta vazia, o arrray na posicao 1 terá o tempo incrementado
    private func updateEstatisticas(evt: Evento.Tipo, tempo: Double, quantAnteriorDaFila: Int) {
        dados.updateEstatisticas(
            evt: evt,
            tempo: tempo,
            quantAnteriorDaFila: quantAnteriorDaFila,
            quantDaFila: quantDaFila,
            perdas: perdas)
    }
}

extension Fila: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Fila, rhs: Fila) -> Bool {
        lhs.id == rhs.id
    }
}
