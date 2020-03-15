
import Foundation

public class CongruenteLinear {

    /// retorna um valor aleatorio inteiro
    var valor: UInt {
        let atual = _valor
        updateValues(valor: _valor)
        return atual
    }
    
    /// retorna um valor aleatorio uniformizado
    var uniformizado: Double {
        let atual = _valor
        let M: UInt = Config.CongruenteLinear.M
        updateValues(valor: _valor)
        return atual.double() / M.double()
    }
    
    private var _valor: UInt = .zero
    
    public init() {
        let semente: UInt = Config.CongruenteLinear.semente
        updateValues(valor: semente)
    }
    
    /// calcula o proximo pseudo aleatorio
    private func updateValues(valor: UInt) {
        let a: UInt = Config.CongruenteLinear.a
        let x: UInt = valor
        let c: UInt = Config.CongruenteLinear.c
        let M: UInt = Config.CongruenteLinear.M
        _valor = (a * x + c) % M
    }
}

extension UInt {
    func double() -> Double {
        return Double(self)
    }
}
