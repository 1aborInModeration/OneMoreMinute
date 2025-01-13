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
    
    private let repositoryManager = AlarmDataManager.shared
    
    private(set) var state: AlarmModalState
    private var data: Alarm?
    
    private(set) lazy var modalView = AlarmModalView(state: self.state)
    
    // MARK: - AlarmModalViewController Initializer
    
    init(state: AlarmModalState, data: Alarm?) {
        self.state = state
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AlarmModalViewController LifeCycle
    
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

// MARK: - AlarmModalViewController UI Setting Method

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
    
    /// 데이터 바인딩 메소드
    ///
    /// 현재 뷰 컨트롤러의 state에 따라 바인딩 변경
    func bind() {
        self.modalView.saveButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                switch owner.state {
                // 현재 뷰 컨트롤러가 create인 경우
                // 코어 데이터에 새로운 데이터 저장
                case .create:
                    let data = owner.modalView.extractionData()
                    
                    owner.repositoryManager.create(with: .init(
                        isActive: true,
                        note: data.memo,
                        time: data.date,
                        weekDays: .init(mon: data.week[0],
                                        tue: data.week[1],
                                        wed: data.week[2],
                                        thu: data.week[3],
                                        fri: data.week[4],
                                        sat: data.week[5],
                                        sun: data.week[6]
                                       )
                        )
                    )
                    
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
                    
                    owner.repositoryManager.update(data.objectID, updateData: data)
                }
                
            }.disposed(by: self.disposeBag)
        
        
    }
    
}

