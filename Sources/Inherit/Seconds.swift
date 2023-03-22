//
//  Seconds.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation
import CoreGraphics

public let Minute:  Second = Second(60)
public let Hour:    Second = Second(60 * 60)
public let Day:     Second = Second(60 * 60 * 24)

public func Minute(_ multiplie: Int) -> Second { return Minute * multiplie }
public func Hour(_ multiplie: Int) ->   Second { return Hour * multiplie }
public func Day(_ multiplie: Int) ->    Second { return Day * multiplie }

public struct Second {
    
    var sec: Int
    
    public init(_ second: Int) {
        sec = second
    }
}

public extension Second {
    
    var timeInterval: TimeInterval {
        return TimeInterval(sec)
    }
}

public extension Second {
    
    static func + (lhs: Second, rhs: Second) -> Second {
        return Second(lhs.sec + rhs.sec)
    }
    
    static func += (lhs: inout Second, rhs: Second) {
        lhs.sec += rhs.sec
    }
    
    static func - (lhs: Second, rhs: Second) -> Second {
        return Second(lhs.sec - rhs.sec)
    }
    
    static func -= (lhs: inout Second, rhs: Second) {
        lhs.sec -= rhs.sec
    }
    
    static func * (lhs: Second, rhs: Second) -> Second {
        return Second(lhs.sec * rhs.sec)
    }
    
    static func *= (lhs: inout Second, rhs: Second) {
        lhs.sec *= rhs.sec
    }
    
    static func / (lhs: Second, rhs: Second) -> Second {
        return Second(lhs.sec / rhs.sec)
    }
    
    static func /= (lhs: inout Second, rhs: Second) {
        lhs.sec /= rhs.sec
    }
    
    prefix static func + (x: Second) -> Second {
        return Second(+x.sec)
    }
    
    prefix static func - (x: Second) -> Second {
        return Second(-x.sec)
    }
    
    static func * (lhs: Int, rhs: Second) -> Second {
        return Second(lhs * rhs.sec)
    }
    
    static func * (lhs: Second, rhs: Int) -> Second {
        return Second(lhs.sec * rhs)
    }
}

public extension Second {
    
    var day: Int { return sec / Day.sec }
    
    var hour: Int { return (sec % Day.sec) / Hour.sec }
    
    var minute: Int { return (sec % Hour.sec) / Minute.sec }
    
    var second: Int { return sec % Minute.sec }
}

public extension Int {
    
    var second: Second { return Second(self) }
}

public extension Float {
    
    var second: Second { return Second(Int(self)) }
}

public extension CGFloat {
    
    var second: Second { return Second(Int(self)) }
}

public extension Double {
    
    var second: Second { return Second(Int(self)) }
}
