//
//  Dictionary++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

extension Dictionary: ThenExtensionCompatible { }

public extension ThenExtension where T: DictionarySignProtocol {
    
    /// 将keyValues中value不为nil的元素添加到当前[key:value]中，更新已有的值
    @discardableResult
    mutating func append(_ keyValues: [T.Key:T.Value?]?) -> [T.Key:T.Value] {
        return base.append(keyValues)
    }
    
    /// 签名，具体方式请查看源码
    func sign(with secret: String) -> String {
        return base.sign(with: secret)
    }
}

public protocol DictionarySignProtocol where Key: Hashable {
    
    associatedtype Key
    associatedtype Value
    
    func sign(with secret: String) -> String
    
    mutating func append(_ keyValues: [Self.Key: Self.Value?]?) -> [Self.Key: Self.Value]
}

extension Dictionary: DictionarySignProtocol {
    
    /// 将keyValues中value不为nil的元素添加到当前[key:value]中，更新已有的值
    @discardableResult
    public mutating func append(_ keyValues: [Key:Value?]?) -> [Key:Value] {
        keyValues?.forEach {
            if let value = $0.value { updateValue(value, forKey: $0.key) }
        }
        return self
    }
    
    /// 签名，具体方式请查看源码
    public func sign(with secret: String) -> String {
        let param = compactMap { "\($0.key)" + "=" + ("\($0.value)".then.addingPercentEncoding ?? "") }.joined(separator: "&")
        return (param + secret).then.md5.lowercased()
    }
}
