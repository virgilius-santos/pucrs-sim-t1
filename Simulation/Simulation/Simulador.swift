
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
        
        let saida = 1 - destinosNormalizados.map { $0.probabilidade }.reduce(0, +)
        let escolherCaminho: Bool = saida > 0 && saida < 1
                    
        filaDeOrigem.agendarSaida = { [weak self] in
            if
                let self = self,
                let random1 = self.random.uniformizado(),
                let random2 = escolherCaminho ? self.random.uniformizado() : random1
            {
                
                var aux: Double = 0
                
                for dest in destinosNormalizados {
                    if random1 <= (dest.probabilidade + aux) {

                        self.gerarEventoTransicao(
                            filaDeOrigem: filaDeOrigem,
                            filaDeDestino: dest.fila,
                            randomUniformizado: random2)
                        return
                    }
                    else {
                        aux += dest.probabilidade
                    }
                }
                
                self.gerarEventoSaida(filaDeOrigem, randomUniformizado: random2)
            }
        }
    }
}
