//
//  ThenExtensionBase.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation.NSObject

//MARK: - ThenExtension
@dynamicMemberLookup
public struct ThenExtension<T> {
    
    public var base: T
    
    public init(_ base: T) {
        self.base = base
    }
    
    public subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<T, Value>
    ) -> ((Value) -> ThenExtension<T>) {
        var t = self.base
        return { value in
            t[keyPath: keyPath] = value
            return ThenExtension(t)
        }
    }
    
    public func dispose() { }
}

public extension ThenExtension {
    
    @discardableResult
    func force(
        _ handler: (inout T) -> ()
    ) -> ThenExtension<T> {
        var object = base
        handler(&object)
        return self
    }

    @discardableResult
    func force<S>(
        _ s: S,
        handler: (inout T, S) -> ()
    ) -> ThenExtension<T> {
        var object = base
        handler(&object, s)
        return self
    }
    
    @discardableResult
    func force<S1, S2>(
        _ s1: S1,
        _ s2: S2,
        handler: (inout T, S1, S2) -> ()
    ) -> ThenExtension<T> {
        var object = base
        handler(&object, s1, s2)
        return self
    }
    
    @discardableResult
    func force<S1, S2, S3>(
        _ s1: S1,
        _ s2: S2,
        _ s3: S3,
        handler: (inout T, S1, S2, S3) -> ()
    ) -> ThenExtension<T> {
        var object = base
        handler(&object, s1, s2, s3)
        return self
    }

    @discardableResult
    func force<S1, S2, S3, S4>(
        _ s1: S1,
        _ s2: S2,
        _ s3: S3,
        _ s4: S4,
        handler: (inout T, S1, S2, S3, S4) -> ()
    ) -> ThenExtension<T> {
        var object = base
        handler(&object, s1, s2, s3, s4)
        return self
    }
}


//MARK: - ThenExtensionCompatible
public protocol ThenExtensionCompatible {
    
    associatedtype CompatibleType
    
    static var then: ThenExtension<CompatibleType>.Type { get set }
    
    var then: ThenExtension<CompatibleType> { get set }
}

extension ThenExtensionCompatible {
    
    public static var then: ThenExtension<Self>.Type {
        get { return ThenExtension<Self>.self }
        set {  }
    }
    
    public var then: ThenExtension<Self> {
        get { return ThenExtension(self) }
        set {  }
    }
}


//MARK: - NSObject
extension NSObject: ThenExtensionCompatible {  }

