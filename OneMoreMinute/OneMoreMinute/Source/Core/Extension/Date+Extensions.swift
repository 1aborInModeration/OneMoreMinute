//
//  Date+Extensions.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

import Foundation

/// - `getTimeString()`: 날짜의 시간을 "HH:mm" 형식의 문자열로 반환합니다.
extension Date {
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
