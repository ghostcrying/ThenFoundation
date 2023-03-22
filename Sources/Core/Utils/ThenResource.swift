//
//  ThenResource.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

public enum ThenResource<Target> {
    
    case target(Target?)
    case url(URL)
    case path(String)
    case name(String)
}

public extension ThenResource {
    
    var target: Target? {
        guard case .target(let t) = self else { return nil }
        return t
    }
    
    var url: URL? {
        guard case .url(let u) = self else { return nil }
        return u
    }
    
    var path: String? {
        guard case .path(let p) = self else { return nil }
        return p
    }
    
    var name: String? {
        guard case .name(let n) = self else { return nil }
        return n
    }
}
