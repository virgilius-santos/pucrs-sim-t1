
import Foundation

public class CongruenteLinear {
    
    private var temProxima: Bool {
        numeroIterecoes < maxIteracoes
    }
    
    /// retorna um valor aleatorio inteiro
    private var valor: UInt {
        let atual = _valor
        updateValues(valor: _valor)
        return atual
    }
    
    private var _valor: UInt = .zero
    
    /// quantidade de randomicos usados
    private var numeroIterecoes: Int = 0
    
    /// quantidade maxima de randomicos
    private let maxIteracoes: Int
    
    /// valores aleatorios fornecidos arbitrariamente
    private let valoresFixos: [Double]
    
    public init(maxIteracoes: Int, valoresFixos: [Double] = []) {
        self.maxIteracoes = maxIteracoes
        self.valoresFixos = valoresFixos
        
        let semente: UInt = Config.CongruenteLinear.semente
        updateValues(valor: semente)
    }
    
    /// retorna um valor aleatorio uniformizado se o numero de iterações for menor que o máximo informado
    func uniformizado() -> Double? {
        
        guard temProxima else { return nil }
        
        numeroIterecoes += 1
        
        if numeroIterecoes - 1 < valoresFixos.count {
            return valoresFixos[numeroIterecoes - 1]
        }
        
        let M: UInt = Config.CongruenteLinear.M
        return valor.double() / M.double()
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
