//
//  AlarmNotificationWeekDays.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/13/25.
//

enum AlarmNotificationWeekDays: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var value: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}
