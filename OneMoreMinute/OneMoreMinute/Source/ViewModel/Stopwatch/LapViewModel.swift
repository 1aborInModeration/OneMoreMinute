//
//  LapViewModel.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-12.
//

import Foundation

struct LapViewModel {
    private let model: LapModel

    init(model: LapModel) {
        self.model = model
    }
    
    var lapLabel: String {
        return "랩 \(model.lapNumber)"
    }
    
    var lapTimeLabel: String {
        let minutes = Int(model.lapTime) / 60
        let seconds = model.lapTime.truncatingRemainder(dividingBy: 60)
        return String(format: "%02d:%05.2f", minutes, seconds)
    }
}
