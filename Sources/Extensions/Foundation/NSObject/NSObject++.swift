//
//  NSObject++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public protocol ClassNameable {
    
    var className: String? { get }
}

public extension ThenExtension where T: ClassNameable {
    
    var className: String? {
        return base.className
    }
}

extension NSObject: ClassNameable {
    
    public var className: String? {
        return "\(self.classForCoder)"
    }
}
