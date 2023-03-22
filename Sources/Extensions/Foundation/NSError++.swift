//
//  NSError++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public extension NSError {
    
    static let NormalErrorDomain = "com.then.domain"
    
    convenience init(domain: String = NormalErrorDomain, code: Int = -1, description: String? = nil) {
        if let desc = description {
            self.init(domain: domain, code: code, userInfo: ["statusCode": code, NSLocalizedDescriptionKey: desc])
        } else {
            self.init(domain: domain, code: code, userInfo: ["statusCode": code])
        }
    }
}
