//
//  CGSize++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import UIKit.UIGeometry
import CoreGraphics

public extension CGSize {
    
    static func * (_ lhs: CGSize, _ rhs : CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

extension CGSize: ThenExtensionCompatible { }

public extension ThenExtension where T == CGSize {
    
    /// CGSize(width: width.ceil, height: height.ceil)
    var ceil: T { return CGSize(width: base.width.then.ceil, height: base.height.then.ceil) }
    
    /// CGSize(width: width.floor, height: height.floor)
    var floor: T { return CGSize(width: base.width.then.floor, height: base.height.then.floor) }
    
    /// CGSize(width: width.round, height: height.round)
    var round: T { return CGSize(width: base.width.then.round, height: base.height.then.round) }
    
    /// CGRect(x: 0, y: 0, width: width, height: height)
    var bounds: CGRect { return CGRect(width: base.width, height: base.height) }
}

public extension ThenExtension where T == CGSize {
        
    /// CGSize(width: self.width * scale, height: self.height * scale)
    func scale(_ scale: CGFloat) -> T {
        return base * scale
    }
    
    /// CGSize(width: self.width * widthScale, height: self.height * heightScale)
    func scale(_ widthScale: CGFloat, _ heightScale: CGFloat) -> T {
        return CGSize(width: base.width * widthScale, height: base.height * heightScale)
    }
}

public extension ThenExtension where T == Array<CGSize> {
    
    func scale(_ scale: CGFloat) -> [T.Element] {
        return base.compactMap { $0 * scale }
    }
}
