//
//  ThenExtensionBase.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation.NSObject

// MARK: - ThenExtension

@dynamicMemberLookup public struct ThenExtension<T> {
    public var value: T

    @inlinable
    public init(_ value: T) {
        self.value = value
    }

    @inlinable
    public subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<T, Value>
    ) -> ((Value) -> ThenExtension<T>) {
        var t = self.value
        return { value in
            t[keyPath: keyPath] = value
            return ThenExtension(t)
        }
    }

    /// May No Use
    @inlinable
    public func dispose() {}
}

public extension ThenExtension {
    @inlinable
    @discardableResult
    func force(
        _ handler: (inout T) -> Void
    ) -> ThenExtension<T> {
        var object = value
        handler(&object)
        return self
    }

    @inlinable
    @discardableResult
    func force<S>(
        _ s: S,
        handler: (inout T, S) -> Void
    ) -> ThenExtension<T> {
        var object = value
        handler(&object, s)
        return self
    }

    @inlinable
    @discardableResult
    func force<S1, S2>(
        _ s1: S1,
        _ s2: S2,
        handler: (inout T, S1, S2) -> Void
    ) -> ThenExtension<T> {
        var object = value
        handler(&object, s1, s2)
        return self
    }

    @inlinable
    @discardableResult
    func force<S1, S2, S3>(
        _ s1: S1,
        _ s2: S2,
        _ s3: S3,
        handler: (inout T, S1, S2, S3) -> Void
    ) -> ThenExtension<T> {
        var object = value
        handler(&object, s1, s2, s3)
        return self
    }

    @inlinable
    @discardableResult
    func force<S1, S2, S3, S4>(
        _ s1: S1,
        _ s2: S2,
        _ s3: S3,
        _ s4: S4,
        handler: (inout T, S1, S2, S3, S4) -> Void
    ) -> ThenExtension<T> {
        var object = value
        handler(&object, s1, s2, s3, s4)
        return self
    }
}

// MARK: - ThenExtensionCompatible

public protocol ThenExtensionCompatible {
    associatedtype CompatibleType

    static var then: ThenExtension<CompatibleType>.Type { get set }

    var then: ThenExtension<CompatibleType> { get set }
}

public extension ThenExtensionCompatible {
    static var then: ThenExtension<Self>.Type {
        get { return ThenExtension<Self>.self }
        set {}
    }

    var then: ThenExtension<Self> {
        get { return ThenExtension(self) }
        set {}
    }
}

// MARK: - NSObject

extension NSObject: ThenExtensionCompatible {}
