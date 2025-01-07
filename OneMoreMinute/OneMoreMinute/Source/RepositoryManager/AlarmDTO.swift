//
//  AlarmDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

struct AlarmDTO: EntityTransformAble {
    let isActive: Bool
    let note: String?
    let time: Date
    let weekDays: WeekDaysDTO
    
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
