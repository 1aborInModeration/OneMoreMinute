//
//  AlarmModalMemoSection.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

final class AlarmModalMemoSection: UIView {
    
    private let title = AlarmModalSectionTitle(title: "메모")
    
    private(set) var memoSet = UITextField().then {
        $0.placeholder = "알람 메모를 입력하세요"
        $0.textColor = Colors.systemLightGray
        $0.font = Fonts.title2
        $0.borderStyle = .none
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        $0.leftViewMode = .always
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

private extension AlarmModalMemoSection {
    
    func setupUI() {
        configure()
        setupLayout()
    }
    
    func configure() {
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
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
}
