
import Foundation

// MARK: - Tempo

// tempo de processamento
var T: Double = .zero

typealias Contadores = (_ f1: Int, _ f2: Int, _ f3: Int) -> Void

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
    
    init(
        n: String,
        c: Int,
        k: Int,
        ec: Double,
        ef: Double,
        sc: Double,
        sf: Double
    ) {
        self.n = n
        self.c = c
        self.k = k
        self.ec = ec
        self.ef = ef
        self.sc = sc
        self.sf = sf
    }
}

// configuração da fila 1
var q1 = Queue(n: "Q1",
               c: 1,
               k: .max,
               ec: 1,
               ef: 4,
               sc: 1,
               sf: 1.5)

// configuração da fila 2
var q2 = Queue(n: "Q2",
               c: 3,
               k: 5,
               ec: 0,
               ef: 0,
               sc: 5,
               sf: 10)

// configuração da fila 3
var q3 = Queue(n: "Q3",
               c: 2,
               k: 8,
               ec: 0,
               ef: 0,
               sc: 10,
               sf: 20)

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
var rnd: ((_ s: Double, _ e: Double) -> Double?) =
    { (s, e) in
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

// MARK: Função de entradas das filas

func e(_ q: Queue, _ t: ActionVoid) {
    if q.f < q.k {
        q.f += 1
        if q.f <= q.c { t() }
    }
    else {
        q.perdas += 1
    }
}

// MARK: Função saidas das filas

func s(_ q: Queue, _ t: ActionVoid) {
    q.f -= 1
    if q.f >= q.c { t() }
}

// MARK: Função transição das filas

func t1() {
    if let r1 = rnd(0,1), let r2 = rnd(q1.sc, q1.sf) {
        if r1 < 0.8 {
            agenda(p12, r2)
        }
        else {
            agenda(p13, r2)
        }
    }
}

func t2() {
    if let r1 = rnd(0,1), let r2 = rnd(q2.sc, q2.sf) {
        if r1 <= 0.3 {
            agenda(p21, r2)
        }
        else if r1 <= 0.3 + 0.5 {
            agenda(p23, r2)
        }
        else {
            agenda(sa2, r2)
        }
    }
}

func t3() {
    if let r1 = rnd(0,1), let r2 = rnd(q3.sc, q3.sf) {
        if r1 < 0.7 {
            agenda(p32, r2)
        }
        else {
            agenda(sa3, r2)
        }
    }
}

// MARK: Eventos

func ch1() {
    contabiliza()
    e(q1, t1)
    if let r = rnd(q1.ec, q1.ef) {
        agenda(ch1, r)
    }
}

func p12() {
    contabiliza()
    s(q1, t1)
    e(q2, t2)
}

func p13() {
    contabiliza()
    s(q1, t1)
    e(q3, t3)
}

func p21() {
    contabiliza()
    s(q2, t2)
    e(q1, t1)
}

func p23() {
    contabiliza()
    s(q2, t2)
    e(q3, t3)
}

func sa2() {
    contabiliza()
    s(q2, t2)
}

func p32() {
    contabiliza()
    s(q3, t3)
    e(q2, t2)
}

func sa3() {
    contabiliza()
    s(q3, t3)
}

public func simular() {
    
    
    guard let r = rnd(q1.ec, q1.ef) else { return }
    agenda(ch1, r)
    
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
