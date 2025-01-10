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
    
    init(state: AlarmModalState) {
        self.state = state
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
        bind()
    }
    
    func configure() {
        self.view.addSubview(self.modalView)
        self.view.backgroundColor = .black.withAlphaComponent(0.25)
    }
    
    func setupLayout() {
        self.modalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(530)
        }
    }
    
    func bind() {        
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
    }
    
}

