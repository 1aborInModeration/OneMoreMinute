//
//  StopwatchModel.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-12.
//

import Foundation

struct StopwatchModel {
    var isRunning: Bool
    var elapsedTime: TimeInterval
    var laps: [LapModel]
}

struct LapModel: Codable {
    let lapNumber: Int
    let lapTime: TimeInterval
}
