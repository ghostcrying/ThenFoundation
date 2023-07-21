//
//  Bytes.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation
import CoreGraphics

public extension ThenBytes {
    
    static let KB = ThenBytes(1024)
    static let MB = 1024 * KB
    static let GB = 1024 * MB
    static let TB = 1024 * GB
    
    @inlinable
    static func KB(_ multiplie: UInt64) -> ThenBytes {
        KB * multiplie
    }
    
    @inlinable
    static func MB(_ multiplie: UInt64) -> ThenBytes {
        MB * multiplie
    }
    
    @inlinable
    static func GB(_ multiplie: UInt64) -> ThenBytes {
        GB * multiplie
    }
    
    @inlinable
    static func TB(_ multiplie: UInt64) -> ThenBytes {
        TB * multiplie
    }
}

public struct ThenBytes {
    
    public private(set) var bytes: UInt64
    
    public init(_ bytes: UInt64) {
        self.bytes = bytes
    }
}

extension ThenBytes: CustomStringConvertible {
    
    public var description: String {
        let cb = [(ThenBytes.TB, "T"), (ThenBytes.GB, "G"), (ThenBytes.MB, "M"), (ThenBytes.KB, "K")]
        guard let c = cb.filter({ $0.0.bytes <= bytes }).first else {
            return "\(bytes)B"
        }
        return String(format: "%.2f%@", (Double(bytes) / Double(c.0.bytes)), c.1)
    }
}

extension ThenBytes: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(bytes)B"
    }
}

extension ThenBytes: Equatable {
    
    public static func == (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes == rhs.bytes
    }
    
    public static func != (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes != rhs.bytes
    }
}

extension ThenBytes: Comparable {
    
    public static func < (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes < rhs.bytes
    }
    
    public static func <= (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes <= rhs.bytes
    }
    
    public static func > (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes > rhs.bytes
    }
    
    public static func >= (lhs: ThenBytes, rhs: ThenBytes) -> Bool {
        return lhs.bytes >= rhs.bytes
    }
}

public extension ThenBytes {
    
    static func + (lhs: ThenBytes, rhs: ThenBytes) -> ThenBytes {
        return ThenBytes(lhs.bytes + rhs.bytes)
    }
    
    static func += (lhs: inout ThenBytes, rhs: ThenBytes) {
        lhs.bytes += rhs.bytes
    }
    
    static func - (lhs: ThenBytes, rhs: ThenBytes) -> ThenBytes {
        return ThenBytes(lhs.bytes - rhs.bytes)
    }
    
    static func -= (lhs: inout ThenBytes, rhs: ThenBytes) {
        lhs.bytes -= rhs.bytes
    }
    
    static func * (lhs: ThenBytes, rhs: ThenBytes) -> ThenBytes {
        return ThenBytes(lhs.bytes * rhs.bytes)
    }
    
    static func *= (lhs: inout ThenBytes, rhs: ThenBytes) {
        lhs.bytes *= rhs.bytes
    }
    
    static func / (lhs: ThenBytes, rhs: ThenBytes) -> ThenBytes {
        return ThenBytes(lhs.bytes / rhs.bytes)
    }
    
    static func /= (lhs: inout ThenBytes, rhs: ThenBytes) {
        lhs.bytes /= rhs.bytes
    }
    
    prefix static func + (x: ThenBytes) -> ThenBytes {
        return ThenBytes(+x.bytes)
    }
    
    static func * (lhs: UInt64, rhs: ThenBytes) -> ThenBytes {
        return ThenBytes(lhs * rhs.bytes)
    }
    
    static func * (lhs: ThenBytes, rhs: UInt64) -> ThenBytes {
        return ThenBytes(lhs.bytes * rhs)
    }
}

public extension ThenBytes {
    
    var tb: UInt64 { return bytes / ThenBytes.TB.bytes }
    
    var gb: UInt64 { return (bytes % ThenBytes.TB.bytes) / ThenBytes.GB.bytes }
    
    var mb: UInt64 { return (bytes % ThenBytes.GB.bytes) / ThenBytes.MB.bytes }
    
    var kb: UInt64 { return (bytes % ThenBytes.MB.bytes) / ThenBytes.KB.bytes }
    
    var bt: UInt64 { return (bytes % ThenBytes.KB.bytes) }
}

public extension UInt64 {
    
    var bytes: ThenBytes { return ThenBytes(self) }
}

public extension Int {
    
    var bytes: ThenBytes { return ThenBytes(UInt64(self)) }
}
