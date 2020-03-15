
import Foundation

class GerenciadorEstatisticas {
    
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
    let capacidade: Int
    
    init(id: Int, capacidade k: Int) {
        self.id = id
        self.capacidade = k
        
        self.estatisticaAtual = .init(
            filaID: id,
            quantDaFila: .zero,
            perdas: .zero,
            evento: .none,
            tempo: .zero,
            contatores: [:])
        self.estatisticas = [estatisticaAtual]
    }
    
    /// atualiza as estatisticas de acordo com o tipo e tempo recebido
    /// o tempo é incrementado no indice de acordo com a quantidade de pessoal na fila
    /// p.ex. se a fila esta vazia, o arrray na posicao 0 terá o tempo incrementado
    /// p.ex. se tem uma pessoa na fila esta vazia, o arrray na posicao 1 terá o tempo incrementado
    func updateEstatisticas(evt: Evento.Tipo, tempo: Double, quantDaFila: Int, perdas: Int) {
        var contatores = estatisticaAtual.contatores
        let index: Int = buscarIndexContadorAtual(quantDaFila: quantDaFila)
        contatores[index] = (contatores[index] ?? 0) + (tempo - estatisticaAtual.tempo)
        estatisticaAtual = Estatistica(
            filaID: id,
            quantDaFila: quantDaFila,
            perdas: perdas,
            evento: evt,
            tempo: tempo,
            contatores: contatores)
    }
    
    /// busca o indice que representa o numero de ocupações da fila
    /// p.ex. se a fila esta vazia, retorna 0 (zero)
    /// p.ex. se tem uma pessoa na fila esta vazia, retorna 1 (um)
    private func buscarIndexContadorAtual(_ index: Int = 0, quantDaFila: Int) -> Int {
        if index >= capacidade { return capacidade - 1 }
        if quantDaFila == index { return index }
        return buscarIndexContadorAtual(index + 1, quantDaFila: quantDaFila)
    }
}
