//
//  AlarmViewExtensionModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/10/25.
//

import Foundation

enum WeekDaysString: Int {
    case mon, tue, wed, thu, fri, sat, sun
    
    var WeekDayString: String {
        switch self {
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        case .sun:
            return "일"
        }
    }
}
