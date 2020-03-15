
import Foundation

public class Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    let agendamentos: [Agendamento]
    
    public init(agendamentos: [Agendamento],
                random: CongruenteLinear,
                escalonador: Escalonador = Escalonador()) {
        self.agendamentos = agendamentos
        self.random = random
        self.escalonador = escalonador
    }
    
    public func simular() -> [Estatistica] {
        
        configurar(agendamentos: agendamentos)
        
        // roda a simulacao
        rodarSimulacaoCompleta()
        
        return agendamentos.flatMap { $0.estatisticas }
    }
}

public extension Simulador {
    
    // MARK: Eventos
    
    /// gera os eventos de chegada no escalonador
    func gerarEventoChegada(_ fila: Fila) {
        let evento = Evento(tipo: .chegada,
                            tempo: fila.proximaChegada,
                            acao: { tempo in fila.chegada(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de saida no escalonador
    func gerarEventoSaida(_ fila: Fila) {
        let evento = Evento(tipo: .saida,
                            tempo: fila.proximaSaida,
                            acao: { tempo in fila.saida(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de transicao de uma fila para outra no escalonador
    func gerarEventoTransicao(filaDeEntrada: Fila, filaDeSaida: Fila) {
        let evento = Evento(tipo: .transicao,
                            tempo: filaDeEntrada.proximaSaida,
                            acao: { tempo in
                                filaDeEntrada.saida(tempo: tempo)
                                filaDeSaida.chegada(tempo: tempo) },
                            fila: filaDeEntrada)
        escalonador.adicionar(evento)
    }
    
    /// recebe um evento, executa a ação dele e caso seja um evento de chegada, agenda uma prox chegada
    func processarEvento(_ evento: Evento) {
        evento.acao(escalonador.tempo)
        if evento.tipo == .chegada, evento.fila.temProximoEventoDeChegada {
            gerarEventoChegada(evento.fila)
        }
    }
    
    // MARK: Configuracao
    
    /// configura a saida da fila
    func configurarAgendamentoDeSaida(_ fila: Fila) {
        fila.agendarSaida = { [weak self] in
            if let self = self {
                self.gerarEventoSaida(fila)
            }
        }
    }
    
    /// configura a transicao de uma fila para outra
    func configurarAgendamentoDeTransicao(filaDeEntrada: Fila, filaDeSaida: Fila, saida: Double = 0) {
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
    
    // MARK: Ação global
    
    /// roda a simulacao sem interrupcoes
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
