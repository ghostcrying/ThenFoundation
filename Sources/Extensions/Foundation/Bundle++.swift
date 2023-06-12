//
//  Bundle++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

public extension ThenExtension where T: Bundle {
    
    /// value for CFBundleShortVersionString
    var version: String? {
        return value.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// value for kCFBundleVersionKey
    var build: String? {
        return value.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    /// value for kCFBundleIdentifierKey
    var identifier: String? {
        return value.bundleIdentifier
        /// return value.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    }
    
    /// value for CFBundleDisplayName
    var displayName: String? {
        return value.infoDictionary?["CFBundleDisplayName"] as? String
    }
}
