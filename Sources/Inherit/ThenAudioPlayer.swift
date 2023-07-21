//
//  AudioPlayer.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//
//  音频播放器

import Foundation
import AVFoundation

// MARK: 音频播放器类型
public protocol ThenAudioPlayerType {
    
    @discardableResult
    func play() -> Bool
    
    @discardableResult
    func play(atTime time: TimeInterval) -> Bool
    
    func pause()
    func stop()
    
    var isPlaying: Bool { get }
}

// MARK: 音频播放器的回调协议
public protocol ThenAudioPlayerDelegate: NSObjectProtocol {
    
    func audioPlayerDidFinishPlaying(_ player: ThenAudioPlayerType, successfully flag: Bool)
    func audioPlayerDecodeErrorDidOccur(_ player: ThenAudioPlayerType, error: Error?)
    func audioPlayerBeginInterruption(_ player: ThenAudioPlayerType)
    func audioPlayerEndInterruption(_ player: ThenAudioPlayerType, withOptions flags: Int)
    
    func audioPlayerRouteChange(_ player: ThenAudioPlayerType, reason: AVAudioSession.RouteChangeReason)
    func audioPlayerInterruptionChange(_ player: ThenAudioPlayerType,
                                       type: AVAudioSession.InterruptionType,
                                       options: AVAudioSession.InterruptionOptions)
}

// MARK: 音频播放器的协议的默认空实现
public extension ThenAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: ThenAudioPlayerType, successfully flag: Bool) { }
    func audioPlayerDecodeErrorDidOccur(_ player: ThenAudioPlayerType, error: Error?) { }
    func audioPlayerBeginInterruption(_ player: ThenAudioPlayerType) { }
    func audioPlayerEndInterruption(_ player: ThenAudioPlayerType, withOptions flags: Int) { }
    
    func audioPlayerRouteChange(_ player: ThenAudioPlayerType, reason: AVAudioSession.RouteChangeReason) { }
    func audioPlayerInterruptionChange(_ player: ThenAudioPlayerType,
                                       type: AVAudioSession.InterruptionType,
                                       options: AVAudioSession.InterruptionOptions) { }
}

// MARK: 音频播放器
open class ThenAudioPlayer: NSObject, ThenAudioPlayerType {
    
    @discardableResult
    open func play() -> Bool {
        return player?.play() ?? false
    }
    
    @discardableResult
    open func play(atTime time: TimeInterval) -> Bool {
        return player?.play(atTime: time) ?? false
    }
    
    open func pause() {
        player?.pause()
    }
    
    open func stop() {
        player?.stop()
    }
    
    open var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    open internal(set) var player: AVAudioPlayer?
    
    open weak var delegate: ThenAudioPlayerDelegate?
    
    deinit {
        if player?.delegate != nil { player?.delegate = nil }
        NotificationCenter.default.then.removeObserver(interruptionToken)
        NotificationCenter.default.then.removeObserver(routeChangeToken)
    }
    
    public init(contentsOf url: URL, fileTypeHint utiString: String?, delegate: ThenAudioPlayerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: utiString)
            setup()
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
        }
    }
    
    public init(data: Data, fileTypeHint utiString: String?, delegate: ThenAudioPlayerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        do {
            player = try AVAudioPlayer(data: data, fileTypeHint: utiString)
            setup()
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
        }
    }
    
    public init(forResource name: String?, ofType ext: String? = nil, delegate: ThenAudioPlayerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            let error = NSError(domain: NSError.NormalErrorDomain,
                                code: NSURLErrorFileDoesNotExist,
                                userInfo: [NSLocalizedDescriptionKey: "resource file not found!"])
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
            return
        }
        var data: Data?
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
        }
        
        guard let audioData = data else {
            let error = NSError(domain: NSError.NormalErrorDomain,
                                code: NSURLErrorCannotDecodeRawData,
                                userInfo: [NSLocalizedDescriptionKey: "cannot decode file data!"])
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
            return
        }
        
        do {
            player = try AVAudioPlayer(data: audioData)
            setup()
        } catch {
            print("\(error.localizedDescription)")
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
        }
    }
    
    private func setup() {
        player?.delegate = self
        player?.prepareToPlay()
        handleNotifications()
    }
    
    private var interruptionToken: NSObjectProtocol?
    private var routeChangeToken: NSObjectProtocol?
    
    private func handleNotifications() {
        let interruptionName = AVAudioSession.interruptionNotification
        interruptionToken = NotificationCenter.default.then.addObserver(forName: interruptionName) { [weak self] in
            self?.handleAudioInterrupution($0)
        }
        let routeChangeName = AVAudioSession.routeChangeNotification
        routeChangeToken = NotificationCenter.default.then.addObserver(forName: routeChangeName) { [weak self] in
            self?.handleAudioSessionRouteChange($0)
        }
    }
    
    private func handleAudioInterrupution(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let type = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType,
            let options = userInfo[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions
            else {
                return
        }
        audioPlayerInterruptionChange(type: type, options: options)
    }
    
    private func handleAudioSessionRouteChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? AVAudioSession.RouteChangeReason
            else {
                return
        }
        audioPlayerRouteChange(reason: reason)
    }
    
    open func audioPlayerInterruptionChange(type: AVAudioSession.InterruptionType,
                                       options: AVAudioSession.InterruptionOptions) {
        delegate?.audioPlayerInterruptionChange(self, type: type, options: options)
    }
    
    open func audioPlayerRouteChange(reason: AVAudioSession.RouteChangeReason) {
        delegate?.audioPlayerRouteChange(self, reason: reason)
    }
    
}

// MARK: AVAudioPlayerDelegate
extension ThenAudioPlayer: AVAudioPlayerDelegate {
    
    open func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayerDidFinishPlaying(self, successfully: flag)
    }
    
    open func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
    }
    
    open func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        delegate?.audioPlayerBeginInterruption(self)
    }
    
    open func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        delegate?.audioPlayerEndInterruption(self, withOptions: flags)
    }

}
