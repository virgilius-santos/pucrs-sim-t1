
import Foundation

public enum Agendamento {
    case chegada(fila: Fila)
    case transicao(entrada: Fila, saida: Fila)
    case transicaoPonderada(entrada: Fila, saida: Fila, taxa: Double)
    case saida(fila: Fila)
    
    var estatisticas: [Estatistica] {
        switch self {
            case let .chegada(fila):
                return fila.dados.estatisticas
            case let .transicao(filaEntrada, filaSaida):
                return filaEntrada.dados.estatisticas + filaSaida.dados.estatisticas
            case let .transicaoPonderada(filaEntrada, filaSaida, _):
                return filaEntrada.dados.estatisticas + filaSaida.dados.estatisticas
            case let .saida(fila):
                return fila.dados.estatisticas
        }
    }
}

extension Simulador {
    func configurar(agendamento: Agendamento) {
        switch agendamento {
            case let .chegada(fila):
                gerarEventoChegada(fila)
            case let .transicao(filaEntrada, filaSaida):
                configurarAgendamentoDeTransicao(filaDeEntrada: filaEntrada, filaDeSaida: filaSaida)
            case let .transicaoPonderada(filaEntrada, filaSaida, saida):
                configurarAgendamentoDeTransicao(filaDeEntrada: filaEntrada, filaDeSaida: filaSaida, saida: saida)
            case let .saida(fila):
                configurarAgendamentoDeSaida(fila)
        }
    }
    
    func configurar(agendamentos: [Agendamento]) {
        agendamentos.forEach { configurar(agendamento: $0) }
    }
}
