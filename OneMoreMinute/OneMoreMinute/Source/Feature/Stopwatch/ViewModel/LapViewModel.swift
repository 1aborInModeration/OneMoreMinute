//
//  LapViewModel.swift
//  OneMoreMinute
//
//  Created by DoyleHWorks on 2025-01-12.
//

import Foundation

struct LapViewModel {
    private let model: LapModel
    let isFastest: Bool
    let isSlowest: Bool

    init(model: LapModel, isFastest: Bool = false, isSlowest: Bool = false) {
        self.model = model
        self.isFastest = isFastest
        self.isSlowest = isSlowest
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
