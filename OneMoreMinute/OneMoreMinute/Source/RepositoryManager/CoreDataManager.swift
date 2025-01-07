//
//  CoreDataManager.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

final class CoreDataManager: CoreDataManaged {
    typealias Model = AlarmDTO
    typealias Entity = Alarm
    
    private lazy var context = self.persistentContainer.viewContext
    
    static let shared = CoreDataManager()
    private init() {}

    func create(with model: Model) {
        _ = model.toEntity(context: context)
        save()
    }
    
    func fetch() -> [Entity] {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func delete(_ entity: Entity) {
        context.delete(entity)
        save()
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data: \(error)")
        }
    }
}
