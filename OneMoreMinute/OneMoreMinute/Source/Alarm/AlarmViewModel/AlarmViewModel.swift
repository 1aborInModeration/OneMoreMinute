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
final class AlarmViewModel: ViewModelType {
    struct Input {
        let alarmToggleButtonTapped: PublishRelay<IndexPath>
        let deleteButtonTapped: PublishRelay<IndexPath>
        let saveButtonTapped: PublishRelay<CGPoint>
    }
    
    struct Output {
        let dataRelay: BehaviorRelay<[AlarmSectionModel]>
        let reloadIndex: PublishRelay<IndexPath>
        let deleteIndex: PublishRelay<IndexPath>
        let scrollIndex: PublishRelay<CGPoint>
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
        
        input.saveButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, location in
                
                owner.keepScrollToItem(location)
                
            }.disposed(by: self.disposeBag)
        
        return Output(
            dataRelay: self.dataRelay,
            reloadIndex: self.reloadIndex,
            deleteIndex: self.deleteIndex,
            scrollIndex: self.scrollIndex
        )
    }
    
    private let alarmDataManager = AlarmDataManager.shared
    let disposeBag = DisposeBag()
    
    private let dataRelay = BehaviorRelay(value: [AlarmSectionModel]())
    private let reloadIndex = PublishRelay<IndexPath>()
    private let deleteIndex = PublishRelay<IndexPath>()
    private let scrollIndex = PublishRelay<CGPoint>()
    
    // MARK: - Initializer
    
    init() {
        dataFetch()
    }
    
    // MARK: - Methods
    
    /// 코어 데이터의 데이터를 불러와 이벤트를 전달하는 메소드
    func dataFetch() {
        let data = alarmDataManager.fetch()
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
        
        // 알람 on/off에 따라 푸시 알림 설정 / 미설정
        if data.isActive {
            setupAlarmNotifications(for: data)
        } else {
            removeAlarmNotifications(for: data)
        }
        
        alarmDataManager.update(id, updateData: data)
        self.reloadIndex.accept(indexPath)
    }
    
    /// 알람을 삭제하는 메소드
    /// - Parameter indexPath: 삭제할 셀의 indexPath
    private func deleteAlarm(_ indexPath: IndexPath) {
        let data = self.dataRelay.value[indexPath.section].items[indexPath.item].data
        
        removeAlarmNotifications(for: data)
        alarmDataManager.delete(data)
        
        self.dataFetch()
        
        self.deleteIndex.accept(indexPath)
    }
    
    /// 아이템을 수정했을 때, 스크롤 위치를 유지하는 메소드
    /// - Parameter location: 현재 스크롤 위치
    private func keepScrollToItem(_ location: CGPoint) {
        self.dataFetch()
        
        self.scrollIndex.accept(location)
    }
    
    /// 알람 알림을 설정하는 헬퍼 메소드
    /// - Parameter data: 알람 데이터
    private func setupAlarmNotifications(for data: Alarm) {
        guard let time = data.time,
              let weekDays = data.weekDays,
              let uuidString = data.id?.uuidString else { return }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        let weekDayMapping: [(day: Bool, suffix: String, weekday: AlarmNotificationWeekDays)] = [
            (weekDays.mon, ".mon", .monday),
            (weekDays.tue, ".tue", .tuesday),
            (weekDays.wed, ".wed", .wednesday),
            (weekDays.thu, ".thu", .thursday),
            (weekDays.fri, ".fri", .friday),
            (weekDays.sat, ".sat", .saturday),
            (weekDays.sun, ".sun", .sunday)
        ]
        
        var isWeekDayNil = true
        
        for (isEnabled, suffix, weekday) in weekDayMapping where isEnabled {
            AlarmNotificationManager.shared.setRegularNotification(
                identifier: uuidString + suffix,
                title: time.getTimeString(),
                body: data.note ?? "",
                weekday: weekday,
                hour: .init(rawValue: hour),
                minute: .init(rawValue: minute)!
            )
            isWeekDayNil = false
        }
        
        if isWeekDayNil {
            AlarmNotificationManager.shared.setRegularNotification(
                identifier: uuidString,
                title: time.getTimeString(),
                body: data.note ?? "",
                hour: .init(rawValue: hour),
                minute: .init(rawValue: minute)!
            )
        }
    }
    
    /// 알람 알림을 제거하는 헬퍼 메소드
    /// - Parameter data: 알람 데이터
    private func removeAlarmNotifications(for data: Alarm) {
        guard let uuidString = data.id?.uuidString else { return }
        let identifiers = [
            uuidString,
            uuidString + ".mon",
            uuidString + ".tue",
            uuidString + ".wed",
            uuidString + ".thu",
            uuidString + ".fri",
            uuidString + ".sat",
            uuidString + ".sun"
        ]
        AlarmNotificationManager.shared.removePendingNotification(by: identifiers)
    }
    
}
