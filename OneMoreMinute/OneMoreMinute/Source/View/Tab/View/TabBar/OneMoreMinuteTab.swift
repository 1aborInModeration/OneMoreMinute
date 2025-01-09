//
//  OneMoreMinuteTab.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit

/// OneMoreMinute 앱의 하단 탭바에 표시될 탭 아이템들을 정의하는 열거형
enum OneMoreMinuteTab: CaseIterable {
    case alarm
    case worldTime
    case stopWatch
    case timer
    
    /// 각 탭에 해당하는 이미지를 반환하는 computed property
    var image: UIImage {
        switch self {
        case .alarm:
            return UIImage(resource: .alarm)
        case .worldTime:
            return UIImage(resource: .worldTime)
        case .stopWatch:
            return UIImage(resource: .stopWatch)
        case .timer:
            return UIImage(resource: .timer)
        }
    }
    
    /// 각 탭의 제목을 반환하는 computed property
    var title: String {
        switch self {
        case .alarm:
            return "알람"
        case .worldTime:
            return "세계시간"
        case .stopWatch:
            return "스톱워치"
        case .timer:
            return "타이머"
        }
    }
    
    /// 각 탭의 인덱스를 반환하는 computed property
    var index: Int {
        switch self {
        case .alarm:
            return 0
        case .worldTime:
            return 1
        case .stopWatch:
            return 2
        case .timer:
            return 3
        }
    }
}
