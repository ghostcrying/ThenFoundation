//
//  ThenWeakRef.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

public struct ThenWeakRef<T: NSObjectProtocol> {
    
    public weak var target: T?
    
    public init(target: T?) {
        self.target = target
    }
}
