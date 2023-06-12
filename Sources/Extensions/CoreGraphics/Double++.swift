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
    var ceil:   CGFloat { return CGFloat(Darwin.ceil(value)) }
    
    /// CGFloat(Darwin.floor(self))
    var floor:  CGFloat { return CGFloat(Darwin.floor(value)) }
    
    /// CGFloat(Darwin.lround(self))
    var round:  CGFloat { return CGFloat(Darwin.lround(value)) }
    
    /// CGPoint(x: self, y: self)
    var point:  CGPoint { return CGPoint(x: value, y: value) }
    
    /// CGSize(width: self, height: self)
    var size:   CGSize  { return CGSize(width: value, height: value) }
    
    /// CGRect(x: 0, y: 0, width: self, height: self)
    var square: CGRect  { return CGRect(x: 0, y: 0, width: value, height: value) }
    
    /// UIEdgeInsets(top: self, left: self, bottom: self, right: self)
    var insets: UIEdgeInsets {
        let fv = CGFloat(value)
        return UIEdgeInsets(top: fv, left: fv, bottom: fv, right: fv)
    }
}

public extension ThenExtension where T == Double {
    
    /// UIFont.systemFont(ofSize: CGFloat(self))
    var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(value)) }
    
    /// UIFont.boldSystemFont(ofSize: CGFloat(self))
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: CGFloat(value)) }
}

public extension ThenExtension where T == Double {
    
    func scale(_ scale: CGFloat) -> CGFloat {
        return CGFloat(value) * scale
    }
}

public extension ThenExtension where T == Array<Double> {
    
    func scale(_ scale: CGFloat) -> [CGFloat] {
        return value.compactMap { CGFloat($0) * scale }
    }
}
