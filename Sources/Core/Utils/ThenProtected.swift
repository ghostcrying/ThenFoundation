//
//  ThenProtected.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

private protocol Lock {
    
    func lock()
    func unlock()
}

extension Lock {
    
    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }
    
    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }
}

/// An `os_unfair_lock` wrapper.
final class UnfairLock: Lock {
    
    private let unfairLock: os_unfair_lock_t
    
    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
    
    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }
    
    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

/// A thread-safe wrapper around a value.
@propertyWrapper
@dynamicMemberLookup
public final class ThenProtected<T> {
    
    private let lock = UnfairLock()
    private var value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }
    
    public var projectedValue: ThenProtected<T> { self }
    
    public init(wrappedValue: T) {
        value = wrappedValue
    }
    
    public func read<U>(_ closure: (T) -> U) -> U {
        lock.around { closure(self.value) }
    }
    
    @discardableResult
    public func write<U>(_ closure: (inout T) -> U) -> U {
        lock.around { closure(&self.value) }
    }
    
    public subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }
}

public extension ThenProtected where T: RangeReplaceableCollection {
    
    func append(_ newElement: T.Element) {
        write { $0.append(newElement) }
    }
    
    func append<S: Sequence>(contentsOf newElements: S) where S.Element == T.Element {
        write { $0.append(contentsOf: newElements) }
    }
    
    func append<C: Collection>(contentsOf newElements: C) where C.Element == T.Element {
        write { $0.append(contentsOf: newElements) }
    }
}

public extension ThenProtected where T == Data? {
    
    func append(_ data: Data) {
        write { $0?.append(data) }
    }
}
