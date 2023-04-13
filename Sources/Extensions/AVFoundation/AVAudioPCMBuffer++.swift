//
//  AVAudioPCMBuffer++.swift
//  ThenFoundation
//
//  Created by 陈卓 on 2023/4/13.
//

import Foundation
import AVFoundation

public extension AVAudioPCMBuffer {
        
    /// Deal output format buffer to float32 format
    ///   inputNode.installTap(onBus: 0, bufferSize: 44100, format: inputFormat) { buffer, _ in
    ///     let floats = buffer.float32Buffer()
    ///     /// deal floats buffer data
    ///   }
    func float32Buffer() -> [Float] {
        /// 判定Int16还是Float32
        switch format.commonFormat {
        case .pcmFormatInt16:
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: format.sampleRate, channels: format.channelCount, interleaved: false), let floatBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else {
                print("Init a pcmFormatFloat32 format from buffer failed.")
                return []
            }
            guard let floatData = floatBuffer.floatChannelData, let int16Data = int16ChannelData else {
                return []
            }
            for frame in 0..<Int(frameLength) {
                for channel in 0..<Int(format.channelCount) {
                    let value = Float32(int16Data[channel][frame]) / Float32(Int16.max)
                    floatData[channel][frame] = value
                }
            }
            let floats = Array(UnsafeBufferPointer(start: floatData[0], count: Int(floatBuffer.frameLength)))
            return floats
        case .pcmFormatFloat32:
            guard let floatChannelData = floatChannelData else {
                return []
            }
            let frameLength = Int(frameLength)
            let channelCount = Int(format.channelCount)
            let floats = (0..<frameLength).flatMap { frameIndex -> [Float] in
                return (0..<channelCount).map { channelIndex -> Float in
                    return floatChannelData[channelIndex][frameIndex]
                }
            }
            return floats
        default:
            return []
        }
    }
}

