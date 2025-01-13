//
//  WorldTimeDTO.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/10/25.
//

import UIKit
import CoreData

/// WorldTime 엔티티의 데이터 파일
struct WorldTimeDTO: EntityTransformAble {
    let cityName: String
    let timeZoneld: String
    let createdAt: Date
    
    /// WorldTime 엔티티 데이터 타입을 반환하는 메소드
    /// - Parameter context: 엔티티 관리 Context
    /// - Returns: WorldTime 엔티티 데이터 타입
    func toEntity(context: NSManagedObjectContext) -> WorldTimeEntity {
        let wordTimeEntity = WorldTimeEntity(context: context)
        wordTimeEntity.cityName = self.cityName
        wordTimeEntity.timeZoneld = self.timeZoneld
        wordTimeEntity.createAt = self.createdAt
        
        return wordTimeEntity
    }
}
