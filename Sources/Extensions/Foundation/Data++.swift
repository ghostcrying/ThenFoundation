//
//  Data++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//

import Foundation

extension Data: ThenExtensionCompatible { }

public extension ThenExtension where T == Data {
    
    /// Data -> Hex [%02hhx]
    var hexString: String {
        return base.withUnsafeBytes { $0.reduce("") { $0 + String(format: "%02hhx", $1) } }
    }
    
    var base64Value: String {
        let base64String = base.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let real = base64String.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
        return real
    }
    
    var bytes: [UInt8] {
        [UInt8](base)
    }
}
