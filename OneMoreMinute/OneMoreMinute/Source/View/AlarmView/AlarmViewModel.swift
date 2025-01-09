//
//  AlarmViewModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AlarmViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let coreDataManager = AlarmDataManager.shared
    
    private let disposeBag = DisposeBag()
    
    private(set) var data = BehaviorRelay(value: [AlarmSectionModel]())
    
    private(set) var alarmButtonTapped = PublishRelay<IndexPath>()
    private(set) var deleteButtonTapped = PublishRelay<IndexPath>()
    
    init() {
        dataFetch()
    }
    
    func dataFetch() {
        let data = self.coreDataManager.fetch()
        let items: [AlarmItem] = {
            var alarmItems: [AlarmItem] = []
            data.forEach {
                let item = AlarmItem.init(data: $0)
                alarmItems.append(item)
            }
            return alarmItems
        }()
        
        let model = AlarmSectionModel.init(identity: "AlarmSectionModel", items: items)
        self.data.accept([model])
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
