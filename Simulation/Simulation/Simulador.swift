
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
    
    public func simular() {
        
        // configurar transições
        configurar()
        
        // roda a simulacao
        rodarSimulacaoCompleta()
    }
    
    /// recebe uma lista para configura o simulador
    func configurar() {
        configDeEventos.forEach { configurar(configDeEvento: $0) }
    }
    
    /// roda um step da simulacao
    func rodarPassoDaSimulacao() -> Bool {
        if
            random.temProxima,
            let evento = escalonador.proximo()
        {
            processarEvento(evento)
            return true
        }
        return false
    }
    
    /// roda a simulacao sem interrupcoes
    private func rodarSimulacaoCompleta() {
        while rodarPassoDaSimulacao() {}
    }
    
    /// recebe um evento, executa a ação dele e caso seja um evento de chegada, agenda uma prox chegada
    private func processarEvento(_ evento: Evento) {
        evento.acao(escalonador.tempo)
        if evento.tipo == .chegada, random.temProxima {
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
    
    /// recebe uma configuração de evento e chama os metodos configuração adequados
    private func configurar(configDeEvento: Config.Evento) {
        
        switch configDeEvento {
            case let .chegada(fila):
                gerarEventoChegada(fila)
            
            case let .transicao(filaDeOrigem, filaDeDestino):
                configurarAgendamentoDeTransicao(
                    filaDeOrigem: filaDeOrigem,
                    destinos: [(filaDeDestino, 1)])
            
            case let .transicaoPonderada(filaDeOrigem, filaDeDestino, saida):
                configurarAgendamentoDeTransicao(
                    filaDeOrigem: filaDeOrigem,
                    destinos: [(filaDeDestino, 1 - saida)])
            
            case let .transicaoPonderadaComRetorno(filaDeOrigem, filaDeDestino, saida, retorno):
                configurarAgendamentoDeTransicao(
                    filaDeOrigem: filaDeOrigem,
                    destinos: [(filaDeDestino, 1 - saida - retorno),
                               (filaDeOrigem, retorno)])
            
            case let .saida(fila):
                configurarAgendamentoDeTransicao(filaDeOrigem: fila)
            
            case let .transicaoRede(filaDeOrigem, destinos):
                configurarAgendamentoDeTransicao(filaDeOrigem: filaDeOrigem,
                                                 destinos: destinos)
        }
    }
    
    private func configurarAgendamentoDeTransicao(
        filaDeOrigem: Fila,
        destinos: [(fila: Fila, probabilidade: Double)] = []
    ) {
        
        var destinosNormalizados: [(fila: Fila, probabilidade: Double)]
        
        destinosNormalizados = destinos
            .sorted(by: { $0.probabilidade < $1.probabilidade })
                    
        filaDeOrigem.agendarSaida = { [weak self] in
            if
                let self = self,
                let randomUniformizado = self.random.uniformizado()
            {
                
                var aux: Double = 0
                
                for dest in destinosNormalizados {
                    if randomUniformizado <= (dest.probabilidade + aux) {
                        self.gerarEventoTransicao(
                            filaDeOrigem: filaDeOrigem,
                            filaDeDestino: dest.fila,
                            randomUniformizado: randomUniformizado)
                        return
                    }
                    else {
                        aux += dest.probabilidade
                    }
                }
                
                self.gerarEventoSaida(filaDeOrigem,
                                      randomUniformizado: randomUniformizado)
            }
        }
    }
    
    /// configura a saida da fila
//    private func configurarAgendamentoDeSaida(_ fila: Fila) {
//        fila.agendarSaida = { [weak self] in
//            if
//                let self = self,
//                let randomUniformizado = self.random.uniformizado()
//            {
//                self.gerarEventoSaida(fila, randomUniformizado: randomUniformizado)
//            }
//        }
//    }
    
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
//    private func configurarAgendamentoDeTransicao(filaDeOrigem: Fila,
//                                          filaDeDestino: Fila,
//                                          saida: Double = 0,
//                                          retorno: Double = 0) {
//        var taxaDeSaida: Double = saida
//        taxaDeSaida = min(taxaDeSaida, 1)
//        taxaDeSaida = max(taxaDeSaida, 0)
//
//        var taxaDeRetorno: Double = retorno
//        taxaDeRetorno = min(taxaDeRetorno, 1)
//        taxaDeRetorno = max(taxaDeRetorno, 0)
//        taxaDeRetorno = (1 - taxaDeSaida) * taxaDeRetorno + taxaDeSaida
//
//        filaDeOrigem.agendarSaida = { [weak self] in
//            if
//                let self = self,
//                let randomUniformizado = self.random.uniformizado()
//            {
//
//                if randomUniformizado < taxaDeSaida {
//                    self.gerarEventoSaida(filaDeOrigem,
//                                          randomUniformizado: randomUniformizado)
//                }
//                else if randomUniformizado < taxaDeRetorno {
//                    self.gerarEventoTransicao(filaDeOrigem: filaDeOrigem,
//                                              filaDeDestino: filaDeOrigem,
//                                              randomUniformizado: randomUniformizado)
//                }
//                else {
//                    self.gerarEventoTransicao(filaDeOrigem: filaDeOrigem,
//                                              filaDeDestino: filaDeDestino,
//                                              randomUniformizado: randomUniformizado)
//                }
//            }
//        }
//    }
}
