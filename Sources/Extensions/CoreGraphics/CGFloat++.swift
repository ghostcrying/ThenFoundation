//
//  CGFloat++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import UIKit.UIGeometry
import CoreGraphics

extension CGFloat: ThenExtensionCompatible { }

public extension ThenExtension where T == CGFloat {
    
    /// CGFloat(ceilf(Float(self)))
    var ceil: T { return CGFloat(ceilf(Float(value))) }
    
    /// CGFloat(floorf(Float(self)))
    var floor: T { return CGFloat(floorf(Float(value))) }
    
    /// CGFloat(lroundf(Float(self)))
    var round: T { return CGFloat(lroundf(Float(value))) }
    
    /// CGPoint(x: self, y: self)
    var point: CGPoint { return CGPoint(x: value, y: value) }
    
    /// CGSize(width: self, height: self)
    var size: CGSize  { return CGSize(width: value, height: value) }
    
    /// CGRect(x: 0, y: 0, width: self, height: self)
    var square: CGRect  { return CGRect(x: 0, y: 0, width: value, height: value) }
    
    /// UIEdgeInsets(top: self, left: self, bottom: self, right: self)
    var insets: UIEdgeInsets { return UIEdgeInsets(top: value, left: value, bottom: value, right: value) }
}

public extension ThenExtension where T == CGFloat {
    
    func scale(_ scale: CGFloat) -> T {
        return value * scale
    }
}

public extension ThenExtension where T == CGFloat {
    
    /// UIFont.systemFont(ofSize: self)
    var font: UIFont { return UIFont.systemFont(ofSize: value) }
    
    /// UIFont.boldSystemFont(ofSize: self)
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: value) }
}

public extension ThenExtension where T == Array<CGFloat> {
    
    func scale(_ scale: CGFloat) -> [T.Element] {
        return value.compactMap { $0 * scale }
    }
}
