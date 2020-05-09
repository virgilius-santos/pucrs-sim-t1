
import Foundation

public enum Config {
    public enum CongruenteLinear {
        public static var semente: UInt = 29
        public static var a: UInt = 1140671485
        public static var c: UInt = 12820163
        public static var M: UInt = UInt(truncating: NSDecimalNumber(decimal: pow(2, 24)))
    }
}
