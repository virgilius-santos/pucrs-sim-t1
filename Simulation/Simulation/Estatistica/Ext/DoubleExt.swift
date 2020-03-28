
import Foundation

extension Double {
    func format(_ n: Int = 2) -> String {
        return String(format: "%2.\(n)f", self)
    }
    
    func map<T>(_ closure: (Double) -> T) -> T {
        return closure(self)
    }
}
