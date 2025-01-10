//
//  AlarmViewExtensionModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/10/25.
//

import Foundation

extension Int {
    var weekTitle: String {
        switch self {
        case 0:
            return "월"
        case 1:
            return "화"
        case 2:
            return "수"
        case 3:
            return "목"
        case 4:
            return "금"
        case 5:
            return "토"
        case 6:
            return "일"
        default:
            return ""
        }
    }
}
