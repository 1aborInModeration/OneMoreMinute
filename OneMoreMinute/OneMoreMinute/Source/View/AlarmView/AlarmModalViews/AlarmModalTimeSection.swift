//
//  AlarmTimeSection.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

final class AlarmModalTimeSection: UIView {
    
    private let title = AlarmModalSectionTitle(title: "시간 설정")
    
    private(set) var timeSet = UIDatePicker().then {
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .time
        $0.minuteInterval = 1
        $0.locale = Locale(identifier: "ko_KR")
        $0.backgroundColor = .backgroundGray
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.systemLightGray.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
}

private extension AlarmModalTimeSection {
    
    func setupUI() {
        configure()
        setupLayout()
    }
    
    func configure() {
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
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
