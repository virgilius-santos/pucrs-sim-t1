
import Foundation

public struct Tempo {
    let inicio: Double
    let fim: Double
    
    public init(inicio: Double, fim: Double) {
        self.inicio = inicio
        self.fim = fim
    }
    
    /**
     função usada para retornar o tempo a partir de um valor uniformazado
     - parameter uniformizado: valor entre zero e um
     
     - returns: um valor entre o valor inicial e fim
     */
    func tempo(uniformizado: Double) -> Double {
        (fim - inicio) * uniformizado + inicio
    }
}
