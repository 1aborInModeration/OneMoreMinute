//
//  WorldTimeItem.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/13/25.
//

import Foundation

struct WorldTime {
    let cityName: String
    var currentTime: String
    var currentDate: String
    
    
    mutating func updateTime(timeZoneId: String) {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: timeZoneId) ?? TimeZone.current
        
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: Date())
        
        formatter.dateFormat = "MM월 dd일 EEEE"
        currentDate = formatter.string(from: Date())
        
        
        
    
    }
}
