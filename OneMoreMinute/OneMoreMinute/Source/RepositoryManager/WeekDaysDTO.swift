//
//  WeekDaysDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

/// WeekDays 엔티티의 데이터 파일
struct WeekDaysDTO: EntityTransformAble {
    let mon: Bool
    let tue: Bool
    let wed: Bool
    let thu: Bool
    let fri: Bool
    let sat: Bool
    let sun: Bool
    
    /// WeekDays 엔티티 데이터 타입을 반환하는 메소드
    /// - Parameter context: 엔티티 관리 Context
    /// - Returns: WeekDays 엔티티 데이터 타입
    func toEntity(context: NSManagedObjectContext) -> WeekDays {
        let weekDays = WeekDays(context: context)
        weekDays.mon = self.mon
        weekDays.tue = self.tue
        weekDays.wed = self.wed
        weekDays.thu = self.thu
        weekDays.fri = self.fri
        weekDays.sat = self.sat
        weekDays.sun = self.sun
        
        return weekDays
    }
    
    func someProperties() -> [Bool] {
        let properties = [
            self.mon,
            self.tue,
            self.wed,
            self.thu,
            self.fri,
            self.sat,
            self.sun
        ]
        
        return properties
    }
}
