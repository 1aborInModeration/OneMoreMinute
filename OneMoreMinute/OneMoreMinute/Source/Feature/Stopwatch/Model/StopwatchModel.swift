//
//  StopwatchModel.swift
//  OneMoreMinute
//
//  Created by DoyleHWorks on 2025-01-12.
//

import Foundation

/// StopwatchModel 구조체는 스톱워치의 상태와 데이터를 표현합니다.
struct StopwatchModel {
    var isRunning: Bool
    var elapsedTime: TimeInterval
    var laps: [LapModel]
}

/// LapModel 구조체는 각각의 랩 정보를 저장합니다.
struct LapModel: Codable {
    let lapNumber: Int
    let lapTime: TimeInterval
}
