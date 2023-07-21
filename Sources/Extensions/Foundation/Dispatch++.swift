//
//  Dispatch++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public extension ThenExtension where T: DispatchQueue {
    
    /// async after second
    @inlinable
    func delay(_ second: TimeInterval, _ callback: @escaping () -> ()) {
        let microSeconds = second * TimeInterval(NSEC_PER_MSEC)
        let deadline = DispatchTime.now() + .microseconds(Int(microSeconds))
        value.asyncAfter(deadline: deadline, execute: callback)
    }
}
