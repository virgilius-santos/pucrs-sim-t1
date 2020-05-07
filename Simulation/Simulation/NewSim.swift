
import Foundation

// MARK: - Tempo

// tempo de processamento
var T: Double = .zero

typealias Contadores = (_ f1: Int, _ f2: Int, _ f3: Int) -> Void

// contabiliza os tempos
var contabiliza: Contadores = { (f1, f2, f3) in
        
    func update(cont: inout [Double], f: Int, temp: Double) {
        if f < cont.count {
            cont[f] += temp
        }
        else {
            cont.append(temp)
        }
    }
    
    let delta: Double = emProcessamento.t - T
    
    update(cont: &contador1, f: f1, temp: delta)
    update(cont: &contador2, f: f2, temp: delta)
    update(cont: &contador3, f: f3, temp: delta)
    T += delta
    if T != contador1.reduce(0, +) || T != contador2.reduce(0, +) || T != contador3.reduce(0, +) {
        fatalError("time wrong")
    }
}

// MARK: - Filas

struct Queue {
    var n: String
    var c: Int
    var k: Int
    var ec: Double
    var ef: Double
    var sc: Double
    var sf: Double
}

// configuração da fila 1
var q1 = Queue(n: "Q1", c: 1, k: .max, ec: 1, ef: 4, sc: 1, sf: 1.5)
var f1: Int = .zero
var contador1: [Double] = []
var perdas1: Int = .zero

// configuração da fila 2
var q2 = Queue(n: "Q2", c: 3, k: 5, ec: 0, ef: 0, sc: 5, sf: 10)
var f2: Int = .zero
var contador2: [Double] = []
var perdas2: Int = .zero

// configuração da fila 3
var q3 = Queue(n: "Q3", c: 2, k: 8, ec: 0, ef: 0, sc: 10, sf: 20)
var f3: Int = .zero
var contador3: [Double] = []
var perdas3: Int = .zero

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
var agenda: ((_ f: @escaping ActionVoid, _ T_old: Double, _ t: Double) -> Void) =
    { f, T_old, t in
        let evt: Event = (index, f, T + t, true)
        eventos.append(evt)
        eventos.sort(by: { $0.t > $1.t })
        index += 1
    }

// MARK: - Funções

// MARK: Função de entradas das filas

func e(_ f: inout Int, _ q: Queue, _ t: ActionVoid, _ perdas: inout Int) {
    if f < q.k {
        f += 1
        if f <= q.c { t() }
    }
    else {
        perdas += 1
    }
}

// MARK: Função saidas das filas

func s(_ f: inout Int, _ q: Queue, _ t: ActionVoid) {
    f -= 1
    if f >= q.c { t() }
}

// MARK: Função transição das filas

var t1: ActionVoid! = {
    if let r1 = rnd(0,1), let r2 = rnd(q1.sc, q1.sf) {
        if r1 < 0.8 {
            agenda(p12, T, r2)
        }
        else {
            agenda(p13, T, r2)
        }
    }
}

var t2: ActionVoid! = {
    if let r1 = rnd(0,1), let r2 = rnd(q2.sc, q2.sf) {
        if r1 <= 0.3 {
            agenda(p21, T, r2)
        }
        else if r1 <= 0.3 + 0.5 {
            agenda(p23, T, r2)
        }
        else {
            agenda(sa2, T, r2)
        }
    }
}

var t3: ActionVoid! = {
    if let r1 = rnd(0,1), let r2 = rnd(q3.sc, q3.sf) {
        if r1 < 0.7 {
            agenda(p32, T, r2)
        }
        else {
            agenda(sa3, T, r2)
        }
    }
}

// MARK: Eventos

var ch1: ActionVoid! = {
    contabiliza(f1, f2, f3)
    e(&f1, q1, t1, &perdas1)
    if let r = rnd(q1.ec, q1.ef) {
        agenda(ch1p, T, r)
    }
}

var ch1p: ActionVoid! { ch1 }

var p12: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f1, q1, t1)
    e(&f2, q2, t2, &perdas2)
}

var p13: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f1, q1, t1)
    e(&f3, q3, t3, &perdas3)
}

var p21: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f2, q2, t2)
    e(&f1, q1, t1, &perdas1)
}

var p23: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f2, q2, t2)
    e(&f3, q3, t3, &perdas3)
}

var sa2: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f2, q2, t2)
}

var p32: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f3, q3, t3)
    e(&f2, q2, t2, &perdas2)
}

var sa3: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s(&f3, q3, t3)
}

public func simular() {
    Config.CongruenteLinear.semente = 1
    
    guard let r = rnd(q1.ec, q1.ef) else { return }
    agenda(ch1, T, r)
    
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
    imprimir(q: q1, contador1, perdas1)
    imprimir(q: q2, contador2, perdas2)
    imprimir(q: q3, contador3, perdas3)
    print(
"""
=========================================================
"""
)
}

func imprimir(q: Queue, _ contador: [Double], _ perdas: Int) {
    print(
"""
*******************
Queue:   \(q.n) (G/G/\(q.c)\(q.k == .max ? "" : "/\(q.k)")
Arrival: \(q.ec.format(2)) ... \(q.ef.format(2))
Service: \(q.sc.format(2)) ... \(q.sf.format(2))
*******************
   State               Time               Probability
\(formatCont(contador))

Number of losses: \(perdas)

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
                         + "\t\(($1.element * 100 / total).format(f: 3, 2))\n"
        })
}
