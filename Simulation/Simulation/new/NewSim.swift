
import Foundation

// MARK: - Tempo

// tempo de processamento
var T = Double.zero

// qtds das filas
var qs = [Queue]()

// filas registradas
var filasDict = [String: Queue]()

// MARK: Agendamento

enum TIPO: String {
    case chegada, saida, transicao
}

typealias Agendamento = (_ f: @escaping ActionVoid, _ t: Double, TIPO) -> Void

// MARK: - NovoSimulador

class NovoSimulador {
    
    // MARK: - Eventos
    
    typealias Event = (i: Int, f: ActionVoid, t: Double, a: Bool, tipo: TIPO)
    
    // indice do evento
    var index = Int.zero
    
    // array que armazenas os eventos NÃO processados
    var eventos = [Event]()
    
    // array que armazenas os eventos processados
    var processados = [Event]()
    
    // evento em processados
    var emProcessamento: Event!
    
    init(semente: UInt = 29,
         maxIteracoes: Int = 100000,
         valoresFixos: [Double] = []) {
        
        Config.CongruenteLinear.semente = semente
        
        index = Int.zero
        eventos = [Event]()
        processados = [Event]()
        filasDict = [String: Queue]()
        
        random = .init(maxIteracoes: maxIteracoes,
                       valoresFixos: valoresFixos)
        terminou = false
        
        T = Double.zero
        qs = [Queue]()
    }
    
    func configurar() {

        qs = [
            
            // configuração da fila 3
            gerarFila(nome: "Q1",
                      c: 1,
                      taxaEntrada: (1, 4),
                      taxaSaida: (1, 1.5),
                      transicoes: [ ("Q2", 0.8), ("Q3", 0.2) ]),
            
            // configuração da fila 2
            gerarFila(nome: "Q2",
                      c: 3,
                      k: 5,
                      taxaSaida: (5, 10),
                      transicoes: [ ("Q1", 0.3), ("Q3", 0.5) ]),
            
            // configuração da fila 1
            gerarFila(nome: "Q3",
                      c: 2,
                      k: 8,
                      taxaSaida: (10, 20),
                      transicoes: [ ("Q2", 0.7) ]),
        ]
    }
    
    func processar() {
        while
            terminou == false,
            random.temProxima, let ult = eventos.popLast()
        {
            emProcessamento = ult
            ult.f()
            processados.append(ult)
        }
    }
    
    public func simular() {
        configurar()
        processar()
        imprimir()
    }
    
    // realiza agendamento nos eventos
    func agenda(_ f: @escaping ActionVoid, _ t: Double, _ tipo: TIPO) {
        let evt: Event = (index, f, T + t, true, tipo)
        eventos.append(evt)
        eventos.sort(by: { $0.t > $1.t })
        index += 1
    }
    
    
    // contabiliza os tempos
    func contabilizarTempo() {
        
        func update(fila: Queue, delta: Double) {
            if fila.qtdDaFila < fila.contador.count {
                fila.contador[fila.qtdDaFila] += delta
            }
            else {
                fila.contador.append(delta)
            }
        }
        
        let delta: Double = emProcessamento.t - T
        
        qs.forEach { update(fila: $0, delta: delta) }
        
        T += delta
        
        qs.forEach {
            if T - $0.contador.reduce(0, +) > 0.00001 {
                fatalError("time wrong")
            }
        }
    }
    
    func gerarFila(
        nome: String,
        c: Int,
        k: Int = .max,
        taxaEntrada: (inicio: Double, fim: Double) = (0, 0),
        taxaSaida: (inicio: Double, fim: Double),
        transicoes: [(nome: String, taxa: Double)] = [],
        filaSimples: Bool = false
    ) -> Queue {
        
        let filaSimples = filaSimples
            || transicoes.isEmpty
            || (transicoes.count == 1 && transicoes[0].taxa == 1)
        
        let novaFila = Queue(n: nome,
                             c: c,
                             k: k,
                             taxaEntrada: taxaEntrada,
                             taxaSaida: taxaSaida)
        
        novaFila.funcaoDeAgendamento = agenda
        novaFila.contabilizarTempo = contabilizarTempo
        
        novaFila.funcaoDeTransicao = { fila in
            if
                let r1 = filaSimples ? 1 : rnd(0,1),
                let r2 = rnd(fila.taxaSaida.inicio, fila.taxaSaida.fim)
            {
                let evt: ActionVoid
                
                var aux: Double = 0
                for t in transicoes {
                    if r1 <= t.taxa + aux {
                        evt = fila.evento(filasDict[t.nome])
                        fila.funcaoDeAgendamento?(evt, r2, .transicao)
                        return
                    }
                    else {
                        aux += t.taxa
                    }
                }
                evt = fila.evento()
                fila.funcaoDeAgendamento?(evt, r2, .saida)
            }
        }
        
        filasDict[nome] = novaFila
        
        return novaFila
    }
}
