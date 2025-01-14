//
//  AlarmCollectionViewCell.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

/// 알람뷰의 커스텀 셀
final class AlarmCollectionViewCell: UICollectionViewCell {
    
    // MARK: - AlarmCollectionViewCell Rx Properties
    
    private(set) var disposeBag = DisposeBag()
    private let weekdaysStatus = PublishRelay<[Bool]>()
    private(set) var data: Alarm?
    
    static let id: String = "AlarmCollectionViewCell"
        
    // MARK: - AlarmCollectionViewCell UI
    
    private let timeLabel = UILabel().then {
        $0.font = Fonts.headline2
        $0.textColor = UIColor.label
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private let weekDaysIcons = WeekDaysIcons()
    
    private let note = UITextField().then {
        $0.textColor = UIColor.textFieldFont
        $0.borderStyle = .none
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor.textFieldBackground
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        $0.rightViewMode = .always
        $0.isUserInteractionEnabled = false
    }
    
    private(set) var alarmButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.setImage(UIImage(systemName: "bell"), for: .normal)
        $0.tintColor = UIColor.mainTitle
        $0.backgroundColor = UIColor.buttonBackground
    }
    
    private(set) var deleteButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = UIColor.iconRed
        $0.backgroundColor = .clear
    }
    
    // MARK: - AlarmCollectionViewCell Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    // 셀 재사용 옵션
    override func prepareForReuse() {
        super.prepareForReuse()
    
        self.disposeBag = DisposeBag()
        prepareForReuseData()
        bind()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.layer.borderColor = UIColor.wrapperStroke.cgColor
        }
    }
    
    /// 셀을 설정하는 메소드
    /// - Parameter data: 셀 설정에 사용할 데이터
    func configCell(_ data: Alarm) {
        guard let weekDays = data.weekDays else { return }
        let weekdaysStatus = [weekDays.mon,
                              weekDays.tue,
                              weekDays.wed,
                              weekDays.thu,
                              weekDays.fri,
                              weekDays.sat,
                              weekDays.sun]
        
        self.weekdaysStatus.accept(weekdaysStatus)
        
        let time = convertDtTxtFormat(data.time ?? Date())
        self.timeLabel.text = time
        self.changeButtonColor(data.isActive)
        self.note.text = data.note ?? ""
        self.data = data
        
        self.layoutIfNeeded()
    }
}

// MARK: - AlarmCollectionViewCell UI Setting Method

private extension AlarmCollectionViewCell {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        bind()
    }
    
    func prepareForReuseData() {
        self.weekdaysStatus.accept([])
        self.timeLabel.text = ""
        self.note.text = ""
    }
    
    func configureSelf() {
        self.backgroundColor = UIColor.wrapperBackground
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowPath = .init(rect: self.bounds, transform: nil)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.wrapperStroke.cgColor
        [self.timeLabel,
         self.note,
         self.weekDaysIcons,
         self.alarmButton,
         self.deleteButton
        ].forEach { self.contentView.addSubview($0) }
    }
    
    func setupLayout() {
        
        self.timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        self.note.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.timeLabel.snp.leading)
            make.height.equalTo(40)
            make.width.equalTo(240)
        }
        
        self.weekDaysIcons.snp.makeConstraints { make in
            make.top.equalTo(self.note.snp.bottom).offset(10)
            make.leading.equalTo(self.timeLabel)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        self.alarmButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.note)
            make.leading.equalTo(self.note.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
        
        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.alarmButton)
            make.leading.equalTo(self.alarmButton.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
    }
    
    /// 데이터 바인딩 메소드
    func bind() {
        // 반복 요일 설정 바인딩
        self.weekdaysStatus
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, data in
                
                owner.weekDaysIcons.reloadIcons(data: data)
                
            }.disposed(by: self.disposeBag)
    }
    
    /// 시간을 나타내는 레이블 값의 포맷을 변경하는 메소드
    /// - Parameter dtTxt: 서버에서 받아온 날짜 데이터
    /// - Returns: 포맷이 변경된 텍스트
    func convertDtTxtFormat(_ date: Date) -> String {
        let myDateFormat = DateFormatter()
        myDateFormat.dateFormat = "a hh:mm"
        myDateFormat.locale = Locale(identifier: "ko_KR")
        let dtTxt = myDateFormat.string(from: date)

        return dtTxt
    }
    
    /// 알람 설정 상태에 따라 버튼의 색상을 변경하는 메소드
    func changeButtonColor(_ isSelected: Bool) {
        switch isSelected {
        case true:
            self.alarmButton.backgroundColor = UIColor.buttonBackground
            self.alarmButton.tintColor = UIColor.mainTitle
            self.alarmButton.isSelected = true
        case false:
            self.alarmButton.backgroundColor = UIColor.grayButtonBackground
            self.alarmButton.tintColor = UIColor.grayButtonLabel
            self.alarmButton.isSelected = false
        }
    }
}

