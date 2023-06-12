//
//  Sequence+JSON.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public extension ThenExtension where T : Sequence {
    
    func toJsonData(options: JSONSerialization.WritingOptions = [.fragmentsAllowed]) -> Data? {
        guard JSONSerialization.isValidJSONObject(value) else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: value, options: options)
    }
    
    func toJsonString(options: JSONSerialization.WritingOptions = [.fragmentsAllowed], encoding: String.Encoding = .utf8) -> String? {
        guard let data = toJsonData(options: options) else {
            return nil
        }
        return String(data: data, encoding: encoding)
    }
}
