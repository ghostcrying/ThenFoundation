//
//  NSLock++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public extension ThenExtension where T: NSLock {
    
    @discardableResult
    func lock<Element>(_ closure: () -> Element) -> Element {
        base.lock()
        defer { base.unlock() }
        return closure()
    }
    
    @discardableResult
    func lock<Element>(_ closure: @autoclosure () -> Element) -> Element {
        base.lock()
        defer { base.unlock() }
        return closure()
    }
}

public extension ThenExtension where T: Any {
    
    @discardableResult
    func lock<Element>(_ lock: NSLock, _ closure: () -> Element) -> Element {
        lock.lock()
        defer { lock.unlock() }
        return closure()
    }
    
    @discardableResult
    func lock<Element>(_ lock: NSLock, _ closure: @autoclosure () -> Element) -> Element {
        lock.lock()
        defer { lock.unlock() }
        return closure()
    }
}
