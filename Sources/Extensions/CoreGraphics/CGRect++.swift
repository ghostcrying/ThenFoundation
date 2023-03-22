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
        return base.minY
    }
    
    var left: CGFloat {
        return base.minX
    }
    
    var bottom: CGFloat {
        return base.maxY
    }
    
    var right: CGFloat {
        return base.maxX
    }
    
    var center: CGPoint {
        return CGPoint(x: base.midX, y: base.midY)
        // set { base.origin = CGPoint(x: base.minX + newValue.x - base.midX, y: base.minY + newValue.y - base.midY) }
    }
    
    var centerX: CGFloat {
        return base.midX
    }
    
    var centerY: CGFloat {
        return base.midY
    }
}

public extension ThenExtension where T == CGRect {
    
    var bounds: CGRect {
        return CGRect(width: base.width, height: base.height)
    }
}

public extension ThenExtension where T == CGRect {
    
    func scale(_ scale: CGFloat) -> T {
        return base * scale
    }
}

public extension ThenExtension where T == Array<CGRect> {
    
    func scale(_ scale: CGFloat) -> [T.Element] {
        return base.compactMap { $0 * scale }
    }
}
