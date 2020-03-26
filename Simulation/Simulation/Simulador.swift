
import Foundation

public class Simulador {
    
    public let escalonador: Escalonador
    public let random: CongruenteLinear
    
    private let configDeEventos: [Config.Evento]
    
    public init(configDeEventos: [Config.Evento],
                random: CongruenteLinear,
                escalonador: Escalonador = Escalonador()) {
        self.configDeEventos = configDeEventos
        self.random = random
        self.escalonador = escalonador
    }
    
    @discardableResult
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
    
    /// imprime no prompt as estatisticas
    func imprimir(estatisticas: [Estatistica]) {
        print("--start--")
        estatisticas
            .sorted(by: { $0.tempo < $1.tempo })
            .forEach { print($0) }
        print("--end--")
        print("--\n--")
    }
    
    /// roda a simulacao sem interrupcoes
    private func rodarSimulacaoCompleta() {
        while let evento = escalonador.proximo() {
            processarEvento(evento)
        }
    }
    
    /// recebe um evento, executa a ação dele e caso seja um evento de chegada, agenda uma prox chegada
    private func processarEvento(_ evento: Evento) {
        evento.acao(escalonador.tempo)
        if evento.tipo == .chegada {
            gerarEventoChegada(evento.fila)
        }
    }
}

extension Simulador {
    
    // MARK: Gerar Eventos
    
    /// gera os eventos de chegada no escalonador
    private func gerarEventoChegada(_ fila: Fila) {
        guard let randomUniformizado = self.random.uniformizado() else { return }
        
        let tempo: Double = fila.proximaChegada(randomUniformizado: randomUniformizado)
        
        let evento = Evento(tipo: .chegada,
                            tempo: tempo,
                            acao: { tempo in fila.chegada(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de saida no escalonador
    private func gerarEventoSaida(_ fila: Fila, randomUniformizado: Double) {
                
        let tempo: Double = fila.proximaSaida(randomUniformizado: randomUniformizado)
        
        let evento = Evento(tipo: .saida,
                            tempo: tempo,
                            acao: { tempo in fila.saida(tempo: tempo) },
                            fila: fila)
        escalonador.adicionar(evento)
    }
    
    /// gera os eventos de transicao de uma fila para outra no escalonador
    private func gerarEventoTransicao(filaDeOrigem: Fila, filaDeDestino: Fila, randomUniformizado: Double) {
                
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
    private func configurar(configDeEventos: [Config.Evento]) {
        configDeEventos.forEach { configurar(configDeEventos: $0) }
    }
    
    /// recebe uma configuração de evento e chama os metodos configuração adequados
    private func configurar(configDeEventos: Config.Evento) {
        
        switch configDeEventos {
            case let .chegada(fila):
                gerarEventoChegada(fila)
            
            case let .transicao(filaDeOrigem, filaDeDestino):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino)
            
            case let .transicaoPonderada(filaDeOrigem, filaDeDestino, saida):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino,
                                                 saida: saida)
            
            case let .transicaoPonderadaComRetorno(filaDeOrigem, filaDeDestino, saida, retorno):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 filaDeDestino: filaDeDestino,
                                                 saida: saida,
                                                 retorno: retorno)
            
            case let .saida(fila):
                configurarAgendamentoDeSaida(fila)
        }
    }
    
    /// configura a saida da fila
    private func configurarAgendamentoDeSaida(_ fila: Fila) {
        fila.agendarSaida = { [weak self] in
            if
                let self = self,
                let randomUniformizado = self.random.uniformizado()
            {
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
    private func configurarAgendamentoDeTransicao(filaDeOrigem: Fila,
                                          filaDeDestino: Fila,
                                          saida: Double = 0,
                                          retorno: Double = 0) {
        var taxaDeSaida: Double = saida
        taxaDeSaida = min(taxaDeSaida, 1)
        taxaDeSaida = max(taxaDeSaida, 0)
        
        var taxaDeRetorno: Double = retorno
        taxaDeRetorno = min(taxaDeRetorno, 1)
        taxaDeRetorno = max(taxaDeRetorno, 0)
        taxaDeRetorno = (1 - taxaDeSaida) * taxaDeRetorno + taxaDeSaida
        
        filaDeOrigem.agendarSaida = { [weak self] in
            if
                let self = self,
                let randomUniformizado = self.random.uniformizado()
            {
                
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
