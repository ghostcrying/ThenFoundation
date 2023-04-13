//
//  URL++.swift
//  ThenFoundation
//
//  Created by 陈卓 on 2023/4/13.
//

import Foundation

public extension URL {
    
    /// adjust 16.0+
    static func filePath(_ path: String) -> URL {
        if #available(iOS 16.0, *) {
            return URL(filePath: path)
        } else {
            return URL(fileURLWithPath: path)
        }
    }
}
