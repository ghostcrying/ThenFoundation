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
        return base.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// value for kCFBundleVersionKey
    var build: String? {
        return base.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    /// value for kCFBundleIdentifierKey
    var identifier: String? {
        return base.bundleIdentifier
        /// return base.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    }
    
    /// value for CFBundleDisplayName
    var displayName: String? {
        return base.infoDictionary?["CFBundleDisplayName"] as? String
    }
}
