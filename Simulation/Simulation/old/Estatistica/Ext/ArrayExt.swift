
import Foundation

extension Array where Element == (index: Int, tempo: Double, pcent: Double) {
    var maiorTempo: Int {
        self.reduce(0, { Swift.max($0, $1.tempo) })
            .map { $0.format(4).count }
    }
    
    var maiorIndex: Int {
        self.reduce(0, { Swift.max($0, $1.index) })
            .map { "\($0)".count }
    }
    
    func descreverContadores() -> String {
        return self.map { arg -> String in
            "\t\(arg.index.format(maiorIndex))\t"
                + "\(arg.tempo.format(4).format(maiorTempo))\t"
                + "\(arg.pcent.format(2).format(6))"
        }
        .reduce("", { "\($0)\t\($1)\n" })
    }
}

extension Array where Element == Estatistica {
    var mediaDasPerdas: Double {
        self.map { $0.perdas }.average
    }

    var mediaDosTempos: Double {
        self.map { $0.tempo }.average
    }
    
    var contadores: [(index: Int, tempo: Double, pcent: Double)] {
        
        let mediaDosTempos = self.mediaDosTempos
        
        let contadoresAgrupados: [Int : [Double]] = self
            .reduce(into: [Int : [Double]]()) { (dict, est) in
                est.contatores.forEach { dict[$0.key] = (dict[$0.key] ?? []) + [$0.value] }
        }
        
        let mediasDosContadores: [Int : Double] = contadoresAgrupados
            .reduce(into: [Int : Double]()) { (dict, array) in
                dict[array.key] = (dict[array.key] ?? 0) + array.value.average
        }
        
        let contadoresOrdenados: [(key: Int, value: Double)] = mediasDosContadores
            .sorted(by: { $0.key < $1.key })
        
        return contadoresOrdenados
            .map { ($0.key, $0.value, ($0.value / mediaDosTempos) * 100) }
    }
}

public extension Array where Element == Fila {

    var dictionaries: [Int: [Fila]] {
        self.reduce(into: [Int: [Fila]](),
                    { $0[$1.id] = ($0[$1.id] ?? []) + [$1] }
        )
    }
    
    var estatisticas: [Estatistica] {
        self.compactMap { fila in
            fila.dados.estatisticas.sorted(by: { $0.tempo < $1.tempo }).last
        }
    }
    
    var tipoDeFila: String {
        self.isEmpty ? "" : "\(self[0].tipoDeFila)"
    }
    
    var kendall: String {
        self.isEmpty
            ? ""
            : "\(self[0].kendall.a)/\(self[0].kendall.b)"
            + "/\(self[0].kendall.c)/\(self[0].kendall.k), "
            + "usando \(self[0].kendall.n) aleatorios"
    }
    
    var chegadas: String {
        self.isEmpty
            ? ""
            : "\(self[0].taxaEntrada.inicio)...\(self[0].taxaEntrada.fim)"
    }
    
    var atendimentos: String {
        self.isEmpty
            ? ""
            : "\(self[0].taxaSaida.inicio)...\(self[0].taxaSaida.fim)"
    }
    
    var perdas: String {
        self.isEmpty
            ? ""
            : "\(self[0].taxaSaida.inicio)...\(self[0].taxaSaida.fim)"
    }
    
    var id: String {
        self.isEmpty ? "" : "\(self[0].id)"
    }
    
    /// imprime no prompt as estatisticas
    func imprimir() {
        print("")
        let dictionaries = self.dictionaries
        var str = String()
        str += "--start--\n\n"
        str += "Tipo de Fila: \(tipoDeFila)\n\n"
        dictionaries.forEach { (key, filas) in
            let est = filas.estatisticas
            let cont = est.contadores
            let chegadas = filas.chegadas
            str += "Fila \(filas.id)\n"
            str += "\t\(filas.kendall)\n"
            if !chegadas.contains("0.0...0.0") {
                str += "\tchegadas entre \(chegadas), "
                str += "atendimento entre \(filas.atendimentos)\n\n"
            }
            else {
                str += "\tatendimento entre \(filas.atendimentos)\n\n"
            }
            str += "\tperdas: \(est.mediaDasPerdas)\t"
            str += "tempo: \(est.mediaDosTempos.format(4))\n\n"
            str += "\tcontadores: [\n\(cont.descreverContadores())\t]\n\n"
        }
        str += "--end--\n"
        print(str)
        print("")
    }
}
