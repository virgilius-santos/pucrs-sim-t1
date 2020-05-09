
import Foundation

public enum Config {
    public enum CongruenteLinear {
        public static var semente: UInt = 29
        public static var a: UInt = 1_140_671_485
        public static var c: UInt = 12_820_163
        public static var M = UInt(truncating: NSDecimalNumber(decimal: pow(2, 24)))
    }
}
