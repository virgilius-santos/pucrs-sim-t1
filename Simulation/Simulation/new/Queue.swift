
import Foundation

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
    
    var t: ((Queue) -> Void)?
    
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
    
    // MARK: Função saidas das filas
    
    func s() {
        f -= 1
        if f >= c { t?(self) }
    }
    
    // MARK: Função de entradas das filas
    
    func e() {
        if f < k {
            f += 1
            if f <= c { t?(self) }
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
