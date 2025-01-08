//
//  AlarmDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

/// Alarm 엔티티의 데이터 파일
struct AlarmDTO: EntityTransformAble {
    let isActive: Bool
    let note: String?
    let time: Date
    let weekDays: WeekDaysDTO
    
    /// Alarm 엔티티 데이터 타입을 반환하는 메소드
    /// - Parameter context: 엔티티 관리 Context
    /// - Returns: Alarm 엔티티 데이터 타입
    func toEntity(context: NSManagedObjectContext) -> Alarm {
        let alarm = Alarm(context: context)
        alarm.isActive = self.isActive
        alarm.note = self.note
        alarm.time = self.time
        
        let weekDaysEntity = self.weekDays.toEntity(context: context)
        alarm.weekDays = weekDaysEntity
        
        return alarm
    }
}
