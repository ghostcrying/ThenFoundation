//
//  Bytes.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation
import CoreGraphics

public let KB_P:    ThenBytes = ThenBytes(1024)
public let MB_P:    ThenBytes = 1024 * KB_P
public let GB_P:    ThenBytes = 1024 * MB_P
public let TB_P:    ThenBytes = 1024 * GB_P

public func MB_P(_ multiplie: UInt64) ->   ThenBytes { return MB_P * multiplie }
public func GB_P(_ multiplie: UInt64) ->   ThenBytes { return GB_P * multiplie }
public func TB_P(_ multiplie: UInt64) ->   ThenBytes { return TB_P * multiplie }

public struct ThenBytes {
    
    public private(set) var bytes: UInt64
    
    public init(_ bytes: UInt64) {
        self.bytes = bytes
    }
}

extension ThenBytes: CustomStringConvertible {
    
    public var description: String {
        let cb = [(TB_P, "T"), (GB_P, "G"), (MB_P, "M"), (KB_P, "K")]
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
    
    var tb: UInt64 { return bytes / TB_P.bytes }
    
    var gb: UInt64 { return (bytes % TB_P.bytes) / GB_P.bytes }
    
    var mb: UInt64 { return (bytes % GB_P.bytes) / MB_P.bytes }
    
    var kb: UInt64 { return (bytes % MB_P.bytes) / KB_P.bytes }
    
    var bt: UInt64 { return bytes % KB_P.bytes }
}

public extension UInt64 {
    
    var bytes: ThenBytes { return ThenBytes(self) }
}

public extension Int {
    
    var bytes: ThenBytes { return ThenBytes(UInt64(self)) }
}
