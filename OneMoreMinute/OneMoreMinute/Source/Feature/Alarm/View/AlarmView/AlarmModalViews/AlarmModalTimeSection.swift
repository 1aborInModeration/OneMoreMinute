//
//  AlarmTimeSection.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

/// 모달뷰의 시간을 설정하는 섹션 뷰
final class AlarmModalTimeSection: UIView {
    
    private let title = BodyLabel().then {
        $0.text = "시간 설정"
        $0.textColor = .fontGray
    }
    
    private(set) var timeSet = CustomDatePicker()
    
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
            self.timeSet.layer.borderColor = UIColor.textFieldStroke.cgColor
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !self.timeSet.frame.contains(point) else {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}

// MARK: - UI Setting Method

private extension AlarmModalTimeSection {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        self.backgroundColor = .clear
        [self.title,
         self.timeSet].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.timeSet.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(Layouts.itemSpacing1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
