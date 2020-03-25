
import Foundation

public struct Kendall {
    /// distribuição das chegadas de clientes
    let a: String
    /// distribuição dos atendimentos de clientes
    let b: String
    /// número de servidores da fila
    let c: Int
    /// capacidade da fila
    let k: Int
    ///  tamanho da população
    public let n: Int
    /// política de atendimento
    let d: Int
    
    public init(
        a: String = "G",
        b: String = "G",
        c: Int = .max,
        k: Int = .max,
        n: Int = 10,
        d: Int = .zero) {
        
        self.a = a
        self.b = b
        self.c = c
        self.k = k
        self.n = n
        self.d = d
    }
}
