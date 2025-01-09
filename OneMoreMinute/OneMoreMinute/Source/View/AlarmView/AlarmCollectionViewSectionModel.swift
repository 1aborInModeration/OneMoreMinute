//
//  AlarmCollectionViewSectionModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import RxSwift
import RxCocoa
import RxDataSources

struct AlarmItem: IdentifiableType, Hashable {
    typealias Identity = Int
    var identity: Identity {
        return self.hashValue
    }
    
    let data: Alarm
}

struct AlarmSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = AlarmItem
    
    var identity: String
    var items: [AlarmItem]
    
    init(identity: String, items: [AlarmItem]) {
        self.identity = identity
        self.items = items
    }
    
    init(original: AlarmSectionModel, items: [AlarmItem]) {
        self = original
        self.items = items
    }
}
