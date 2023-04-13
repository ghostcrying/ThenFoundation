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
    
    /// iOS 13+ : Insecure.SHA1
    /// iOS 13- : CC_SHA1
    var sha1String: String {
        return base.sha1String
    }
    
    /// iOS 13+ : Insecure.SHA1
    /// iOS 13- : CC_SHA1
    var sha1Data: Data {
        return base.sha1Data
    }
    
}

public extension Data {
    /// iOS 13+ : Insecure.SHA1
    /// iOS 13- : CC_SHA1
    var sha1String: String {
        
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
                output.appendFormat("%02hhx", byte)
            }
            return output as String
        }
    }
    
    /// iOS 13+ : Insecure.SHA1
    /// iOS 13- : CC_SHA1
    var sha1Data: Data {
        
        if #available(iOS 13.0, *) {
            return Data(Insecure.SHA1.hash(data: self))
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1((self as NSData).bytes, CC_LONG(count), &digest)
            return Data(digest)
        }
    }
    
    /// CCHmac加密
    func HMACAlgorithmData(_ algorithm: HMACAlgorithm, salt: String) -> Data {
        
        let t: CCHmacAlgorithm = {
            var result: Int = 0
            switch algorithm {
            case .SHA1:
                result = kCCHmacAlgSHA1
            case .SHA224:
                result = kCCHmacAlgSHA224
            case .SHA256:
                result = kCCHmacAlgSHA256
            case .SHA384:
                result = kCCHmacAlgSHA384
            case .SHA512:
                result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }()
        
        let l: Int = {
            var result: CInt = 0
            switch algorithm {
            case .SHA1:
                result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:
                result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:
                result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:
                result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:
                result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }()
        
        let csalt = salt.cString(using: .utf8) ?? []
        let cData = (self as NSData).bytes
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: l)
        CCHmac(t, csalt, strlen(csalt), cData, strlen(cData), result)
        defer { result.deallocate() }
        return Data(bytes: result, count: l)
    }
}
