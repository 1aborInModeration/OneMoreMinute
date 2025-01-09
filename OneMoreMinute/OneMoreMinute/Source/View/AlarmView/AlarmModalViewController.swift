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
    
    private let modalView = AlarmModalView()
        
    private var state: AlarmModalState
    
    private let disposeBag = DisposeBag()
    
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
        self.modalView.closeButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                self.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
        
        self.modalView.cancleButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                self.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
    }
    
}


//@available(iOS 17.0, *)
//#Preview {
//    AlarmModalViewController(state: .crate)
//}
