
import Foundation

// MARK: - Random

// gerador de numeros pseudo aleatorios
var random: CongruenteLinear = .init(maxIteracoes: 100000)

// indica se os numeros aleatorios terminaram
var terminou = false

// funcao que busca um aleatorio normalizado
// se nao existir retorna nil
func rnd(_ s: Double, _ e: Double) -> Double? {
    if let r = random.uniformizado() {
        return Tempo(inicio: s, fim: e).tempo(uniformizado: r)
    }
    else {
        terminou = true
        return nil
    }
}
