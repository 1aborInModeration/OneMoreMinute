//
//  HapticService.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit

enum HapticService {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
    
    static let impactGenerator = UIImpactFeedbackGenerator()
    static let notificationGenerator = UINotificationFeedbackGenerator()
    static let feedbackGenerator = UISelectionFeedbackGenerator()
    
    func run() {
        switch self {
        case let .impact(style):
            let generator = HapticService.impactGenerator
            generator.prepare()
            generator.impactOccurred()
        case let .notification(type):
            let generator = HapticService.notificationGenerator
            generator.prepare()
            generator.notificationOccurred(type)
        case .selection:
            let generator = HapticService.feedbackGenerator
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
