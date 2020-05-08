
import Foundation

// MARK: - Tempo

// tempo de processamento
private(set) var T = Double.zero

// qtds das filas
private(set) var qs = [Fila]()

// filas registradas
private(set) var filasDict = [String: Fila]()

// MARK: - NovoSimulador

final public class NovoSimulador {
    
    // MARK: - Eventos
    
    // indice do evento
    var index = Int.zero
    
    // array que armazenas os eventos NÃO processados
    var eventos = [Evento]()
    
    // array que armazenas os eventos processados
    var processados = [Evento]()
    
    // evento em processados
    var emProcessamento: Evento!
    
    public init(random rnd: CongruenteLinear,
                filas: [Fila] = [Fila]()) {
        
        index = Int.zero
        eventos = [Evento]()
        processados = [Evento]()
        filasDict = [String: Fila]()
        
        random = rnd
        terminou = false
        
        T = Double.zero
        qs = filas
    }
    
    private func processar() {
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
        qs.forEach { configurarFila(fila: $0) }
        processar()
        imprimir()
    }
    
    // realiza agendamento nos eventos
    private func agenda(_ f: @escaping ActionVoid, _ t: Double, _ tipo: TipoDeFila) {
        let evt: Evento = (index, f, T + t, true, tipo)
        eventos.append(evt)
        eventos.sort(by: { $0.t > $1.t })
        index += 1
    }
    
    // contabiliza os tempos
    private func contabilizarTempo() {
        
        func update(fila: Fila, delta: Double) {
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
    
    func configurarFila(
        fila novaFila: Fila,
        filaSimples: Bool = false
    ) {
        
        let transicoes = novaFila.transicoes
        
        let filaSimples = filaSimples
            || transicoes.isEmpty
            || (transicoes.count == 1 && transicoes[0].taxa == 1)
        
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
        
        filasDict[novaFila.nome] = novaFila
    }
}

// MARK: - Random

// gerador de numeros pseudo aleatorios
private(set) var random: CongruenteLinear!

// indica se os numeros aleatorios terminaram
private(set) var terminou = false

// funcao que busca um aleatorio normalizado
// se nao existir retorna nil
func rnd(_ inicio: Double, _ fim: Double) -> Double? {
    if let r = random.uniformizado() {
        return (fim - inicio) * r + inicio
    }
    else {
        terminou = true
        return nil
    }
}
