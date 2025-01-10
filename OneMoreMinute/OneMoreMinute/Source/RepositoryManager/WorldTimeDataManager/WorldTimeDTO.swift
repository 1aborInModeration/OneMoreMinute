//
//  WorldTimeDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/10/25.
//

import UIKit
import CoreData

struct WorldTimeDTO: EntityTransformAble {
    let cityName: String
    let timeZoneld: String
    let createdAt: Date
    
    func toEntity(context: NSManagedObjectContext) -> WorldTimeEntity {
        let wordTimeEntity = WorldTimeEntity(context: context)
        wordTimeEntity.cityName = self.cityName
        wordTimeEntity.timeZoneld = self.timeZoneld
        wordTimeEntity.createAt = self.createdAt
        
        return wordTimeEntity
    }
}
