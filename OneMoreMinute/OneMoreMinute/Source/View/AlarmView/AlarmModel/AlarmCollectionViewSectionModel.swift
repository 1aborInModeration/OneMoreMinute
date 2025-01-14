//
//  AlarmCollectionViewSectionModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import RxSwift
import RxCocoa
import RxDataSources
import Foundation

/// 컬렉션뷰 데이터소스의 아이템 정의
struct AlarmItem: IdentifiableType, Hashable {
    typealias Identity = UUID
    var identity: Identity {
        data.id ?? UUID()
    }
    
    let data: Alarm
}

/// 컬렉션뷰 데이터소스의 섹션 정의
struct AlarmSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = AlarmItem
    
    var identity: String {
        return String(describing: Self.self)
    }
    var items: [AlarmItem]
    
    init(items: [AlarmItem]) {
        self.items = items
    }
    
    init(original: AlarmSectionModel, items: [AlarmItem]) {
        self = original
        self.items = items
    }
}
