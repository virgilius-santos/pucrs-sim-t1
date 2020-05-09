
import Foundation

extension Double {
    func format(f: Int = 2, _ n: Int = 2, p: Int = 0) -> String {
        return String(format: "%\(f).\(n)f", self).leftPadding(toLength: p + f + n, withPad: " ")
    }
}
