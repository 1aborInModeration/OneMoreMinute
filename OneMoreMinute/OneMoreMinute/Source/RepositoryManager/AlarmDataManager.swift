//
//  CoreDataManager.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

/// Alarm 엔티티를 관리하는 코어 데이터 객체
final class AlarmDataManager: CoreDataManaged {
    typealias Model = AlarmDTO
    typealias Entity = Alarm
    
    private lazy var context = self.persistentContainer.viewContext
    
    static let shared = AlarmDataManager() // 싱글톤
    private init() {}
    
    // MARK: - AlarmDataManager CRUD Method
    
    /// Alarm 엔티티에 새로운 데이터를 추가하는 메소드
    /// - Parameter model: AlarmDTO
    ///
    /// ``EntityTransformAble``
    /// ``AlarmDTO``
    func create(with model: Model) {
        _ = model.toEntity(context: context)
        try? save()
    }
    
    /// Alarm 엔티티의 데이터 목록을 불러오는 메소드
    /// - Returns: Alarm 엔티티의 데이터 목록 배열
    func fetch() -> [Entity] {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    /// Alarm 엔티티의 데이터를 삭제하는 메소드
    /// - Parameter entity: 삭제할 Alarm 데이터
    func delete(_ entity: Entity) {
        context.delete(entity)
        try? save()
    }
    
    /// Alarm 엔티티의 변경사항을 저장하는 메소드
    func save() throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data: \(error)")
        }
    }
}
