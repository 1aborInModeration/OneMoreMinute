//
//  SampleAlertView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit
import SnapKit


/// 단순 알림창 팝업을 위한 뷰
class AlertView: UIView, ModalLifecycleNotifiable, ModalCloseable {
    // MARK: - UIComponents & Properties
    
    let titleLabel = TitleLabel(isBold: true)
    let messageLabel = BodyLabel()
    let confirmButton = CustomFilledButton()
    
    let title: String
    let message: String
    let completion: () -> Void
    
    weak var delegate: ModalCloseDelegate?
    
    
    // MARK: - Life Cycles
    
    /// 커스텀 팝업경고창
    ///
    /// 뷰에 들어갈 텍스트와 버튼 클릭시 작동하는 클로저를 인자로 받습니다.
    /// 버튼 클릭시 기본적으로 모달뷰 자체를 dismiss 하도록 되어 있습니다.
    ///
    /// - Parameters:
    ///   - title: 알림창의 상단 제목
    ///   - message: 알림창의 세부 메시지
    ///   - completion: 알림창의 버튼 클릭 후 작동하는 클로져
    init(title: String, message: String, completion: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.completion = completion
        super.init(frame: .zero)
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - UI Layouts

extension AlertView {
    func setupSubViews() {
        [
            titleLabel,
            messageLabel,
            confirmButton
        ].forEach { addSubview($0) }
    }
    
    func setupUIProperties() {
        self.backgroundColor = .wrapperBackground
        self.layer.cornerRadius = Layouts.radius
        
        titleLabel.text = title
        messageLabel.text = message
        confirmButton.applyButtonAction(action: closeModal)
    }
    
    func setupLayouts() {
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Layouts.paddingLarge)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layouts.itemSpacing3)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(Layouts.itemSpacing7)
            $0.bottom.equalToSuperview().inset(Layouts.padding)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
    }
}


// MARK: - UI Layouts

extension AlertView {
    func onModalWillAppear() {
        // 모달이 나타날 때 동작 추가
    }
    
    func onModalWillDisappear() {
        // 모달이 사라질 때 동작 추가
    }
    
    func closeModal() {
        delegate?.closeModal()
        completion()
    }
}
