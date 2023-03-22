//
//  Crypto+Data.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif
import CommonCrypto

public extension ThenExtension where T == Data {
    
    var sha1Value: String {
        return base.sha1Value
    }
}

public extension Data {
    //
    var sha1Value: String {
        
        if #available(iOS 13.0, *) {
            return Insecure
                .SHA1
                .hash(data: self)
                .map { String(format: "%02hhx", $0) }
                .joined()
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1((self as NSData).bytes, CC_LONG(count), &digest)
            let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
            for byte in digest {
                output.appendFormat("%02x", byte)
            }
            return output as String
        }
    }
    
}
