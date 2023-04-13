//
//  AVAudioSession++.swift
//  ThenFoundation
//
//  Created by 陈卓 on 2023/4/13.
//

import Foundation
import AVFoundation

public extension AVAudioSession {
    
    /// Request Record Audio Permission
    /// - Parameter completion: permission result
    func loadRecordPermission(completion: @escaping (Bool) -> ()) {
        switch recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            requestRecordPermission { value in
                completion(value)
            }
        default:
            break
        }
    }
}
