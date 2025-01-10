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

enum AlarmModalState {
    case crate
    case edit
}

final class AlarmModalViewController: UIViewController {
    
    private(set) var modalView = AlarmModalView()
    
    private var state: AlarmModalState
    
    private let disposeBag = DisposeBag()
    
    private let repository = AlarmDataManager.shared
    
    private var data: Alarm?
    
    init(state: AlarmModalState, data: Alarm?) {
        self.state = state
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

private extension AlarmModalViewController {
    
    func setupUI() {
        configure()
        setupLayout()
        setupModalView()
        bind()
    }
    
    func configure() {
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
    
    func setupModalView() {
        guard
            self.state == .edit && self.data != nil,
            let data = self.data
        else { return }
        self.modalView.enterData(data)
    }
    
    func bind() {
        switch self.state {
        case .crate:
            self.modalView.saveButton.rx.tap
                .asSignal(onErrorSignalWith: .empty())
                .withUnretained(self)
                .emit { owner, _ in
                    
                    let data = owner.modalView.extractionData()
                    
                    owner.repository.create(with: .init(
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
                                    
                }.disposed(by: self.disposeBag)
            
        case .edit:
            self.modalView.saveButton.rx.tap
                .asSignal(onErrorSignalWith: .empty())
                .withUnretained(self)
                .emit { owner, _ in
                    
                    guard var data = owner.data else { return }
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
                    
                    owner.repository.update(data.objectID, updateData: data)
                    
                }.disposed(by: self.disposeBag)
        }
        
    }
    
}

