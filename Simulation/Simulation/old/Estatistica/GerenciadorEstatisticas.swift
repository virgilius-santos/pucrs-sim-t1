
import Foundation

private var estatisticasGerais = [Int: GerenciadorEstatisticas]()

public class GerenciadorEstatisticas {
    
    /// guarda as informações da fila em relcao ao ultimo tempo passado,
    /// seja na entrada ou saida
    private(set) var estatisticaAtual: Estatistica {
        didSet {
            estatisticas.append(estatisticaAtual)
        }
    }
    
    /// conjunto de todas as estatisticas
    private(set) var estatisticas: [Estatistica]
    
    let id: Int
    
    init(id: Int) {
        self.id = id
        
        self.estatisticaAtual = .init(
            filaID: id,
            quantDaFila: .zero,
            perdas: .zero,
            evento: .none,
            tempo: .zero,
            contatores: [:])
        self.estatisticas = [estatisticaAtual]
        estatisticasGerais[id] = self
    }
    
    /// atualiza as estatisticas de acordo com o tipo e tempo recebido
    /// o tempo é incrementado no indice de acordo com a quantidade de pessoal na fila
    /// p.ex. se a fila esta vazia, o arrray na posicao 0 terá o tempo incrementado
    /// p.ex. se tem uma pessoa na fila esta vazia, o arrray na posicao 1 terá o tempo incrementado
    func updateEstatisticas(evt: Evento.Tipo,
                            tempo: Double,
                            quantAnteriorDaFila: Int,
                            quantDaFila: Int,
                            perdas: Int) {
        
        var contatores = estatisticaAtual.contatores
        let index: Int = quantAnteriorDaFila
        contatores[index] = (contatores[quantAnteriorDaFila] ?? 0) + (tempo - estatisticaAtual.tempo)
        estatisticaAtual = Estatistica(
            filaID: id,
            quantDaFila: quantDaFila,
            perdas: perdas,
            evento: evt,
            tempo: tempo,
            contatores: contatores)
        
        updateOutras(evt: evt, tempo: tempo)
    }
    
    func updateOutras(evt: Evento.Tipo,
                      tempo: Double) {
        estatisticasGerais
            .filter( { $0.key != id })
            .forEach { (key, value) in
                let estatisticaAtual = value.estatisticaAtual
                var contatores = estatisticaAtual.contatores
                let index: Int = estatisticaAtual.quantDaFila
                contatores[index] = (contatores[estatisticaAtual.quantDaFila] ?? 0)
                    + (tempo - estatisticaAtual.tempo)
                
                value.estatisticaAtual = Estatistica(
                    filaID: estatisticaAtual.filaID,
                    quantDaFila: estatisticaAtual.quantDaFila,
                    perdas: estatisticaAtual.perdas,
                    evento: evt,
                    tempo: tempo,
                    contatores: contatores)
        }
        
    }
}
