//
//  NSObject+Associate.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

private struct ThenObjectAssociateKeys {
    
    static var tag:     String = "object.then.tag"
    static var info:    String = "object.then.info"
}

public extension ThenExtension where T: NSObject {
    
    /// associated object
    var tag: Int {
        get { return value.then.binded(for: &ThenObjectAssociateKeys.tag) ?? 0 }
        set { value.then.bind(object: newValue, for: &ThenObjectAssociateKeys.tag, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    /// associated object
    var info: [AnyHashable: Any] {
        get { return value.then.binded(for: &ThenObjectAssociateKeys.info) ?? [:] }
        set { value.then.bind(object: newValue, for: &ThenObjectAssociateKeys.info, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
}

public extension ThenExtension where T: NSObject {
    
    /// objc_getAssociatedObject(value, key)
    func binded<ResultType>(for key: UnsafeRawPointer) -> ResultType? {
        return objc_getAssociatedObject(value, key) as? ResultType
    }
    
    /// objc_setAssociatedObject(value, key, object, policy)
    func bind(object: Any?, for key: UnsafeRawPointer, _ policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(value, key, object, policy)
    }
    
    /// objc_setAssociatedObject(value, key, nil, policy)
    func unBind(for key: UnsafeRawPointer, _ policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(value, key, nil, policy)
    }
}
