
import Foundation

// MARK: - Tempo

// tempo de processamento
private(set) var T = Double.zero

// qtds das filas
private(set) var filas = [Fila]()

// MARK: - NovoSimulador

public final class NovoSimulador {
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
