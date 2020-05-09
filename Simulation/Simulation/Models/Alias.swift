
import Foundation

typealias ActionTime = (Double) -> Void
typealias ActionVoid = () -> Void

typealias Evento = (i: Int, f: ActionVoid, t: Double, a: Bool, tipo: TipoDeFila)

typealias Agendamento = (_ f: @escaping ActionVoid, _ t: Double, TipoDeFila) -> Void
