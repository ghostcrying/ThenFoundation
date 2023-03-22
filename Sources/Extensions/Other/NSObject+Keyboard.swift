//
//  NSObject+Keyboard.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/16.
//

import UIKit

public extension ThenExtension where T: NSObject {
    
    var lastKeyboard: ThenKeyBoard? {
        return base.kit_last_keyboard
    }
    
    @discardableResult
    func addKeyboard(notification name: ThenKeyBoard.Name, _ closure: @escaping ThenKeyBoard.Closure) -> ThenExtension {
        base.then.addNotification(name: name.notificationName, object: nil) { [weak base] notification in
            let info = ThenKeyBoard.Info(notification)
            closure(name, info)
            base?.kit_last_keyboard = ThenKeyBoard(name: name, info: info)
        }
        return self
    }
    
    @discardableResult
    func addKeyboard(notification name: ThenKeyBoard.Name, _ closure: @escaping (ThenKeyBoard.Info) -> Void) -> ThenExtension {
        base.then.addNotification(name: name.notificationName, object: nil) { [weak base] notification in
            let info = ThenKeyBoard.Info(notification)
            closure(info)
            base?.kit_last_keyboard = ThenKeyBoard(name: name, info: info)
        }
        return self
    }
    
    @discardableResult
    func addKeyboard(notification name: ThenKeyBoard.Name, _ closure: @escaping () -> Void) -> ThenExtension {
        base.then.addNotification(name: name.notificationName, object: nil) { [weak base] notification in
            let info = ThenKeyBoard.Info(notification)
            closure()
            base?.kit_last_keyboard = ThenKeyBoard(name: name, info: info)
        }
        return self
    }
    
    @discardableResult
    func addKeyboard(notification names: [ThenKeyBoard.Name], _ closure: @escaping ThenKeyBoard.Closure) -> ThenExtension {
        names.forEach { addKeyboard(notification: $0, closure) }
        return self
    }
    
    @discardableResult
    func addKeyboard(notification names: [ThenKeyBoard.Name], _ closure: @escaping (ThenKeyBoard.Info) -> Void) -> ThenExtension {
        names.forEach { addKeyboard(notification: $0, closure) }
        return self
    }
    
    @discardableResult
    func addKeyboard(notification names: [ThenKeyBoard.Name], _ closure: @escaping () -> Void) -> ThenExtension {
        names.forEach { addKeyboard(notification: $0, closure) }
        return self
    }
    
    @discardableResult
    func removeKeyboard() -> ThenExtension {
        let temp = base.then
        ThenKeyBoard.Name.allCases.forEach { temp.removeNotification(name: $0.notificationName) }
        return self
    }
    
    @discardableResult
    func removeKeyboard(notification type: ThenKeyBoard.Name) -> ThenExtension {
        base.then.removeNotification(name: type.notificationName)
        return self
    }
    
    @discardableResult
    func removeKeyboard(notification types: [ThenKeyBoard.Name]) -> ThenExtension {
        let temp = base.then
        types.forEach { temp.removeNotification(name: $0.notificationName) }
        return self
    }
}

fileprivate extension NSObject {
    
    var kit_last_keyboard: ThenKeyBoard? {
        get { return then.binded(for: &ThenKeyBoard.lastKeyboardKey) }
        set { then.bind(object: newValue, for: &ThenKeyBoard.lastKeyboardKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public struct ThenKeyBoard {
    
    fileprivate static var lastKeyboardKey: String = "observer.keyboard.last.key"
    
    public typealias Closure = (Name, Info) -> Void
    
    public enum Name: CaseIterable {
        
        case willShow
        case didShow
        case willHide
        case didHide
        case willChange
        case didChange
        
        var notificationName: Notification.Name {
            switch self {
            case .willShow:     return UIResponder.keyboardWillShowNotification
            case .didShow:      return UIResponder.keyboardDidShowNotification
            case .willHide:     return UIResponder.keyboardWillHideNotification
            case .didHide:      return UIResponder.keyboardDidHideNotification
            case .willChange:   return UIResponder.keyboardWillChangeFrameNotification
            case .didChange:    return UIResponder.keyboardDidChangeFrameNotification
            }
        }
    }
    
    public struct Info {
        public var beginFrame:  CGRect?
        public var endFrame:    CGRect?
        public var duration:    TimeInterval?
        public var curve:       TimeInterval?
        public var isLocal:     Bool?
        public init(_ notification: Notification) {
            beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval
            isLocal = notification.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool
        }
    }
    
    public var name: ThenKeyBoard.Name
    public var info: ThenKeyBoard.Info
}
