//
//  ThenTextPlayer.swift
//  ThenFoundation
//
//  Created by ghost on 2023/7/21.
//

import Foundation
import AVFoundation

public enum TextPlayAction {
    case start
    case finish
    case pause
    case `continue`
    case cancel
    case willSpeakRange(NSRange)
}

public typealias ThenTextPlayerClosure = (AVSpeechSynthesizer, TextPlayAction, AVSpeechUtterance) -> ()

public final class ThenTextPlayer: NSObject {
    
    var closure: ThenTextPlayerClosure?
    
    var speechSynthesizer: AVSpeechSynthesizer
    
    override init() {
        speechSynthesizer = AVSpeechSynthesizer()
        super.init()
        speechSynthesizer.delegate = self
    }
    
    public func play(_ utterance: AVSpeechUtterance, closure: ThenTextPlayerClosure? = nil) {
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)

        self.closure = closure
        self.speechSynthesizer.speak(utterance)
    }
    
    public func play(_ text: String, closure: ThenTextPlayerClosure? = nil) {
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        self.closure = closure
        self.speechSynthesizer.speak(AVSpeechUtterance(string: text))
    }
    
}

extension ThenTextPlayer: AVSpeechSynthesizerDelegate {
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .start, utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .finish, utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .pause, utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .continue, utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .cancel, utterance)
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        self.closure?(synthesizer, .willSpeakRange(characterRange), utterance)
    }
    
}
