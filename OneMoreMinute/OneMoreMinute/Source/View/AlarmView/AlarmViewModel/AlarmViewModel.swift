//
//  AlarmViewModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

/// 알람 뷰의 뷰 모델
final class AlarmViewModel {
    // 추후 리팩토링으로 input, output 구현 예정
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
    private let coreDataManager = AlarmDataManager.shared
    private let disposeBag = DisposeBag()
    
    private(set) var dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
    private(set) var alarmButtonTapped = PublishRelay<IndexPath>()
    private(set) var deleteButtonTapped = PublishRelay<IndexPath>()
 
    // MARK: - AlarmViewModel Initializer
    init() {
        dataFetch()
    }
    
    /// 코어 데이터의 데이터를 불러와 이벤트를 전달하는 메소드
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
}
