//
//  AlarmModalView.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

/// 알람 탭의 모달 뷰
final class AlarmModalView: UIView {
    
    // MARK: - UI Components
    
    private let title = TitleLabel(size: .title1).then {
        $0.text = "새 알람 추가"
        $0.textColor = .fontLabel
    }
    
    private(set) var closeButton = CloseButton()
    private(set) var cancelButton = CustomFilledButton(color: .grayButton ,title: "취소", cornerRound: .rounded, isGray: true)
    private(set) var saveButton = CustomFilledButton(color: .plusButton ,title: "저장", cornerRound: .rounded)
    
    private lazy var buttonStack = UIStackView().then { stack in
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.backgroundColor = .clear
        stack.spacing = 10
        [self.cancelButton,
         self.saveButton
        ].forEach { view in
            stack.addArrangedSubview(view)
        }
    }
    
    private let timeSection = AlarmModalTimeSection()
    private let weekSection = AlarmModalWeekSection()
    private let memoSection = AlarmModalMemoSection()
        
    // MARK: - Initializer
    
    init(state: AlarmModalState) {
        super.init(frame: .zero)
        
        self.title.text = state == .create ? "새 알람 추가" : "알람 수정"
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.layer.borderColor = UIColor.wrapperStroke.cgColor
        }
    }
    
    // MARK: - Methods
    
    /// 모달뷰의 데이터를 추출하는 메소드
    /// - Returns: 설정된 시간, 메모, 반복 요일에 대한 데이터
    func extractionData() -> (date: Date, memo: String?, week: [Bool]) {
        let date = self.timeSection.timeSet.date
        let memo = self.memoSection.memoSet.text
        let week = self.weekSection.cellSelectedStates.value
        return (date, memo, week)
    }
    
    /// 모달뷰에 데이터를 입력하는 메소드
    /// - Parameter data: 모달뷰에 입력할 데이터
    func enterData(_ data: Alarm) {
        self.timeSection.timeSet.date = data.time ?? Date()
        self.memoSection.memoSet.text = data.note
        
        guard let weekDays = data.weekDays else { return }
        let weekData: [Bool] = [weekDays.mon,
                                weekDays.tue,
                                weekDays.wed,
                                weekDays.thu,
                                weekDays.fri,
                                weekDays.sat,
                                weekDays.sun
        ]
        
        self.weekSection.cellSelectedStates.accept(weekData)
    }
}

// MARK: - UI Setting Method

private extension AlarmModalView {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        self.backgroundColor = UIColor.wrapperBackground
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.wrapperStroke.cgColor
        [self.title,
         self.closeButton,
         self.timeSection,
         self.weekSection,
         self.memoSection,
         self.buttonStack].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing4)
            make.leading.equalToSuperview().inset(Layouts.paddingSmall)
            make.height.equalTo(Layouts.buttonHeightSmall)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing4)
            make.trailing.equalToSuperview().inset(Layouts.paddingSmall)
            make.height.equalTo(title.snp.height)
        }
        
        self.timeSection.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(Layouts.itemSpacing4)
            make.horizontalEdges.equalToSuperview().inset(Layouts.paddingSmall)
            make.height.equalTo(100)
        }
        
        self.weekSection.snp.makeConstraints { make in
            make.top.equalTo(self.timeSection.snp.bottom).offset(Layouts.itemSpacing4)
            make.horizontalEdges.equalToSuperview().inset(Layouts.paddingSmall)
            make.height.equalTo(130)
        }
        
        self.memoSection.snp.makeConstraints { make in
            make.top.equalTo(self.weekSection.snp.bottom).offset(Layouts.itemSpacing4)
            make.horizontalEdges.equalToSuperview().inset(Layouts.paddingSmall)
            make.height.equalTo(90)
        }
        
        self.buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Layouts.paddingSmall)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing4)
            make.height.equalTo(50)
        }
    }
    
}
