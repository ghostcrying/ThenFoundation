//
//  CGPoint++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import CoreGraphics
import UIKit.UIGeometry

//MARK: - Operate
public extension CGPoint {
    
    static func * (_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func / (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        guard rhs.x != 0 && rhs.y != 0 else {
            return CGPoint()
        }
        return CGPoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
}

extension CGPoint: ThenExtensionCompatible { }

public extension ThenExtension where T == CGPoint {
    
    /// CGPoint(x: x.ceil, y: y.ceil)
    var ceil: T { return CGPoint(x: base.x.then.ceil, y: base.y.then.ceil) }
    
    /// CGPoint(x: x.floor, y: y.floor)
    var floor: T { return CGPoint(x: base.x.then.floor, y: base.y.then.floor) }
    
    /// CGPoint(x: x.round, y: y.round)
    var round: T { return CGPoint(x: base.x.then.round, y: base.y.then.round) }
}

public extension ThenExtension where T == CGPoint {
    
    /// distance
    func distance(to point: T) -> CGFloat {
        return CGFloat(sqrt((point.x - base.x) * (point.x - base.x) + (point.y - base.y) * (point.y - base.y)))
    }
    
    /// atan((self.x - point.x) / (self.y - point.y))
    func angle(by point: T) -> CGFloat {
        return atan((base.x - point.x) / (base.y - point.y))
    }
    
    /// the distance of point to line
    /// - Parameters:
    ///   - start: The start of line
    ///   - ended: The ended of line
    /// - returns: 距离, 垂足点
    func distanceToline(_ start: CGPoint, _ ended: CGPoint) -> (distance: CGFloat, point: CGPoint) {
        /// 点线距离公式
        /// d = abs((Ax + By + C)/(sqrtf(A * A + B * B)))
        /// 该公式表示了点(x, y)到直线方程Ax+By+C = 0 的距离
        let a = ended.y - start.y
        let b = start.x - ended.x
        let c = ended.x * start.y - start.x * ended.y
        
        let x = (+b * b * base.x - a * b * base.y - a * c) / (a * a + b * b)
        let y = (-a * b * base.x + a * a * base.y - b * c) / (a * a + b * b)
        
        let distance = abs((a * base.x + b * base.y + c)) / sqrt(a * a + b * b)
        let point = CGPoint(x: x, y: y)
        //
        return (distance, point)
    }
}

public extension ThenExtension where T == CGPoint {
    
    func scale(_ scale: CGFloat) -> T {
        return base * scale
    }
}

public extension ThenExtension where T == Array<CGPoint> {
    
    func scale(_ scale: CGFloat) -> [T.Element] {
        return base.compactMap { $0 * scale }
    }
    
    /// total distance for every two point
    func lineTotalDistance() -> CGFloat {
        guard base.count > 1 else {
            return 0
        }
        var distance: CGFloat = 0
        for i in 1..<base.count {
            distance += base[i].then.distance(to: base[i-1])
        }
        return distance
    }
}

