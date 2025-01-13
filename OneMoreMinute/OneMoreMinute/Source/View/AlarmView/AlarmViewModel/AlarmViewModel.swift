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
    
    private let repositoryManager = AlarmDataManager.shared
    private let disposeBag = DisposeBag()
    
    private(set) var dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
 
    // MARK: - AlarmViewModel Initializer
    init() {
        dataFetch()
    }
    
    /// 코어 데이터의 데이터를 불러와 이벤트를 전달하는 메소드
    func dataFetch() {
        Observable.from([repositoryManager.fetch()])
            .map { data in
                data.map { AlarmItem(data: $0) }
            }
            .map { items -> [AlarmSectionModel] in
                [AlarmSectionModel(items: items)]
            }
            .subscribe(onNext: { [weak self] models in
                self?.dataRelay.accept(models)
            })
            .disposed(by: disposeBag)
    }
    
    func alarmOnButtonTapped(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        let id = data.objectID
        data.isActive.toggle()
        
        repositoryManager.update(id, updateData: data)
        dataFetch()
    }
    
    func deleteButtonTapped(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        
        repositoryManager.delete(data)
        dataFetch()
    }
}
