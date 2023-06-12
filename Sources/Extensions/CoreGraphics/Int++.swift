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
    
    var isEven: Bool { return value % 2 == 0 }
    
    var isOdd: Bool { return value % 2 != 0 }
    
    /// CGPoint(x: self, y: self)
    var point: CGPoint { return CGPoint(x: value, y: value) }
    
    /// CGSize(width: self, height: self)
    var size: CGSize  { return CGSize(width: value, height: value) }
    
    /// CGRect(x: 0, y: 0, width: self, height: self)
    var square: CGRect  { return CGRect(x: 0, y: 0, width: value, height: value) }
    
    /// UIEdgeInsets(top: self, left: self, bottom: self, right: self)
    var insets: UIEdgeInsets {
        let fv = CGFloat(value)
        return UIEdgeInsets(top: fv, left: fv, bottom: fv, right: fv)
    }
    
    /// call closure in 0..<self
    func repeating(_ closure: () -> ()) {
        for _ in 0..<value { closure() }
    }
    
    func repeating(_ closure: @autoclosure () -> ()) {
        for _ in 0..<value { closure() }
    }
    
    func repeating(_ closure: (T) -> ()) {
        for index in 0..<value { closure(index) }
    }
    
    func pow(_ y: T) -> T {
        return (Foundation.pow(Decimal(value), y) as NSDecimalNumber).intValue
    }
    
    func range() -> Range<Int> {
        return 0..<value
    }
}

public extension ThenExtension where T == Int {

    func scale(_ scale: CGFloat) -> CGFloat {
        return CGFloat(value) * scale
    }
}

public extension ThenExtension where T == Int {
    
    /// UIFont.systemFont(ofSize: self)
    var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(value)) }
    
    /// UIFont.boldSystemFont(ofSize: self)
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: CGFloat(value)) }
}

public extension ThenExtension where T == Array<Int> {
    
    func scale(_ scale: CGFloat) -> [CGFloat] {
        return value.compactMap { CGFloat($0) * scale }
    }
}
