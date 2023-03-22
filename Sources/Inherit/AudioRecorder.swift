//
//  AudioRecorder.swift
//  
//
//  Created by ghost on 2023/3/21.
//

import Foundation
import AVFoundation

// MARK: 音频录制类型
public protocol AudioRecorderType {
    
    @discardableResult
    func prepareToRecord() -> Bool
    
    
    @discardableResult
    func record() -> Bool
    
    func pause()
    
    func stop()
    
    
    @discardableResult
    func record(atTime time: TimeInterval) -> Bool
    
    
    @discardableResult
    func record(forDuration duration: TimeInterval) -> Bool
        
    
    @discardableResult
    func record(atTime time: TimeInterval, forDuration duration: TimeInterval) -> Bool
    
    @discardableResult
    func deleteRecording() -> Bool
    
    /* is it recording or not? */
    var isRecording: Bool { get }
    
    /* URL of the recorded file */
    var url: URL? { get }

    /* these settings are fully valid only when prepareToRecord has been called */
    var settings: [String : Any]? { get }
    
    /* this object is fully valid only when prepareToRecord has been called */
    var format: AVAudioFormat? { get }
    
    /* get the current time of the recording - only valid while recording */
    var currentTime: TimeInterval? { get }

    /* get the device current time - always valid */
    var deviceCurrentTime: TimeInterval? { get }

}


// MARK: 音频录制回调协议
public protocol AudioRecorderDelegate: NSObjectProtocol {
    
    func audioRecorderDidFinishRecording(_ recorder: AudioRecorderType, successfully flag: Bool)
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AudioRecorderType, error: Error?)
    func audioRecorderBeginInterruption(_ recorder: AudioRecorderType)
    func audioRecorderEndInterruption(_ recorder: AudioRecorderType, withOptions flags: Int)
    
    func audioRecorderRouteChange(_ recorder: AudioRecorderType, reason: AVAudioSession.RouteChangeReason)
    func audioRecorderInterruptionChange(_ recorder: AudioRecorderType,
                                         type: AVAudioSession.InterruptionType,
                                         options: AVAudioSession.InterruptionOptions)
}

extension AudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AudioRecorderType, successfully flag: Bool) { }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AudioRecorderType, error: Error?) { }
    func audioRecorderBeginInterruption(_ recorder: AudioRecorderType) { }
    func audioRecorderEndInterruption(_ recorder: AudioRecorderType, withOptions flags: Int) { }
    
    func audioRecorderRouteChange(_ recorder: AudioRecorderType, reason: AVAudioSession.RouteChangeReason) { }
    func audioRecorderInterruptionChange(_ recorder: AudioRecorderType,
                                         type: AVAudioSession.InterruptionType,
                                         options: AVAudioSession.InterruptionOptions) { }
}


// MARK: - 音频播放器的协议的默认空实现
open class AudioRecorder: NSObject {
    
    open internal(set) var recorder: AVAudioRecorder?
    
    open weak var delegate: AudioRecorderDelegate?
    
    
    //MARK: - Lifecycle
    public init(url: URL, settings: [String : Any], delegate: AudioRecorderDelegate? = nil) {
        super.init()
        self.delegate = delegate
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            setup()
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
        }
    }

    public init(url: URL, format: AVAudioFormat, delegate: AudioRecorderDelegate? = nil) {
        super.init()
        self.delegate = delegate
        do {
            recorder = try AVAudioRecorder(url: url, format: format)
            setup()
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
        }
    }
        
    deinit {
        if recorder?.delegate != nil {
            recorder?.delegate = nil
        }
        NotificationCenter.default.then.removeObserver(interruptionToken)
        NotificationCenter.default.then.removeObserver(routeChangeToken)
    }
    
    
    //MARK: - Private
    private var interruptionToken: NSObjectProtocol?
    private var routeChangeToken: NSObjectProtocol?
    
    private func setup() {
        recorder?.delegate = self
        recorder?.prepareToRecord()
        handleNotifications()
    }
    
    private func handleNotifications() {
        let interruptionName = AVAudioSession.interruptionNotification
        interruptionToken = NotificationCenter.default.then.addObserver(forName: interruptionName) { [weak self] in
            guard
                let userInfo = $0.userInfo,
                let type = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType,
                let options = userInfo[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions
                else {
                    return
            }
            self?.audioRecorderInterruptionChange(type: type, options: options)
        }
        let routeChangeName = AVAudioSession.routeChangeNotification
        routeChangeToken = NotificationCenter.default.then.addObserver(forName: routeChangeName) { [weak self] in
            guard
                let userInfo = $0.userInfo,
                let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? AVAudioSession.RouteChangeReason
                else {
                    return
            }
            self?.audioRecorderRouteChange(reason: reason)
        }
    }
    
    open func audioRecorderInterruptionChange(type: AVAudioSession.InterruptionType, options: AVAudioSession.InterruptionOptions) {
        delegate?.audioRecorderInterruptionChange(self, type: type, options: options)
    }
    
    open func audioRecorderRouteChange(reason: AVAudioSession.RouteChangeReason) {
        delegate?.audioRecorderRouteChange(self, reason: reason)
    }
}


//MARK: AudioRecorderType
extension AudioRecorder: AudioRecorderType {
    
    public var isRecording: Bool {
        return self.recorder?.isRecording == true
    }
    
    public var url: URL? {
        return self.recorder?.url
    }

    public var settings: [String : Any]? {
        return self.recorder?.settings
    }
    
    public var format: AVAudioFormat? {
        return self.recorder?.format
    }
    
    public var currentTime: TimeInterval? {
        return self.recorder?.currentTime
    }

    public var deviceCurrentTime: TimeInterval? {
        return self.recorder?.deviceCurrentTime
    }
    
    @discardableResult
    public func prepareToRecord() -> Bool {
        return self.recorder?.prepareToRecord() == true
    }
    
    @discardableResult
    public func record() -> Bool {
        return self.recorder?.record() == true
    }
    
    public func pause() {
        self.recorder?.pause()
    }
    
    public func stop() {
        self.recorder?.stop()
    }
    

    @discardableResult
    public func record(atTime time: TimeInterval) -> Bool {
        return self.recorder?.record(atTime: time) == true
    }
    
    @discardableResult
    public func record(forDuration duration: TimeInterval) -> Bool {
        return self.recorder?.record(forDuration: duration) == true
    }
        
    @discardableResult
    public func record(atTime time: TimeInterval, forDuration duration: TimeInterval) -> Bool {
        return self.recorder?.record(atTime: time, forDuration: duration) == true
    }
    
    @discardableResult
    public func deleteRecording() -> Bool {
        return self.recorder?.deleteRecording() == true
    }
}


//MARK: AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    
    open func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.delegate?.audioRecorderDidFinishRecording(self, successfully: flag)
    }
    
    open func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
    }
    
    open func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        self.delegate?.audioRecorderBeginInterruption(self)
    }
    
    open func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        self.delegate?.audioRecorderEndInterruption(self, withOptions: flags)
    }
}
