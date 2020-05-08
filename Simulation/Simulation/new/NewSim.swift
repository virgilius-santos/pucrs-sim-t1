
import Foundation

// MARK: - Filas

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

public func simular() {
    
    q1.t = { q in
        if let r1 = rnd(0,1), let r2 = rnd(q.sc, q.sf) {
            if r1 < 0.8 {
                agenda(q.p(q2), r2)
            }
            else {
                agenda(q.p(q3), r2)
            }
        }
    }
    
    q2.t = { q in
        if let r1 = rnd(0,1), let r2 = rnd(q.sc, q.sf) {
            if r1 <= 0.3 {
                agenda(q.p(q1), r2)
            }
            else if r1 <= 0.3 + 0.5 {
                agenda(q.p(q3), r2)
            }
            else {
                agenda(q.p(), r2)
            }
        }
    }
    
    q3.t = { q in
        if let r1 = rnd(0,1), let r2 = rnd(q.sc, q.sf) {
            if r1 < 0.7 {
                agenda(q.p(q2), r2)
            }
            else {
                agenda(q.p(), r2)
            }
        }
    }
    
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
