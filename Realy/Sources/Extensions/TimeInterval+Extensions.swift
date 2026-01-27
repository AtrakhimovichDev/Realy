import Foundation

extension TimeInterval {
    
    var nanoseconds: UInt64 {
        UInt64(self * 1_000_000_000)
    }
}

