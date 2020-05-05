
import Foundation

public enum Config {
    public enum CongruenteLinear {
        public static var semente: UInt = 29
        public static var a: UInt = 1140671485
        public static var c: UInt = 12820163
        public static var M: UInt = UInt(truncating: NSDecimalNumber(decimal: pow(2, 24)))
    }
    
    public enum Evento {
        
        /// configura a chegada em uma fila
        case chegada(fila: Fila)
        
        /// configura a transicao de uma fila de origem para uma fila de destino
        case transicao(origem: Fila, destino: Fila)
        
        /// configura a transicao de uma fila de origem para uma fila de destino com posibilidade de saida
        case transicaoPonderada(origem: Fila, destino: Fila, taxa: Double)
        
        /// configura a transicao de uma fila de origem para uma fila de destino
        ///  com posibilidade de saida ou retorno para a mesma fila
        case transicaoPonderadaComRetorno(origem: Fila, destino: Fila, saida: Double, retorno: Double)
        
        /// configura a saída de uma fila
        case saida(fila: Fila)
        
        /// configura a transicao de uma fila de origem para uma fila de destino
        ///  com posibilidade de saida ou retorno para a mesma fila
        case transicaoRede(origem: Fila,
            destinos: [(fila: Fila, probabilidade: Double)])
        
        /// retorna as filas que foram passadas para a configuração
        var filas: [Fila] {
            switch self {
                case let .chegada(fila):
                    return [fila]
                case let .transicao(filaEntrada, filaSaida):
                    return [filaEntrada, filaSaida]
                case let .transicaoPonderada(filaEntrada, filaSaida, _):
                    return [filaEntrada, filaSaida]
                case let .transicaoPonderadaComRetorno(filaEntrada, filaSaida, _, _):
                    return [filaEntrada, filaSaida]
                case let .saida(fila):
                    return [fila]
                case let .transicaoRede(filaEntrada, destinos):
                    return [filaEntrada] + destinos.map { $0.fila }
            }
        }
    }
}
