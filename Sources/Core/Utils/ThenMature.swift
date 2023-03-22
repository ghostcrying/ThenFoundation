//
//  ThenMature.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

/// 自动增长
public struct ThenMature {
    
    private static var currentId: Int = 0
    
    public static var id: Int {
        currentId += 1
        return currentId
    }
}

