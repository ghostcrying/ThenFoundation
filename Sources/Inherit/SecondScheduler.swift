//
//  SecondScheduler.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation
import UIKit.UIApplication

extension SecondScheduler {
    
    // MARK: Public
    public func removeAll() {
        self.queue.async { [weak self] in
            guard let `self` = self else { return }
            self.timer.fireDate = Date.distantFuture
            self.values.removeAll()
        }
    }
    
    public func remove(forKey key: AnyHashable) {
        self.queue.async { [weak self] in
            guard let `self` = self else { return }
            self.values.removeValue(forKey: key)
            if self.values.count == 0 {
                self.timer.fireDate = Date.distantFuture
            }
        }
    }
    
    public func add(current: Int = Int.max,
                    interval: Int = 1,
                    forKey key: AnyHashable,
                    fireNow: Bool = false,
                    pauseInBackground: Bool = false,
                    callbackInMainQueue: Bool = true,
                    _ execute: @escaping (_ current: Int) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else { return }
            let item = Item(current: current,
                            duration: interval,
                            action: execute,
                            pauseInBackground: pauseInBackground,
                            callbackInMainQueue: callbackInMainQueue)
            if fireNow {
                item.fire()
            }
            self.values[key] = item
            if self.timer.isValid {
                self.timer.fireDate = Date()
            }
        }
    }
}

public final class SecondScheduler {
    
    public static let scheduler = SecondScheduler()
    
    deinit {
        removeApplicationOberver()
    }
    
    public init() {
        self.timer = Timer(fireAt: Date.distantFuture,
                           interval: 1.0,
                           target: self,
                           selector: #selector(SecondScheduler.timerScheduled),
                           userInfo: nil,
                           repeats: true)
        RunLoop.current.add(self.timer, forMode: .common)
        
        addApplicationOberver()
    }
    
    // MARK: Private
    private var values: [AnyHashable : Item] = [:]
    private var timer:  Timer!
    private let queue:  DispatchQueue = DispatchQueue(label: "com.putao.second.scheduler.queue")
    
    @objc
    private func timerScheduled() {
        queue.async { [weak self] in
            guard let `self` = self else { return }
            var removeKeys = [AnyHashable]()
            self.values.forEach { (key, value) in
                if value.current < 1 {
                    removeKeys.append(key)
                } else {
                    value.execute()
                }
            }
            removeKeys.forEach { (key) in
                self.remove(forKey: key)
            }
        }
    }
    
    private var lastDate: Date?
}

extension SecondScheduler {
    
    private func removeApplicationOberver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func addApplicationOberver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc
    private func applicationDidBecomeActive(_ notification: Notification) {
        
        guard values.count > 0 else {
            lastDate = nil
            return
        }
        
        let fireClosure = { [weak self] in
            guard let `self` = self else { return }
            self.lastDate = nil
            if self.timer.isValid {
                self.timer.fireDate = Date()
            }
        }
        
        guard let lastTimeInterval = lastDate?.timeIntervalSince1970 else {
            fireClosure()
            return
        }
        
        let distance = Date().timeIntervalSince1970 - lastTimeInterval
        values.forEach {
            if !$0.value.pauseInBackground {
                $0.value.update(second: Int(distance))
            }
        }
        
        fireClosure()
    }
    
    @objc
    private func applicationDidEnterBackground(_ notification: Notification) {
        guard values.count > 0 else { return }
        timer.fireDate = Date.distantFuture
        lastDate = Date()
    }
}

extension SecondScheduler {
    
    private class Item {
        
        var duration:               Int
        var action:                 (Int) -> Void
        var totalTimes:             Int = 0
        var current:                Int = Int.max
        var pauseInBackground:      Bool = false
        var callbackInMainQueue:    Bool = true
        
        init(current: Int,
             duration: Int,
             action: @escaping (Int) -> Void,
             pauseInBackground: Bool = false,
             callbackInMainQueue: Bool = true) {
            self.current = current
            self.duration = duration
            self.action = action
            self.pauseInBackground = pauseInBackground
            self.callbackInMainQueue = callbackInMainQueue
        }
        
        func update(second: Int = 1) {
            let offset = min(second, current - 1)
            totalTimes += offset
            current -= offset
        }
        
        func fire(second: Int = 1) {
            let closure = { [weak self] in
                guard let `self` = self else { return }
                self.action(self.current)
                self.totalTimes += second
            }
            if callbackInMainQueue {
                DispatchQueue.main.async(execute: closure)
            } else {
                closure()
            }
        }
        
        func execute(second: Int = 1) {
            totalTimes += second
            current -= second
            guard totalTimes % duration == 0 else { return }
            let closure = { [weak self] in
                guard let `self` = self else { return }
                self.action(self.current)
            }
            if callbackInMainQueue {
                DispatchQueue.main.async(execute: closure)
            } else {
                closure()
            }
        }
    }
}
