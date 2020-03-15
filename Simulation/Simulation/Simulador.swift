
import Foundation

public protocol Simulador: class {
    var escalonador: Escalonador { get }
    var random: CongruenteLinear { get }
    
    func simular() -> [Estatistica]
    
    /// gera os eventos de chegada no escalonador
    func gerarEventoChegada(_ fila: Fila)
    
    /// gera os eventos de saida no escalonador
    func gerarEventoSaida(_ fila: Fila)
    
    /// gera os eventos de saida no escalonador
    func gerarEventoTransicao(filaDeEntrada: Fila, filaDeSaida: Fila)
    
    /// recebe um evento, executa a ação dele e caso seja um evento de chegada, agenda uma prox chegada
    func processarEvento(_ evento: Evento)
    
    /// configura a saida da fila
    func configurarAgendamentoDeSaida(_ fila: Fila)
    
    /// configura a saida da fila
    func configurarAgendamentoDeTransicao(filaDeEntrada: Fila, filaDeSaida: Fila, saida: Double)
    
    /// roda a simulacao sem interrupcoes
    func rodarSimulacaoCompleta()
    
    func imprimir(estatisticas: [Estatistica])
}

public extension Simulador {
    
    // MARK: Eventos
    
    func gerarEventoChegada(_ fila: Fila) {
        let evento = Evento(tipo: .chegada,
                            tempo: fila.proximaChegada,
                            acao: { tempo in fila.chegada(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    func gerarEventoSaida(_ fila: Fila) {
        let evento = Evento(tipo: .saida,
                            tempo: fila.proximaSaida,
                            acao: { tempo in fila.saida(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    func gerarEventoTransicao(filaDeEntrada: Fila, filaDeSaida: Fila) {
        let evento = Evento(tipo: .transicao,
                            tempo: filaDeEntrada.proximaSaida,
                            acao: { tempo in
                                filaDeEntrada.saida(tempo: tempo)
                                filaDeSaida.chegada(tempo: tempo) },
                            fila: filaDeEntrada)
        escalonador.adicionar(evento)
    }
    
    func processarEvento(_ evento: Evento) {
        evento.acao(escalonador.tempo)
        if evento.tipo == .chegada, evento.fila.temProximoEventoDeChegada {
            gerarEventoChegada(evento.fila)
        }
    }
    
    // MARK: Configuracao
    
    func configurarAgendamentoDeSaida(_ fila: Fila) {
        fila.agendarSaida = { [weak self] in
            if let self = self {
                self.gerarEventoSaida(fila)
            }
        }
    }
    
    func configurarAgendamentoDeTransicao(filaDeEntrada: Fila, filaDeSaida: Fila, saida: Double) {
        filaDeEntrada.agendarSaida = { [weak self] in
            if let self = self {
                if self.random.uniformizado < saida {
                    self.gerarEventoSaida(filaDeEntrada)
                }
                else {
                    self.gerarEventoTransicao(filaDeEntrada: filaDeEntrada,
                                              filaDeSaida: filaDeSaida)
                }
            }
        }
    }
    
    func configurarAgendamentoDeTransicao(filaDeEntrada: Fila, filaDeSaida: Fila) {
        configurarAgendamentoDeTransicao(filaDeEntrada: filaDeEntrada,
                                         filaDeSaida: filaDeSaida,
                                         saida: 0)
    }
    
    // MARK: Ação global
    
    func rodarSimulacaoCompleta() {
        while let evento = escalonador.proximo() {
            processarEvento(evento)
        }
    }
    
    func imprimir(estatisticas: [Estatistica]) {
        print("--start--")
        estatisticas
            .sorted(by: { $0.tempo < $1.tempo })
            .forEach { print($0) }
        print("--end--")
        print("--\n--")
    }
}
