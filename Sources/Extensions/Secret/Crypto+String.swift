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

//MARK: - MD5
public extension String {
    
    var md5: String {
        if #available(iOS 13.0, *) {
            if let d = data(using: .utf8) {
                return Insecure.MD5.hash(data: d).map { String(format: "%02hhx", $0) }.joined()
            }
            return ""
        } else {
            return legacyMD5String()
        }
    }
    
    var md5Data: Data {
        if #available(iOS 13.0, *) {
            if let d = data(using: .utf8) {
                return Data(Insecure.MD5.hash(data: d))
            }
            return Data()
        } else {
            return legacyMD5Data()
        }
    }
    
}


//MARK: - HMAC加密类型
public enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
}

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
    
    @available(iOS, introduced: 2.0, deprecated: 13.0)
    func legacyMD5Data() -> Data {
        let str = self.cString(using: String.Encoding.utf8) ?? []
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        defer { result.deallocate() }
        CC_MD5(str, strLen, result)
        return Data(bytes: result, count: digestLen)
    }
    
    @available(iOS, introduced: 2.0, deprecated: 13.0)
    func legacyMD5String() -> String {
        let str = self.cString(using: String.Encoding.utf8) ?? []
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        defer { result.deallocate() }
        CC_MD5(str, strLen, result)
        return stringFromResult(result: result, length: digestLen)
    }
    
    func HMACAlgorithmString(_ algorithm: HMACAlgorithm, salt: String) -> String {
        let t: CCHmacAlgorithm = {
            var result: Int = 0
            switch algorithm {
            case .md5:
                result = kCCHmacAlgMD5
            case .sha1:
                result = kCCHmacAlgSHA1
            case .sha224:
                result = kCCHmacAlgSHA224
            case .sha256:
                result = kCCHmacAlgSHA256
            case .sha384:
                result = kCCHmacAlgSHA384
            case .sha512:
                result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }()
        
        let l: Int = {
            var result: CInt = 0
            switch algorithm {
            case .md5:
                result = CC_MD5_DIGEST_LENGTH
            case .sha1:
                result = CC_SHA1_DIGEST_LENGTH
            case .sha224:
                result = CC_SHA224_DIGEST_LENGTH
            case .sha256:
                result = CC_SHA256_DIGEST_LENGTH
            case .sha384:
                result = CC_SHA384_DIGEST_LENGTH
            case .sha512:
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
            case .md5:
                result = kCCHmacAlgMD5
            case .sha1:
                result = kCCHmacAlgSHA1
            case .sha224:
                result = kCCHmacAlgSHA224
            case .sha256:
                result = kCCHmacAlgSHA256
            case .sha384:
                result = kCCHmacAlgSHA384
            case .sha512:
                result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }()
        
        let l: Int = {
            var result: CInt = 0
            switch algorithm {
            case .md5:
                result = CC_MD5_DIGEST_LENGTH
            case .sha1:
                result = CC_SHA1_DIGEST_LENGTH
            case .sha224:
                result = CC_SHA224_DIGEST_LENGTH
            case .sha256:
                result = CC_SHA256_DIGEST_LENGTH
            case .sha384:
                result = CC_SHA384_DIGEST_LENGTH
            case .sha512:
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
    
    @available(iOS 13.0, *)
    func InsecureAlgorithmString(_ algorithm: HMACAlgorithm, salt: String) -> String {
        guard let keyData = data(using: .utf8), let saltData = salt.data(using: .utf8) else {
            return ""
        }
        switch algorithm {
        case .sha1:
            return HMAC<Insecure.SHA1>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .sha256:
            return HMAC<SHA256>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .sha512:
            return HMAC<SHA512>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .sha384:
            return HMAC<SHA384>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        case .md5:
            return HMAC<Insecure.MD5>
                .authenticationCode(for: keyData, using: .init(data: saltData))
                .map { String(format: "%02hhx", $0) }
                .joined()
        default:
            return ""
        }
    }
    
    @available(iOS 13.0, *)
    func InsecureAlgorithmData(_ algorithm: HMACAlgorithm, salt: String) -> Data {
        guard let keyData = data(using: .utf8), let saltData = salt.data(using: .utf8) else {
            return Data()
        }
        switch algorithm {
        case .sha1:
            return Data(HMAC<Insecure.SHA1>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .sha256:
            return Data(HMAC<SHA256>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .sha512:
            return Data(HMAC<SHA512>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .sha384:
            return Data(HMAC<SHA384>.authenticationCode(for: keyData, using: .init(data: saltData)))
        case .md5:
            return Data(HMAC<Insecure.MD5>.authenticationCode(for: keyData, using: .init(data: saltData)))
        default:
            return Data()
        }
    }
    
    ///
    func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
}
