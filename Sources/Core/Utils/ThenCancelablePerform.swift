//
//  ThenCancelablePerform.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

public protocol ThenCancelablePerformProtocol {
    
    func cancel()
    func fire()
}

extension ThenCancelablePerform: ThenCancelablePerformProtocol {
    
    public func cancel() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    public func fire() {
        cancel()
        action()
    }
}

public class ThenCancelablePerform: NSObject {
    
    let action: () -> Void
    
    public init(delay seconds: TimeInterval, _ closure: @escaping () -> Void) {
        action = closure
        super.init()
        perform(#selector(ThenCancelablePerform.performAction), with: nil, afterDelay: seconds)
    }
    
    @objc
    private func performAction() {
        action()
    }
}
