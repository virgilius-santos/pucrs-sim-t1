
import Foundation

// MARK: - Simulador

public class Simulador {
    // MARK: - Tempo

    // tempo de processamento
    private(set) var T = Double.zero

    // MARK: - Random

    // gerador de numeros pseudo aleatorios
    private(set) var random: CongruenteLinear!

    // indica se os numeros aleatorios terminaram
    private var terminou = false

    // MARK: - Eventos

    // indice do evento
    private(set) var index = Int.zero

    // array que armazenas os eventos NÃO processados
    private(set) var eventos = [Evento]()

    // array que armazenas os eventos processados
    private(set) var processados = [Evento]()

    // evento em processados
    private(set) var eventoEmProcessamento: Evento!

    // MARK: - Filas

    // filas registradas
    private var filasDict = [String: Fila]()

    // qtds das filas
    private(set) var filas = [Fila]()

    public init(random rnd: CongruenteLinear,
                filas fs: [Fila] = [Fila]()) {
        random = rnd
        T = Double.zero
        filas = fs
    }

    public func simular() {
        filas.forEach { configurarFila(fila: $0) }
        processar()
        imprimir()
    }

    private func configurarFila(fila novaFila: Fila) {
        // realiza agendamento nos eventos
        func agenda(_ f: @escaping ActionVoid, _ t: Double, _ tipo: TipoDeFila) {
            let evt: Evento = (index, f, T + t, true, tipo)
            eventos.append(evt)
            eventos.sort(by: { $0.t > $1.t })
            index += 1
        }

        // contabiliza os tempos
        func contabilizarTempo() {
            let delta: Double = eventoEmProcessamento.t - T

            filas.forEach { $0.atualizarContador(delta: delta) }

            T += delta
        }

        // funcao que busca um aleatorio normalizado
        // se nao existir retorna nil
        func rnd(_ inicio: Double, _ fim: Double) -> Double? {
            if let r = random.uniformizado() {
                return (fim - inicio) * r + inicio
            }
            terminou = true
            return nil
        }

        novaFila.randomDataSource = rnd
        novaFila.agendarEvento = agenda
        novaFila.contabilizarTempo = contabilizarTempo
        novaFila.filaDataSource = { [weak self] in self?.filasDict[$0] }

        filasDict[novaFila.nome] = novaFila
    }

    private func processar() {
        while
            terminou == false,
            random.temProxima,
            let ultimoEventoDaLista = eventos.popLast() {
            eventoEmProcessamento = ultimoEventoDaLista
            ultimoEventoDaLista.f()
            processados.append(ultimoEventoDaLista)
            eventoEmProcessamento = nil
        }
    }
}

// MARK: - Imprimir

extension Simulador {
    func imprimir() {
        func formatCont(_ contador: [Double]) -> String {
            let total = contador.reduce(0, +)
            return contador
                .enumerated()
                .reduce("") { $0 + "\t" + "\($1.offset.format(4))"
                    + "\t" + "\($1.element.format(f: 10, 4))"
                    + "\t\t\t\(($1.element * 100 / total).format(f: 3, 2))\n"
                }
        }

        func imprimir(q: Fila) {
            print(
                """
                *******************
                Fila:   \(q.nome) (G/G/\(q.kendall.c)\(q.kendall.k == .max ? "" : "/\(q.kendall.k)")
                Arrival: \(q.taxaEntrada.inicio.format(2, p: 2)) ... \(q.taxaEntrada.fim.format(2, p: 2))
                Service: \(q.taxaSaida.inicio.format(2, p: 2)) ... \(q.taxaSaida.fim.format(2, p: 2))
                *******************
                State           Time             Probability
                \(formatCont(q.contador))

                Number of losses: \(q.perdas)

                *******************

                """
            )
        }

        print(
            """
            =========================================================
            ===============    REPORT (semente: \(Config.CongruenteLinear.semente))   ======================
            =========================================================
            """
        )
        filas.forEach { imprimir(q: $0) }

        print("Simulation average time: \(T.format(f: 6, 2, p: 7))")

        print("=========================================================")
    }
}
