//
//  String++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

extension String: ThenExtensionCompatible { }

// MARK: String Encode
public extension ThenExtension where T == String {
    
    /// MD5
    var md5: String {
        return base.md5
    }
    
    func hmac(_ algorithm: HMACAlgorithm, key: String) -> String {
        return base.HMACString(algorithm, salt: key)
    }
    
    /// encoding urlHostAllowed
    var urlEscaped: String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /// "0" -> true; "*" -> false
    var isNumeric: Bool {
        guard !base.isEmpty else { return false }
        return base.trimmingCharacters(in: .decimalDigits).isEmpty
    }
    
    /// trimming whitespaces
    var trim: String {
        return base.trimmingCharacters(in: .whitespaces)
    }
    
    /// remove " "
    var withoutSpaces: String {
        return base.replacingOccurrences(of: " ", with: "")
    }
    
    /// trimming whitespacesAndNewlines
    var withoutSpaceAndNewlines: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// remove "\r"、"\n"
    var removeNewLineString: String {
        return base.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /// trimming whitespacesAndNewlines, then remove "\r"、"\n"
    var trimmingString: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    func appendingPathComponent(_ path: String) -> String {
        return (base as NSString).appendingPathComponent(path)
    }
    
    func insert(_ string: String, at index: Int) -> String {
        return String(base.prefix(index)) + string + String(base.suffix(base.count - index))
    }
    
    /// encoding \"\'[]:/?&=;+!@#$()',*{}\\<>%^`
    var addingPercentEncoding: String? {
        return base.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "\"\'[]:/?&=;+!@#$()',*{}\\<>%^`").inverted)
    }
    
    /// string -> [String:String]
    var queryDictionary: [String: String] {
        guard
            let urlString = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString),
            let query = url.query else {
            return [:]
        }
        var temp = [String: String]()
        query.components(separatedBy: "&").forEach {
            let subComponent = $0.components(separatedBy: "=")
            if let key = subComponent.first?.removingPercentEncoding, let value = subComponent[safe: 1]?.removingPercentEncoding {
                temp[key] = value
            }
        }
        return temp
    }
    
    /// remove ^[\u{00000}-\u{FFFFF}]
    var removeNonBmpUnicode: String? {
        return base.replacingOccurrences(of: "^[\u{00000}-\u{FFFFF}]", with: "")
    }
}


// MARK: URL String
public extension ThenExtension where T == String {
    
    /// -> url -> .scheme
    var scheme: String? {
        return URLComponents(string: base)?.scheme
    }
    
    /// -> url -> .host
    var host: String? {
        return URLComponents(string: base)?.host
    }
    
    /// -> url -> .query
    var query: String? {
        return URLComponents(string: base)?.query
    }
    
    /// -> url -> queryItems -> value for key
    func queryValue(for key: String) -> Int?  {
        return URLComponents(string: base)?.queryItems?.filter { $0.name == key }.first?.value?.intValue
    }
    
    func queryValue(for key: String) -> Float?  {
        return URLComponents(string: base)?.queryItems?.filter { $0.name == key }.first?.value?.floatValue
    }
    
    func queryValue(for key: String) -> Double?  {
        return URLComponents(string: base)?.queryItems?.filter { $0.name == key }.first?.value?.doubleValue
    }
    
    func queryValue(for key: String) -> String?  {
        return URLComponents(string: base)?.queryItems?.filter { $0.name == key }.first?.value
    }
}


// MARK: String Amount Format
public extension ThenExtension where T == String {
    
    func dot(_ count: Int) -> T {
        let separator = "."
        let components = base.components(separatedBy: separator)
        if components.count > 2 { return base }
        let holder = "0"
        var first = components.first ?? holder
        if first.count == 0 {
            first = holder
        }
        let seconds = (components[safe: 1] ?? holder).compactMap({ $0.description })
        let last = (0..<count).compactMap { seconds[safe: $0] ?? holder }.joined()
        return [first, last].joined(separator: separator)
    }
}

extension String {
    
    var intValue: Int? {
        return Int(self)
    }
    
    var floatValue: Float? {
        return Float(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
}

public extension ThenExtension where T == String {
    
    var intValue: Int? {
        return base.intValue
    }
    
    var floatValue: Float? {
        return base.floatValue
    }
    
    var doubleValue: Double? {
        return base.doubleValue
    }
}


extension String {
    
    func toJsonObject() -> Any? {
        guard let data = data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves, .fragmentsAllowed])
    }
}

public extension ThenExtension where T == String {
    
    func toJsonObject() -> Any? {
        return base.toJsonObject()
    }
}


extension String {
    
    func fill(_ placeholder: String) -> String {
        if isEmpty { return placeholder }
        return self
    }
    
    func fill(_ placeholder: Character, limit: Int) -> String {
        let c = limit - count
        guard c > 0 else { return self }
        return (0..<c).reduce(self, { (r, _) in return r + "\(placeholder)" })
    }
    
    func insert(_ placeholder: Character, limit: Int) -> String {
        let c = limit - count
        guard c > 0 else { return self }
        return (0..<c).reduce(self, { (r, _) in return "\(placeholder)" + r })
    }
}

public extension ThenExtension where T == String {
    
    func fill(_ placeholder: String) -> String {
        return base.fill(placeholder)
    }
    
    func fill(_ placeholder: Character, limit: Int) -> String {
        return base.fill(placeholder, limit: limit)
    }
    
    func insert(_ placeholder: Character, limit: Int) -> String {
        return base.insert(placeholder, limit: limit)
    }
}


public extension ThenExtension where T == String {
    
    var asError: Error {
        return NSError(domain: NSError.NormalErrorDomain, code: -1, description: base)
    }
    
    func asError(domain: String = NSError.NormalErrorDomain, code: Int = -1) -> Error {
        return NSError(domain: domain, code: code, description: base)
    }
}

public extension ThenExtension where T == String {
    
    func firstComponent(separatedBy: String) -> String? {
        return base.components(separatedBy: separatedBy).first
    }
    
    func firstComponent(separatedBy: CharacterSet) -> String? {
        return base.components(separatedBy: separatedBy).first
    }
    
    func lastComponent(separatedBy: String) -> String? {
        return base.components(separatedBy: separatedBy).last
    }
    
    func lastComponent(separatedBy: CharacterSet) -> String? {
        return base.components(separatedBy: separatedBy).last
    }
}

///
public extension String {
    
    func subString(to index: Int) -> String {
        guard index > 0 else {
            return ""
        }
        let index: String.Index = self.index(startIndex, offsetBy: index)
        return String(self[..<index])
    }
    
    func subString(from index: Int) -> String {
        guard index >= 0, index < count else {
            return ""
        }
        return self[safe: index..<count] ?? ""
    }
    
    /// Safely subscript string with index.
    ///
    ///      "Hello World!"[safe: 3] -> "l"
    ///      "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Safely subscript string within a given range.
    ///
    ///      "Hello World!"[safe: 6..<11] -> "World"
    ///      "Hello World!"[safe: 21..<110] -> nil
    ///
    ///      "Hello World!"[safe: 6...11] -> "World!"
    ///      "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Range expression.
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
              let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
}


extension String {
    
    func subString(_ range: NSRange) -> String {
        let start = index(startIndex, offsetBy: range.location)
        let ended = index(startIndex, offsetBy: range.location + range.length)
        return String(self[start..<ended])
    }
}

public extension ThenExtension where T == String {
    
    func firstMatch(_ pattern: String) -> NSRange? {
        guard let regular = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }
        let range = regular.rangeOfFirstMatch(in: base, range: NSRange(location: 0, length: base.count))
        if range.length == 0 {
            return nil
        }
        return range
    }
    
    func matchs(_ pattern: String) -> [String] {
        guard let regular = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        let lists = regular.matches(in: base, range: NSRange(location: 0, length: base.count)).map { r in
            return base.subString(r.range)
        }
        return lists
    }
    
}
