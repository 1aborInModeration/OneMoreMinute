//
//  AlarmModalMemoSection.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

/// 모달뷰 메모 섹션 뷰
final class AlarmModalMemoSection: UIView {
    
    private let title = AlarmModalSectionTitle(title: "메모")
    
    private(set) var memoSet = UITextField().then {
        $0.placeholder = "알람 메모를 입력하세요"
        $0.textColor = UIColor.textFieldFont
        $0.font = Fonts.title2
        $0.borderStyle = .none
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        $0.leftViewMode = .always
        $0.backgroundColor = UIColor.textFieldBackground
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.textFieldStroke.cgColor
        $0.keyboardType = .default
    }
    
    // MARK: - AlarmModalMemoSection Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.memoSet.layer.borderColor = UIColor.wrapperStroke.cgColor
        }
    }
    
}

// MARK: - AlarmModalMemoSection UI Setting Method

private extension AlarmModalMemoSection {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        self.backgroundColor = .clear
        [self.title,
         self.memoSet].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(15)
        }
        
        self.memoSet.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
}
