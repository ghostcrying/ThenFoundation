//
//  Crypto+String.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//

import Foundation

#if canImport(CryptoKit)
import CryptoKit
#endif
import CommonCrypto

// MARK: - MD5
public extension String {
    
    var md5: String {
        if #available(iOS 13.0, *) {
            if let d = data(using: .utf8) {
                return Insecure.MD5.hash(data: d).map { String(format: "%02hhx", $0) }.joined()
            }
            return ""
        } else {
            let data = Data(self.utf8)
            let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
                CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
                return hash
            }
            return hash.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
    var md5Data: Data {
        if #available(iOS 13.0, *) {
            if let d = data(using: .utf8) {
                return Data(Insecure.MD5.hash(data: d))
            }
            return Data()
        } else {
            let data = Data(self.utf8)
            let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
                CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
                return hash
            }
            return Data(hash)
        }
    }
    
}


// MARK: - HMAC加密类型定义
public enum HMACAlgorithm {
    case SHA1
    case SHA224 // iOS13+: Insecure不支持
    case SHA256
    case SHA384
    case SHA512
}


// MARK: - String的HMAC加密
public extension String {
    
    /// self: 被加密字段
    /// salt: (加盐)秘钥字段
    func HMACString(_ algorithm: HMACAlgorithm, salt: String) -> String {
        return HMACAlgorithmString(algorithm, salt: salt)
    }
    
    func HMACData(_ algorithm: HMACAlgorithm, salt: String) -> Data {
        return HMACAlgorithmData(algorithm, salt: salt)
    }
    
}

private extension String {
    
    func HMACAlgorithmString(_ algorithm: HMACAlgorithm, salt: String) -> String {
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
        let cData = cString(using: .utf8) ?? []
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: l)
        CCHmac(t, csalt, strlen(csalt), cData, strlen(cData), result)
        defer { result.deallocate() }
        return stringFromResult(result: result, length: l)
    }
    
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
        let cData = cString(using: .utf8) ?? []
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: l)
        CCHmac(t, csalt, strlen(csalt), cData, strlen(cData), result)
        defer { result.deallocate() }
        return Data(bytes: result, count: l)
    }
    
    // Insecure不支持sha224加密
    @available(iOS 13.0, *)
    func InsecureAlgorithmString(_ algorithm: HMACAlgorithm, salt: String) -> String {
        guard let keyData = data(using: .utf8), let saltData = salt.data(using: .utf8) else {
            return ""
        }
        switch algorithm {
        case .SHA1:
            return HMAC<Insecure.SHA1>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .SHA256:
            return HMAC<SHA256>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .SHA512:
            return HMAC<SHA512>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .SHA384:
            return HMAC<SHA384>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        default:
            return ""
        }
    }
    
    // Insecure不支持sha224加密
    @available(iOS 13.0, *)
    func InsecureAlgorithmData(_ algorithm: HMACAlgorithm, salt: String) -> Data {
        guard let keyData = data(using: .utf8), let saltData = salt.data(using: .utf8) else {
            return Data()
        }
        switch algorithm {
        case .SHA1:
            return Data(HMAC<Insecure.SHA1>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .SHA256:
            return Data(HMAC<SHA256>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .SHA512:
            return Data(HMAC<SHA512>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .SHA384:
            return Data(HMAC<SHA384>.authenticationCode(for: keyData, using: .init(data: saltData)))
        default:
            return Data()
        }
    }
    
    ///
    func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02hhx", result[i])
        }
        return String(hash).lowercased()
    }
}
