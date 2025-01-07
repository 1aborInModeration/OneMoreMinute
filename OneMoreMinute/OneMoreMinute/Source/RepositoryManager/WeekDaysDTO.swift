//
//  WeekDaysDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

struct WeekDaysDTO: EntityTransformAble {
    let mon: Bool
    let tue: Bool
    let wed: Bool
    let thu: Bool
    let fri: Bool
    let sat: Bool
    let sun: Bool
    
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
}
