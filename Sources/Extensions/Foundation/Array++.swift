//
//  Array++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

extension Array: ThenExtensionCompatible { }

public extension ThenExtension where T: ArrayPutaoable {
    
    /// random one element
    var anyOne: T.Element? {
        return base.anyOne
    }
    
    /// [1, [2, 3], [4, [5, 6, [7, 8]]]] --> [1, 2, 3, 4, 5, 6, 7, 8]
    var reduction: [T.Element] {
        return base.reduction
    }
    
    /// random all elements index
    func randomAll() -> [T.Element] {
        return base.randomAll()
    }
    
    ///
    subscript (safe index: Int) -> T.Element? {
        get { return base[safe: index] }
        set { base[safe: index] = newValue }
    }
    
    ///
    mutating func append(_ object: T.Element?) -> Array<T.Element> {
        return base.safeAppend(object)
    }
    
    ///
    mutating func insert(_ object: T.Element?, at index: Int) -> Array<T.Element> {
        return base.safeInsert(object, at: index)
    }
    
    ///
    mutating func remove(at index: Int) -> Array<T.Element> {
        return base.safeRemove(at: index)
    }
}

public protocol ArrayPutaoable {
    
    associatedtype Element
    
    var anyOne: Element? { get }
    
    var reduction: [Element] { get }
    
    func randomAll() -> [Element]
    
    subscript (safe index: Int) -> Element? { get set }
    
    mutating func safeAppend(_ object: Element?) -> Array<Element>
    mutating func safeInsert(_ object: Element?, at index: Int) -> Array<Element>
    mutating func safeRemove(at index: Int) -> Array<Element>
    mutating func safeRemoveFirst() -> Element?
    mutating func safeRemoveLast() -> Element?
}

extension Array: ArrayPutaoable {
    
    public var anyOne: Element? {
        guard count > 0 else { return nil }
        return self[Int.random(in: indices)]
    }
    
    public var reduction: [Element] {
        return reduce(into: []) {
            if let tmp = $1 as? [Element] {
                $0.append(contentsOf: tmp.reduction)
            } else {
                $0.append($1)
            }
        }
    }
    
    public func randomAll() -> [Element] {
        return sorted { (_, _) in Bool.random() }
    }
    
    /// index如果超出范围则返回nil
    public subscript (safe index: Int) -> Element? {
        get { return indices ~= index ? self[index] : nil }
        set {
            guard indices ~= index else { return }
            guard let v = newValue else {
                remove(at: index)
                return
            }
            insert(v, at: index)
            remove(at: index + 1)
        }
    }
    
    /// object为nil则什么都不做并返回self
    @discardableResult
    public mutating func safeAppend(_ object: Element?) -> Array<Element> {
        guard let obj = object else { return self }
        append(obj)
        return self
    }
    
    /// object为nil或者index超出范围则什么都不做并返回self
    @discardableResult
    public mutating func safeInsert(_ object: Element?, at index: Int) -> Array<Element> {
        if index >= 0, index < Int(count), let obj = object { insert(obj, at: index) }
        return self
    }
    
    /// index如果超出范围则什么都不做并返回self
    @discardableResult
    public mutating func safeRemove(at index: Int) -> Array<Element> {
        if index >= 0, index < Int(count) { remove(at: index) }
        return self
    }
    
    @discardableResult
    public mutating func safeRemoveFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
    
    @discardableResult
    public mutating func safeRemoveLast() -> Element? {
        if isEmpty { return nil }
        return removeLast()
    }
}
