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
    
    private let title = BodyLabel().then {
        $0.text = "메모"
        $0.textColor = .fontGray
    }
    
    private(set) var memoSet = CustomTextField(placeholder: "알람 메모를 입력하세요")
    
    // MARK: - Initializer
    
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
            self.memoSet.layer.borderColor = UIColor.textFieldStroke.cgColor
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !self.memoSet.frame.contains(point) else {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}

// MARK: - UI Setting Method

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
        }
        
        self.memoSet.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(Layouts.itemSpacing1)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(70)
        }
    }
    
}
