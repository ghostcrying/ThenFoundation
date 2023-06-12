//
//  CGRect++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import UIKit
import CoreGraphics

extension CGRect: ThenExtensionCompatible { }

extension CGRect {
    
    public init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
    
    public init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5), size: size)
    }
}

public extension CGRect {
    
    static func * (_ lhs: CGRect, _ rhs : CGFloat) -> CGRect {
        return CGRect(x: lhs.minX * rhs, y: lhs.minY * rhs, width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

public extension ThenExtension where T == CGRect {
    
    var top: CGFloat {
        return value.minY
    }
    
    var left: CGFloat {
        return value.minX
    }
    
    var bottom: CGFloat {
        return value.maxY
    }
    
    var right: CGFloat {
        return value.maxX
    }
    
    var center: CGPoint {
        return CGPoint(x: value.midX, y: value.midY)
        // set { value.origin = CGPoint(x: value.minX + newValue.x - value.midX, y: value.minY + newValue.y - value.midY) }
    }
    
    var centerX: CGFloat {
        return value.midX
    }
    
    var centerY: CGFloat {
        return value.midY
    }
}

public extension ThenExtension where T == CGRect {
    
    var bounds: CGRect {
        return CGRect(width: value.width, height: value.height)
    }
}

public extension ThenExtension where T == CGRect {
    
    func scale(_ scale: CGFloat) -> T {
        return value * scale
    }
}

public extension ThenExtension where T == Array<CGRect> {
    
    func scale(_ scale: CGFloat) -> [T.Element] {
        return value.compactMap { $0 * scale }
    }
}
