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
    struct Input {
        let alarmToggleButtonTapped: PublishRelay<IndexPath>
        let deleteButtonTapped: PublishRelay<IndexPath>
    }
    
    struct Output {
        let dataRelay: BehaviorRelay<[AlarmSectionModel]>
        let reloadIndex: PublishRelay<IndexPath>
    }
    
    /// 뷰 모델 데이터 바인딩 메소드
    /// - Parameter input: 알람 토글 버튼 이벤트, 삭제 버튼 이벤트
    /// - Returns: 컬렉션뷰 데이터소스 데이터, reload cell indexPath
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
            reloadIndex: self.reloadIndex
        )
    }
    
    private let repositoryManager = AlarmDataManager.shared
    private let disposeBag = DisposeBag()
    
    private let dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
    private let reloadIndex = PublishRelay<IndexPath>()
 
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
    
    /// 알람 버튼의 상태를 변경하고 저장하는 메소드
    /// - Parameter indexPath: 알람 상태가 변경된 셀의 indexPath
    private func toggleAlarmState(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        let id = data.objectID
        data.isActive.toggle()
        
        repositoryManager.update(id, updateData: data)
        
        self.reloadIndex.accept(indexPath)
    }
    
    /// 알람을 삭제하는 메소드
    /// - Parameter indexPath: 삭제할 셀의 indexPath
    private func deleteAlarm(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        
        repositoryManager.delete(data)
        
        self.dataFetch()
    }
}
