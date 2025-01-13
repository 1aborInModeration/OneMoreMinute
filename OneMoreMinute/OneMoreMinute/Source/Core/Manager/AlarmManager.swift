//
//  AlarmManager.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/13/25.
//

import Foundation
import AVFoundation

protocol AlarmManageable {
    func playAlarm(sound: AlarmSound, numberOfLoops: Int) throws
    func stopAlarm() throws
}

enum AlarmError: LocalizedError {
    case invalidFileUrl
}

enum AlarmSound {
    case morning
    
    var fileUrl: URL? {
        switch self {
        case .morning:
            return Bundle.main.url(forResource: "morningAlarm", withExtension: "mp3")
        }
    }
}

final class AlarmManager: AlarmManageable {
    private var player: AVAudioPlayer?
    
    func playAlarm(sound: AlarmSound, numberOfLoops: Int) throws {
        guard !(player?.isPlaying ?? false) else {
            return
        }
        
        guard let fileUrl = sound.fileUrl else {
            throw AlarmError.invalidFileUrl
        }
        
        player = try AVAudioPlayer(contentsOf: fileUrl)
        player?.volume = 1.0
        player?.numberOfLoops = numberOfLoops
        player?.play()
    }
    
    func stopAlarm() throws {
        player?.stop()
    }
}
