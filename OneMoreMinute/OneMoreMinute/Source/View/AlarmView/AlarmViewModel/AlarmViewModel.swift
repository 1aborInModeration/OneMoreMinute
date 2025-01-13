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
        let alarmToggleButtonTapped: PublishRelay<IndexPath>
        let deleteButtonTapped: PublishRelay<IndexPath>
    }
    
    struct Output {
        let dataRelay: BehaviorRelay<[AlarmSectionModel]>
        let reloadIndex: PublishRelay<IndexPath>
        let deleteIndex: PublishRelay<IndexPath>
    }
    
    
    func transform(input: Input) -> Output {
        input.alarmToggleButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                owner.toggleAlarmState(indexPath)
                
            }.disposed(by: self.disposeBag)
        
        input.deleteButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                owner.deleteAlarm(indexPath)
                
            }.disposed(by: self.disposeBag)
        
        return Output(
            dataRelay: self.dataRelay,
            reloadIndex: self.reloadIndex,
            deleteIndex: self.deleteIndex
        )
    }
    
    private let repositoryManager = AlarmDataManager.shared
    private let disposeBag = DisposeBag()
    
    private let dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
    private let reloadIndex = PublishRelay<IndexPath>()
    private let deleteIndex = PublishRelay<IndexPath>()
 
    // MARK: - AlarmViewModel Initializer
    init() {
        dataFetch()
    }
    
    /// 코어 데이터의 데이터를 불러와 이벤트를 전달하는 메소드
    func dataFetch() {
        let data = repositoryManager.fetch()
        let items = data.map { AlarmItem(data: $0) }
        let models = [AlarmSectionModel(items: items)]
        self.dataRelay.accept(models)
    }
    
    private func toggleAlarmState(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        let id = data.objectID
        data.isActive.toggle()
        
        repositoryManager.update(id, updateData: data)
        
        self.reloadIndex.accept(indexPath)
    }
    
    private func deleteAlarm(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        
        repositoryManager.delete(data)
        
        self.dataFetch()
    }
}
