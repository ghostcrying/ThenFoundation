//
//  AudioOperater.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//

import Foundation
import CoreAudio
import AVFoundation

public struct AudioOperate {
    
    /// 切割大型音频文件
    /// chunkDuration: 1~60, 默认60s切分
    static func sliceAudioFile(inputURL: URL, outputURL: URL, perDuration: TimeInterval = 60 ,progress: ((_ percent: CGFloat) -> ())? = nil, completion: @escaping (Error?) -> ()) {
        let asset = AVAsset(url: inputURL)
        let duration = asset.duration.seconds
        var chunkDuration = perDuration
        if perDuration > 60 {
            chunkDuration = 60
        } else if perDuration < 1 {
            chunkDuration = 1
        }
        var startTime = 0.0
        
        while startTime < duration {
            let chunkOutputURL = outputURL.appendingPathComponent("\(Int(startTime)).m4a")
            let endTime = min(startTime + chunkDuration, duration)
            let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                        end: CMTime(seconds: endTime, preferredTimescale: 1000))
            
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            exporter?.outputFileType = .m4a
            exporter?.outputURL = chunkOutputURL
            exporter?.timeRange = timeRange
            
            exporter?.exportAsynchronously(completionHandler: {
                // Handle the completion or error
                if exporter?.status == .completed {
                    progress?(startTime/duration)
                    print("Exported chunk: \(chunkOutputURL)")
                } else if exporter?.status == .failed {
                    print("Export failed: \(exporter?.error?.localizedDescription ?? "Unknown error")")
                    completion(NSError(domain: "com.then.audio.slice", description: "Failed export slice audio file at time: \(startTime)."))
                }
            })
            
            startTime += chunkDuration
        }
        completion(nil)
    }

    /// 合并多个音频文件
    static func combineAudioFiles(inputURLs: [URL], outputURL: URL, outputFileType: AVFileType, progress: ((_ percent: CGFloat) -> ())? = nil, completion: @escaping (Error?) -> ()) {
        let composition = AVMutableComposition()
        guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(NSError(domain: "com.then.audio.combine", description: "Failed to create AVMutableCompositionTrack."))
            return
        }
        let total = inputURLs.count
        var currentTime = CMTime.zero
        for (i, inputURL) in inputURLs.enumerated() {
            let asset = AVAsset(url: inputURL)
            let audioAssetTrack = asset.tracks(withMediaType: .audio)[0]
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: audioAssetTrack, at: currentTime)
            } catch {
                completion(error)
                return
            }
            progress?(CGFloat(i) / CGFloat(total))
            currentTime = CMTimeAdd(currentTime, asset.duration)
        }
        
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            completion(NSError(domain: "com.then.audio.combine", description: "Failed to create AVAssetExportSession."))
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = outputFileType
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(nil)
            case .failed:
                completion(exportSession.error)
            case .cancelled:
                completion(NSError(domain: "com.then.audio.combine", description: "Export session cancelled."))
            default:
                break
            }
        }
    }
    
    /// 转换文件格式 (统一文件格式)
    /// let inputURL = URL(fileURLWithPath: "/path/to/input/file.mp3")
    /// let outputURL = URL(fileURLWithPath: "/path/to/output/file.m4a")
    /// convertAudioFile(inputURL: inputURL, outputURL: outputURL, outputFileType: .m4a) { error in
    ///   if let error = error {
    ///      print("Error converting audio file: \(error.localizedDescription)")
    ///   } else {
    ///      print("Audio file converted successfully.")
    ///   }
    static func convertAudioFile(inputURL: URL, outputURL: URL, outputFileType: AVFileType, completion: @escaping (Error?) -> Void) {
        let asset = AVAsset(url: inputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completion(NSError(domain: "com.then.audio.convert", description: "Failed to create AVAssetExportSession."))
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = outputFileType
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(nil)
            case .failed:
                completion(exportSession.error)
            case .cancelled:
                completion(NSError(domain: "com.then.audio.convert", description: "Export session cancelled."))
            default:
                break
            }
        }
    }

}
