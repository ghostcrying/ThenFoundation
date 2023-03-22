//
//  Int++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import UIKit.UIGeometry
import CoreGraphics

extension Int: ThenExtensionCompatible { }

public extension ThenExtension where T == Int {
    
    var isEven: Bool { return base % 2 == 0 }
    
    var isOdd: Bool { return base % 2 != 0 }
    
    /// CGPoint(x: self, y: self)
    var point: CGPoint { return CGPoint(x: base, y: base) }
    
    /// CGSize(width: self, height: self)
    var size: CGSize  { return CGSize(width: base, height: base) }
    
    /// CGRect(x: 0, y: 0, width: self, height: self)
    var square: CGRect  { return CGRect(x: 0, y: 0, width: base, height: base) }
    
    /// UIEdgeInsets(top: self, left: self, bottom: self, right: self)
    var insets: UIEdgeInsets {
        let fv = CGFloat(base)
        return UIEdgeInsets(top: fv, left: fv, bottom: fv, right: fv)
    }
    
    /// call closure in 0..<self
    func repeating(_ closure: () -> ()) {
        for _ in 0..<base { closure() }
    }
    
    func repeating(_ closure: @autoclosure () -> ()) {
        for _ in 0..<base { closure() }
    }
    
    func repeating(_ closure: (T) -> ()) {
        for index in 0..<base { closure(index) }
    }
    
    func pow(_ y: T) -> T {
        return (Foundation.pow(Decimal(base), y) as NSDecimalNumber).intValue
    }
    
    func range() -> Range<Int> {
        return 0..<base
    }
}

public extension ThenExtension where T == Int {

    func scale(_ scale: CGFloat) -> CGFloat {
        return CGFloat(base) * scale
    }
}

public extension ThenExtension where T == Int {
    
    /// UIFont.systemFont(ofSize: self)
    var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(base)) }
    
    /// UIFont.boldSystemFont(ofSize: self)
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: CGFloat(base)) }
}

public extension ThenExtension where T == Array<Int> {
    
    func scale(_ scale: CGFloat) -> [CGFloat] {
        return base.compactMap { CGFloat($0) * scale }
    }
}
