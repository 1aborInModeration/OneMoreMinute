//
//  AlarmModalView.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

final class AlarmModalView: UIView {
    
    private let title = UILabel().then {
        $0.text = "새 알람 추가"
        $0.font = Fonts.title1Bold
        $0.numberOfLines = 1
        $0.textColor = .label
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private(set) var closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = Colors.systemLightGray
        $0.backgroundColor = .clear
    }
    
    private(set) var cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(Colors.systemGray(.r800), for: .normal)
        $0.titleLabel?.font = Fonts.title2
        $0.backgroundColor = Colors.systemGray(.r100)
        $0.layer.cornerRadius = 12
    }
    
    private(set) var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = Fonts.title2Bold
        $0.backgroundColor = Colors.systemColor(.r400)
        $0.layer.cornerRadius = 12
    }
    
    private lazy var buttonStack = UIStackView().then { [weak self] stack in
        guard let self else { return }
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.backgroundColor = .clear
        stack.spacing = 10
        [self.cancleButton,
         self.saveButton
        ].forEach { view in
            stack.addArrangedSubview(view)
        }
    }
    
    private let timeSection = AlarmModalTimeSection()
    
    private let weekSection = AlarmModalWeekSection()
    
    private let memoSection = AlarmModalMemoSection()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func extractionData() -> (date: Date, memo: String?, week: [Bool]) {
        let date = self.timeSection.timeSet.date
        let memo = self.memoSection.memoSet.text
        let week = self.weekSection.isSelecteds.value
        return (date, memo, week)
    }
}

private extension AlarmModalView {
    
    func setupUI() {
        configure()
        setupLayout()
    }
    
    func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.systemLightGray.cgColor
        [self.title,
         self.closeButton,
         self.timeSection,
         self.weekSection,
         self.memoSection,
         self.buttonStack].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(25)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.title)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
        
        self.timeSection.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        self.weekSection.snp.makeConstraints { make in
            make.top.equalTo(self.timeSection.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }
        
        self.memoSection.snp.makeConstraints { make in
            make.top.equalTo(self.weekSection.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        self.buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
}
