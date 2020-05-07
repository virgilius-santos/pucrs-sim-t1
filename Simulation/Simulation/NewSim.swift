
import Foundation

struct Queue {
    var n: String
    var c: Int
    var k: Int
    var ec: Double
    var ef: Double
    var sc: Double
    var sf: Double
}

var T: Double = .zero

var q1 = Queue(n: "Q1", c: 1, k: .max, ec: 1, ef: 4, sc: 1, sf: 1.5)
var f1: Int = .zero
var contador1: [Double] = []
var perdas1: Int = .zero

var q2 = Queue(n: "Q2", c: 3, k: 5, ec: 0, ef: 0, sc: 5, sf: 10)
var f2: Int = .zero
var contador2: [Double] = []
var perdas2: Int = .zero

var q3 = Queue(n: "Q3", c: 2, k: 8, ec: 0, ef: 0, sc: 10, sf: 20)
var f3: Int = .zero
var contador3: [Double] = []
var perdas3: Int = .zero

var index = Int.zero

typealias Event = (i: Int, f: ActionVoid, t: Double, a: Bool)
var eventos = [Event]()
var ultimo: Event!

var terminou = false



var random: CongruenteLinear = {
    .init(maxIteracoes: 100000)
}()

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


var agenda: ((_ f: @escaping ActionVoid, _ T_old: Double, _ t: Double) -> Void) =
    { f, T_old, t in
        let evt: Event = (index, f, T + t, true)
        eventos.append(evt)
        eventos.sort(by: { $0.t > $1.t })
        index += 1
    }


var contabiliza: ((_ f1: Int, _ f2: Int, _ f3: Int) -> Void) =
    { (f1: Int, f2: Int, f3: Int) in
        
        func update(cont: inout [Double], f: Int, temp: Double) {
            if f < cont.count {
                cont[f] += temp
            }
            else {
                cont.append(temp)
            }
        }
        
        let delta: Double = ultimo.t - T
        
        update(cont: &contador1, f: f1, temp: delta)
        update(cont: &contador2, f: f2, temp: delta)
        update(cont: &contador3, f: f3, temp: delta)
        T += delta
        if T != contador1.reduce(0, +) || T != contador2.reduce(0, +) || T != contador3.reduce(0, +) {
            fatalError("time wrong")
        }
    }


var e1: ActionVoid! = {
    f1 += 1
    if f1 <= q1.c {
        if let r1 = rnd(0,1), let r2 = rnd(q1.sc, q1.sf) {
            if r1 < 0.8 {
                agenda(p12, T, r2)
            }
            else {
                agenda(p13, T, r2)
            }
        }
    }
}

var s1: ActionVoid! = {
    f1 -= 1
    if f1 >= q1.c {
        if let r1 = rnd(0,1), let r2 = rnd(q1.sc, q1.sf) {
            if r1 < 0.8 {
                agenda(p12, T, r2)
            }
            else {
                agenda(p13, T, r2)
            }
        }
    }
}

var e2: ActionVoid! = {
    if f2 < q2.k {
        f2 += 1
        if f2 <= q2.c {
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
    }
    else {
        perdas2 += 1
    }
}

var s2: ActionVoid! = {
    f2 -= 1
    if f2 >= q2.c {
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
}

var e3: ActionVoid! = {
    if f3 < q3.k {
        f3 += 1
        if f3 <= q3.c {
            if let r1 = rnd(0,1), let r2 = rnd(q3.sc, q3.sf) {
                if r1 < 0.7 {
                    agenda(p32, T, r2)
                }
                else {
                    agenda(sa3, T, r2)
                }
            }
        }
    }
    else {
        perdas3 += 1
    }
}

var s3: ActionVoid! = {
    f3 -= 1
    if f3 >= q3.c {
        if let r1 = rnd(0,1), let r2 = rnd(q3.sc, q3.sf) {
            if r1 < 0.7 {
                agenda(p32, T, r2)
            }
            else {
                agenda(sa3, T, r2)
            }
        }
    }
}

var ch1: ActionVoid! = {
    contabiliza(f1, f2, f3)
    e1()
    if let r = rnd(q1.ec, q1.ef) {
        agenda(ch1p, T, r)
    }
}

var ch1p: ActionVoid! { ch1 }

var p12: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s1()
    e2()
}

var p13: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s1()
    e3()
}

var p21: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s2()
    e1()
}

var p23: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s2()
    e3()
}

var sa2: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s2()
}

var p32: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s3()
    e2()
}

var sa3: ActionVoid! = {
    contabiliza(f1, f2, f3)
    s3()
}

public func simular() {
    Config.CongruenteLinear.semente = 1
    var passados = [(i: Int, f: ActionVoid, t: Double, a: Bool)]()
    guard let r = rnd(q1.ec, q1.ef) else { return }
    agenda(ch1, T, r)
    
    while
        terminou == false,
        random.temProxima, let ult = eventos.popLast()
    {
        ultimo = ult
        ult.f()
        passados.append(ult)
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
        .reduce("",
                {
                    $0
                        + "\t" + "\($1.offset.format(4))"
                        + "\t" + "\($1.element.format(f: 10, 4))"
                        + "\t\(($1.element * 100 / total).format(f: 3, 2))\n"
                    
        })
}
