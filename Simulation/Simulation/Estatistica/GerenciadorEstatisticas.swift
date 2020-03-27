
import Foundation

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
    }
}

public extension Array where Element == GerenciadorEstatisticas {
    /// imprime no prompt as estatisticas
    func imprimir(limit: Int = 5) {
        print("--start--")
        flatMap { $0.estatisticas }
            .suffix(limit)
            .sorted(by: { $0.filaID < $1.filaID && $0.tempo < $1.tempo })
            .forEach { print($0) }
        print("--end--")
        print("--\n--")
    }
}
