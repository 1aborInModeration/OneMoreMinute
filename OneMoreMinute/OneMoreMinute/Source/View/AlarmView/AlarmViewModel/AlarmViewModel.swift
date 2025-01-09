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
    
    private(set) var dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
    private(set) var alarmButtonTapped = PublishRelay<IndexPath>()
    private(set) var deleteButtonTapped = PublishRelay<IndexPath>()
 
    init() {
        dataFetch()
    }
    
    func dataFetch() {
        Observable.from([coreDataManager.fetch()])
            .map { data in
                data.map { AlarmItem(data: $0) }
            }
            .map { items -> [AlarmSectionModel] in
                [AlarmSectionModel(identity: "AlarmSectionModel", items: items)]
            }
            .subscribe(onNext: { [weak self] models in
                self?.dataRelay.accept(models)
            })
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
