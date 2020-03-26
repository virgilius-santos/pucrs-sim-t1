
import Foundation

public class Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    let configDeEventos: [Config.Evento]
    
    public init(configDeEventos: [Config.Evento],
                random: CongruenteLinear,
                escalonador: Escalonador = Escalonador()) {
        self.configDeEventos = configDeEventos
        self.random = random
        self.escalonador = escalonador
    }
    
    public func simular() -> [Estatistica] {
        
        configurar(configDeEventos: configDeEventos)
        
        // roda a simulacao
        rodarSimulacaoCompleta()
        
        let filas: Set<Fila> = Set<Fila>(configDeEventos
            .flatMap { $0.filas })
        
        let estatisticas: [Estatistica] = filas
            .flatMap { $0.dados.estatisticas }
        
        return estatisticas
    }
    
    /// roda a simulacao sem interrupcoes
    func rodarSimulacaoCompleta() {
        while
            let evento = escalonador.proximo(),
            let randomUniformizado = self.random.uniformizado()
        {
            processarEvento(evento, randomUniformizado: randomUniformizado)
        }
    }
    
    /// recebe um evento, executa a ação dele e caso seja um evento de chegada, agenda uma prox chegada
    func processarEvento(_ evento: Evento, randomUniformizado: Double) {
        evento.acao(escalonador.tempo)
        if evento.tipo == .chegada {
            gerarEventoChegada(evento.fila, randomUniformizado: randomUniformizado)
        }
    }
    
    /// imprime no prompt as estatisticas
    func imprimir(estatisticas: [Estatistica]) {
        print("--start--")
        estatisticas
            .sorted(by: { $0.tempo < $1.tempo })
            .forEach { print($0) }
        print("--end--")
        print("--\n--")
    }
}

extension Simulador {
    
    // MARK: Gerar Eventos
    
    /// gera os eventos de chegada no escalonador
    func gerarEventoChegada(_ fila: Fila, randomUniformizado: Double) {
        
        let tempo: Double = fila.proximaChegada(randomUniformizado: randomUniformizado)
        
        let evento = Evento(tipo: .chegada,
                            tempo: tempo,
                            acao: { tempo in fila.chegada(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de saida no escalonador
    func gerarEventoSaida(_ fila: Fila, randomUniformizado: Double) {
                
        let tempo: Double = fila.proximaSaida(randomUniformizado: randomUniformizado)
        
        let evento = Evento(tipo: .saida,
                            tempo: tempo,
                            acao: { tempo in fila.saida(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de transicao de uma fila para outra no escalonador
    func gerarEventoTransicao(filaDeOrigem: Fila, filaDeDestino: Fila, randomUniformizado: Double) {
                
        let tempo: Double = filaDeOrigem.proximaSaida(randomUniformizado: randomUniformizado)
        
        let evento = Evento(tipo: .transicao,
                            tempo: tempo,
                            acao: { tempo in
                                filaDeOrigem.saida(tempo: tempo)
                                filaDeDestino.chegada(tempo: tempo) },
                            fila: filaDeOrigem)
        escalonador.adicionar(evento)
    }
}

extension Simulador {
    
    // MARK: Configuração
    
    /// recebe uma lista para configura o simulador
    func configurar(configDeEventos: [Config.Evento]) {
        configDeEventos.forEach { configurar(configDeEventos: $0) }
    }
    
    /// recebe uma configuração de evento e chama os metodos configuração adequados
    func configurar(configDeEventos: Config.Evento) {
        guard let randomUniformizado = self.random.uniformizado() else { return }
        switch configDeEventos {
            case let .chegada(fila):
                gerarEventoChegada(fila, randomUniformizado: randomUniformizado)
            
            case let .transicao(filaDeOrigem, filaDeDestino):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino,
                                                 randomUniformizado: randomUniformizado)
            
            case let .transicaoPonderada(filaDeOrigem, filaDeDestino, saida):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino,
                                                 saida: saida,
                                                 randomUniformizado: randomUniformizado)
            
            case let .transicaoPonderadaComRetorno(filaDeOrigem, filaDeDestino, saida, retorno):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino,
                                                 saida: saida,
                                                 retorno: retorno,
                                                 randomUniformizado: randomUniformizado)
            
            case let .saida(fila):
                configurarAgendamentoDeSaida(fila, randomUniformizado: randomUniformizado)
        }
    }
    
    /// configura a saida da fila
    func configurarAgendamentoDeSaida(_ fila: Fila, randomUniformizado: Double) {
        fila.agendarSaida = { [weak self] in
            if let self = self {
                self.gerarEventoSaida(fila, randomUniformizado: randomUniformizado)
            }
        }
    }
    
    /**
     configura a transicao de uma fila para outra fila, para a saida ou para a mesma fila.
     
     A prioridade é para saida, ou seja, se o parametro SAIDA for 100% será gerado um evento de saída.
     
     O RETORNO é caculado: (100% - SAIDA) * RETORNO + SAIDA, ou seja,
     se a SAIDA = 20%, e o RETORNO = 40% a probabilidade de retorno é (100% - 20%) * 40% + 20% = 52%,
     
     então entre 0 e 20% a probabilidade de ir pra saida,
     entre 20 e 52% a probabilidade de ir pra mesma fila,
     e acima disse a probabilidade de ir pra fila de saida
     
     como visto no exemplo acima, o Agendamento é deirecionado a fila de saida somente se nenhum dos outros critérios for atendido.
     
     - parameter saida: Probabilidade em porcentagem do evento direcionar para saida.
     - parameter retorno: Probabilidade em porcentagem do evento direcionar para a mesma fila.
     */
    func configurarAgendamentoDeTransicao(filaDeOrigem: Fila,
                                          filaDeDestino: Fila,
                                          saida: Double = 0,
                                          retorno: Double = 0,
                                          randomUniformizado: Double) {
        var taxaDeSaida: Double = saida
        taxaDeSaida = min(taxaDeSaida, 1)
        taxaDeSaida = max(taxaDeSaida, 0)
        
        var taxaDeRetorno: Double = retorno
        taxaDeRetorno = min(taxaDeRetorno, 1)
        taxaDeRetorno = max(taxaDeRetorno, 0)
        taxaDeRetorno = (1 - taxaDeSaida) * taxaDeRetorno + taxaDeSaida
        
        filaDeOrigem.agendarSaida = { [weak self] in
            if let self = self {
                
                if randomUniformizado < taxaDeSaida {
                    self.gerarEventoSaida(filaDeOrigem,
                                          randomUniformizado: randomUniformizado)
                }
                else if randomUniformizado < taxaDeRetorno {
                    self.gerarEventoTransicao(filaDeOrigem: filaDeOrigem,
                                              filaDeDestino: filaDeOrigem,
                                              randomUniformizado: randomUniformizado)
                }
                else {
                    self.gerarEventoTransicao(filaDeOrigem: filaDeOrigem,
                                              filaDeDestino: filaDeDestino,
                                              randomUniformizado: randomUniformizado)
                }
            }
        }
    }
}
