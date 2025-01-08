//
//  CoreDateProtocol.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/7/25.
//

import UIKit
import CoreData

/// 코어데이터 관리 객체가 기본 기능 추상화
protocol CoreDataManaged: AnyObject {
    associatedtype Model: EntityTransformAble
    associatedtype Entity: NSManagedObject
    
    var persistentContainer: NSPersistentContainer { get }
    
    func create(with model: Model)
    func fetch() -> [Entity]
    func delete(_ entity: Entity)
    func save() throws
}

/// 엔티티DTO 파일의 기본 기능 추상화
protocol EntityTransformAble {
    associatedtype Entity: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> Entity
}

// CoreDataManaged 프로토콜의 기본 구현
extension CoreDataManaged {
    /// persistentContainer를 기본 구현
    /// CoreDataManaged 프로토콜을 채택하는 모든 클래스가 같은 persistentContainer를 공유
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }
}
