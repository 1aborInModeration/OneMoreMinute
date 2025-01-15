//
//  AlarmModalViewController.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard

/// 알람뷰의 상태를 나타내는 enum
///
/// **create**: 새로 생성
///
/// **edit**: 수정
enum AlarmModalState {
    case create
    case edit
}

/// 알람뷰 모달 컨트롤러
final class AlarmModalViewController: UIViewController {
    
    private(set) var disposeBag = DisposeBag()
    private(set) var backgroundTapped = PublishRelay<Bool>()
    
    private let alarmDataManager = AlarmDataManager.shared
    
    private(set) var state: AlarmModalState
    private var data: Alarm?
    
    private(set) lazy var modalView = AlarmModalView(state: self.state)
    
    // MARK: - Initializer
    
    init(state: AlarmModalState, data: Alarm?) {
        self.state = state
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
        guard self.modalView != touches.first?.view else { return }
        
        backgroundTapped.accept(true)
    }
        
}

// MARK: - UI Setting Method

private extension AlarmModalViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        setupModalView()
        bind()
    }
    
    func configureSelf() {
        self.view.addSubview(self.modalView)
        self.view.backgroundColor = .clear
    }
    
    func setupLayout() {
        self.modalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(530)
        }
    }
    
    /// 모달뷰를 세팅하는 메소드
    ///
    /// 현재 뷰 컨트롤러의 상태가 edit이고 데이터가 있어야만 액션 실행
    func setupModalView() {
        guard
            self.state == .edit && self.data != nil,
            let data = self.data
        else { return }
        self.modalView.enterData(data)
    }
    
    func bind() {
        bindSaveButton()
        bindKeyboardIsActive()
    }
    
    /// 데이터 바인딩 메소드
    ///
    /// 현재 뷰 컨트롤러의 state에 따라 바인딩 변경
    func bindSaveButton() {
        self.modalView.saveButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { [weak self] owner, _ in
                
                switch owner.state {
                    // 현재 뷰 컨트롤러가 create인 경우
                    // 코어 데이터에 새로운 데이터 저장
                case .create:
                    let data = owner.modalView.extractionData()
                    let alarmDTO = AlarmDTO(
                        id: UUID(),
                        isActive: true,
                        note: data.memo,
                        time: data.date,
                        weekDays: .init(
                            mon: data.week[0],
                            tue: data.week[1],
                            wed: data.week[2],
                            thu: data.week[3],
                            fri: data.week[4],
                            sat: data.week[5],
                            sun: data.week[6]
                        )
                    )
                    
                    owner.alarmDataManager.create(with: alarmDTO)
                    self?.setupAlarmNotifications(for: alarmDTO)
                    
                    // 현재 뷰 컨트롤러가 edit인 경우
                    // 코어 데이터에 데이터 업데이트
                case .edit:
                    guard let data = owner.data else { return }
                    let cellData = owner.modalView.extractionData()
                    
                    data.isActive = true
                    data.note = cellData.memo
                    data.time = cellData.date
                    data.weekDays?.mon = cellData.week[0]
                    data.weekDays?.tue = cellData.week[1]
                    data.weekDays?.wed = cellData.week[2]
                    data.weekDays?.thu = cellData.week[3]
                    data.weekDays?.fri = cellData.week[4]
                    data.weekDays?.sat = cellData.week[5]
                    data.weekDays?.sun = cellData.week[6]
                    
                    owner.alarmDataManager.update(data.objectID, updateData: data)
                    self?.removeAlarmNotifications(for: data)
                    self?.setupAlarmNotifications(for: data)
                }
                
            }.disposed(by: self.disposeBag)
        
        
    }
    
    /// 키보드의 활성화 상태를 확인해서 뷰의 위치를 변경하는 바인드 메소드
    func bindKeyboardIsActive() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .distinctUntilChanged()
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, keyboardHeight in
                
                if keyboardHeight > 0 {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                        owner.modalView.snp.removeConstraints()
                        owner.modalView.snp.makeConstraints { make in
                            make.horizontalEdges.equalToSuperview().inset(20)
                            make.height.equalTo(530)
                            make.bottom.equalToSuperview().inset(keyboardHeight + 10)
                        }
                        owner.view.layoutIfNeeded()
                    }
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                        owner.modalView.snp.removeConstraints()
                        owner.setupLayout()
                        owner.view.layoutIfNeeded()
                    }
                }
                
            }.disposed(by: self.disposeBag)
        
        
    }
    
    private func setupAlarmNotifications(for data: AlarmDTO) {
        let uuidString = data.id.uuidString
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: data.time)
        let minute = calendar.component(.minute, from: data.time)
        
        let weekDays = data.weekDays
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
                title: data.time.getTimeString(),
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
                title: data.time.getTimeString(),
                body: data.note ?? "",
                hour: .init(rawValue: hour),
                minute: .init(rawValue: minute)!
            )
        }
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
                title: data.time?.getTimeString() ?? "00:00",
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
                title: data.time?.getTimeString() ?? "00:00",
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

