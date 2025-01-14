//
//  AlarmNotificationDateComponent.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/13/25.
//

import Foundation

struct AlarmNotificationDateComponent {
    private let weekday: AlarmNotificationWeekDays?
    private let hour: AlarmNotificationHours?
    private let minute: AlarmNotificationMinutes
    
    /// 알림 시간을 지정하는 기능을 담당하는 객체
    /// - Parameters:
    ///   - weekday: 월, 화, 수, 목, 금, 토, 일 중 반복할 요일 설정
    ///   - hour: 시간 설정
    ///   시간은 0 ~ 23 범위
    ///   - minute: 분 설정
    ///   분은 0 ~ 59 범위
    init(weekday: AlarmNotificationWeekDays? = nil, hour: AlarmNotificationHours? = nil, minute: AlarmNotificationMinutes) {
        self.weekday = weekday
        self.hour = hour
        self.minute = minute
    }
    
    func dateComponents() -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday?.value
        dateComponents.hour = hour?.value
        dateComponents.minute = minute.value
        return dateComponents
    }
}
