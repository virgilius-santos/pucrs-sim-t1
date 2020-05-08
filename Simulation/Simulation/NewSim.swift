
import Foundation

// MARK: - Tempo

// tempo de processamento
var T: Double = .zero

// contabiliza os tempos
func contabiliza() {
        
    func update(fila: Queue, delta: Double) {
        if fila.f < fila.contador.count {
            fila.contador[fila.f] += delta
        }
        else {
            fila.contador.append(delta)
        }
    }
    
    let delta: Double = emProcessamento.t - T
    
    qs.forEach { update(fila: $0, delta: delta) }
    
    T += delta
    
    qs.forEach {
        if T != $0.contador.reduce(0, +) {
            fatalError("time wrong")
        }
    }
    
}

// MARK: - Filas

class Queue {
    let n: String
    let c: Int
    let k: Int
    let ec: Double
    let ef: Double
    let sc: Double
    let sf: Double
    
    var f: Int = .zero
    var contador: [Double] = []
    var perdas: Int = .zero
    
    var t: ActionVoid
    
    init(
        n: String,
        c: Int,
        k: Int,
        ec: Double,
        ef: Double,
        sc: Double,
        sf: Double,
        t: @escaping ActionVoid
    ) {
        self.n = n
        self.c = c
        self.k = k
        self.ec = ec
        self.ef = ef
        self.sc = sc
        self.sf = sf
        self.t = t
    }
    
    // MARK: Função saidas das filas
    
    func s() {
        f -= 1
        if f >= c { t() }
    }
    
    // MARK: Função de entradas das filas
    
    func e() {
        if f < k {
            f += 1
            if f <= c { t() }
        }
        else {
            perdas += 1
        }
    }
    
    func ch() {
        contabiliza()
        e()
        if let r = rnd(ec, ef) {
            agenda(ch, r)
        }
    }
    
    func p(_ q: Queue? = nil) -> ActionVoid {
        return { [s] in
            contabiliza()
            s()
            q?.e()
        }
    }
}

// configuração da fila 1
var q1 = Queue(n: "Q1",
               c: 1,
               k: .max,
               ec: 1,
               ef: 4,
               sc: 1,
               sf: 1.5,
               t: t1)

// configuração da fila 2
var q2 = Queue(n: "Q2",
               c: 3,
               k: 5,
               ec: 0,
               ef: 0,
               sc: 5,
               sf: 10,
               t: t2)

// configuração da fila 3
var q3 = Queue(n: "Q3",
               c: 2,
               k: 8,
               ec: 0,
               ef: 0,
               sc: 10,
               sf: 20,
               t: t3)

// qtds das filas
let qs: [Queue] = [q1, q2, q3]

// MARK: - Eventos

// indice do evento
var index = Int.zero

typealias Event = (i: Int, f: ActionVoid, t: Double, a: Bool)

// array que armazenas os eventos NÃO processados
var eventos = [Event]()

// array que armazenas os eventos processados
var processados = [Event]()

// evento em processados
var emProcessamento: Event!

// MARK: - Random

// gerador de numeros pseudo aleatorios
var random: CongruenteLinear = {
    .init(maxIteracoes: 100000)
}()

// indica se os numeros aleatorios terminaram
var terminou = false

// funcao que busca um aleatorio normalizado
// se nao existir retorna nil
var rnd: ((_ s: Double, _ e: Double) -> Double?) = { (s, e) in
    if let r = random.uniformizado() {
        return Tempo(inicio: s, fim: e).tempo(uniformizado: r)
    }
    else {
        terminou = true
        return nil
    }
}

// MARK: - Agendamento

// realiza agendamento nos eventos
var agenda: ((_ f: @escaping ActionVoid, _ t: Double) -> Void) = { f, t in
    let evt: Event = (index, f, T + t, true)
    eventos.append(evt)
    eventos.sort(by: { $0.t > $1.t })
    index += 1
}

// MARK: - Funções

// MARK: Função transição das filas

func t1() {
    if let r1 = rnd(0,1), let r2 = rnd(q1.sc, q1.sf) {
        if r1 < 0.8 {
            agenda(q1.p(q2), r2)
        }
        else {
            agenda(q1.p(q3), r2)
        }
    }
}

func t2() {
    if let r1 = rnd(0,1), let r2 = rnd(q2.sc, q2.sf) {
        if r1 <= 0.3 {
            agenda(q2.p(q1), r2)
        }
        else if r1 <= 0.3 + 0.5 {
            agenda(q2.p(q3), r2)
        }
        else {
            agenda(q2.p(), r2)
        }
    }
}

func t3() {
    if let r1 = rnd(0,1), let r2 = rnd(q3.sc, q3.sf) {
        if r1 < 0.7 {
            agenda(q3.p(q2), r2)
        }
        else {
            agenda(q3.p(), r2)
        }
    }
}

public func simular() {
    
    guard let r = rnd(q1.ec, q1.ef) else { return }
    agenda(q1.ch, r)
    
    while
        terminou == false,
        random.temProxima, let ult = eventos.popLast()
    {
        emProcessamento = ult
        ult.f()
        processados.append(ult)
    }
    
    
    imprimir()
}

func imprimir() {
    print(
"""
=========================================================
======================    REPORT   ======================
=========================================================
"""
)
    qs.forEach { imprimir(q: $0) }
    print("=========================================================")
}

func imprimir(q: Queue) {
    print(
"""
*******************
Queue:   \(q.n) (G/G/\(q.c)\(q.k == .max ? "" : "/\(q.k)")
Arrival: \(q.ec.format(2, p: 2)) ... \(q.ef.format(2, p: 2))
Service: \(q.sc.format(2, p: 2)) ... \(q.sf.format(2, p: 2))
*******************
   State           Time             Probability
\(formatCont(q.contador))

Number of losses: \(q.perdas)

*******************

"""
)
    
    
}

func formatCont(_ contador: [Double]) -> String {
    let total = contador.reduce(0, +)
    return contador
        .enumerated()
        .reduce("", { $0 + "\t" + "\($1.offset.format(4))"
                         + "\t" + "\($1.element.format(f: 10, 4))"
                         + "\t\t\t\(($1.element * 100 / total).format(f: 3, 2))\n"
        })
}
