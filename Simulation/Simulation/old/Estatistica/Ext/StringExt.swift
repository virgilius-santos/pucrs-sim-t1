
import Foundation

extension String {
    func format(_ lenght: Int = 5) -> String {
        return self.leftPadding(toLength: lenght, withPad: " ")
    }
    
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
