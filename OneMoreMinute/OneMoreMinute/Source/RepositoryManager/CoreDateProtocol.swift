//
//  CoreDateProtocol.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

protocol CoreDataManaged: AnyObject {
    associatedtype Model: EntityTransformAble
    associatedtype Entity: NSManagedObject
    
    var persistentContainer: NSPersistentContainer { get }
    
    func create(with model: Model)
    func fetch() -> [Entity]
    func delete(_ entity: Entity)
    func save()
}

protocol EntityTransformAble {
    associatedtype Entity: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> Entity
}

extension CoreDataManaged {
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }
}
