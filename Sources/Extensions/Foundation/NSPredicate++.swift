//
//  NSPredicate++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

extension NSPredicate {
    /// 用户名: 中英文组成, 长度1~7
    // public static let nickname = NSPredicate(format: "SELF MATCHES %@", "^[\u{4E00}-\u{9FA5}A-Za-z]{1,7}$")
}

/// 常用正则字符串
/// let input = "这是一个中英文字符串，包含一些中文和英文字符。This is a mixed Chinese and English string."
/// let pattern = RegularPattern.ZHAEN
///
/// do {
///     let regex = try NSRegularExpression(pattern: pattern, options: [])
///     let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.count))
///     for match in matches {
///         let matchString = (input as NSString).substring(with: match.range)
///         print(matchString)
///     }
/// } catch {
///     print("Invalid regex pattern")
/// }
public struct RegularPattern {
    
    /// 中英文匹配
    public let ZHAEN: String = "[\\u4e00-\\u9fa5a-zA-Z]+"
    
    /// 中文匹配
    public let ZH: String = "[\\u4e00-\\u9fa5]+"
    
    /// 英文匹配
    public let EN: String = "[a-zA-Z]+"
    
    /// 非中英文匹配
    public let UNZHAEN = "[^\\u4e00-\\u9fa5a-zA-Z]+"
    
    /// 任何符号字符
    /// func matchSymbols(in input: String) -> [String] {
    ///   let pattern = "[\\p{S}]+"
    ///   do {
    ///     let regex = try NSRegularExpression(pattern: pattern, options: [])
    ///     let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.count))
    ///     return matches.map { (input as NSString).substring(with: $0.range) }
    ///   } catch {
    ///     print("Invalid regex pattern")
    ///     return []
    ///   }
    /// }
    public let SYMBOLS = "[\\p{S}]+"

}
