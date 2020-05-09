
import Foundation

extension Int {
    func format(_ lenght: Int = 7) -> String {
        return "\(self)".leftPadding(toLength: lenght, withPad: " ")
    }
}
