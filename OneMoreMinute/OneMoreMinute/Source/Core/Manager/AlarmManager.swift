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

/// 알람 재생 중 발생하는 에러 열거형
enum AlarmError: LocalizedError {
    case invalidFileUrl
}

/// 재생할 알람 소리 종류를 나타내는 열거형
enum AlarmSound {
    case morning
    
    var fileUrl: URL? {
        switch self {
        case .morning:
            return Bundle.main.url(forResource: "morningAlarm", withExtension: "caf")
        }
    }
}

/// 앱에서 알람 소리를 재생하는 기능을 가지는 객체
final class AlarmManager: AlarmManageable {
    private var player: AVAudioPlayer?
    
    /// 지정된 알람 소리를 재생하는 함수
    /// - Parameters:
    ///   - sound: 재생할 알람 소리 -> AlarmSound 열거형 참고
    ///   - numberOfLoops: 몇 번 재생할 것인지 설정하는 매개변수
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
    
    /// 알람 소리 재생 멈춤 함수
    func stopAlarm() throws {
        player?.stop()
    }
}
