//
//  Double++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import UIKit.UIGeometry
import CoreGraphics

extension Double: ThenExtensionCompatible { }

public extension ThenExtension where T == Double {
    
    /// CGFloat(Darwin.ceil(self))
    var ceil:   CGFloat { return CGFloat(Darwin.ceil(base)) }
    
    /// CGFloat(Darwin.floor(self))
    var floor:  CGFloat { return CGFloat(Darwin.floor(base)) }
    
    /// CGFloat(Darwin.lround(self))
    var round:  CGFloat { return CGFloat(Darwin.lround(base)) }
    
    /// CGPoint(x: self, y: self)
    var point:  CGPoint { return CGPoint(x: base, y: base) }
    
    /// CGSize(width: self, height: self)
    var size:   CGSize  { return CGSize(width: base, height: base) }
    
    /// CGRect(x: 0, y: 0, width: self, height: self)
    var square: CGRect  { return CGRect(x: 0, y: 0, width: base, height: base) }
    
    /// UIEdgeInsets(top: self, left: self, bottom: self, right: self)
    var insets: UIEdgeInsets {
        let fv = CGFloat(base)
        return UIEdgeInsets(top: fv, left: fv, bottom: fv, right: fv)
    }
}

public extension ThenExtension where T == Double {
    
    /// UIFont.systemFont(ofSize: CGFloat(self))
    var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(base)) }
    
    /// UIFont.boldSystemFont(ofSize: CGFloat(self))
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: CGFloat(base)) }
}

public extension ThenExtension where T == Double {
    
    func scale(_ scale: CGFloat) -> CGFloat {
        return CGFloat(base) * scale
    }
}

public extension ThenExtension where T == Array<Double> {
    
    func scale(_ scale: CGFloat) -> [CGFloat] {
        return base.compactMap { CGFloat($0) * scale }
    }
}
