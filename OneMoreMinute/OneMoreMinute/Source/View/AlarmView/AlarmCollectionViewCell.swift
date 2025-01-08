//
//  AlarmCollectionViewCell.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import Then

final class AlarmCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "AlarmViewController"
    
    private let timeLabel = UILabel().then {
        $0.text = "07:30"
        $0.font = Fonts.headline2
        $0.textColor = UIColor.black
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let weekDaysIcons = WeekDaysIcons(weekDays: ["월", "화", "수", "목", "금", "토", "일"])
    
    private let note = UITextField().then {
        $0.text = "아침 운동하기"
        $0.textColor = Colors.systemGray(.r500)
        $0.borderStyle = .none
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Colors.systemGray(.r50)
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        $0.leftViewMode = .always
    }
    
    private let editButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.tintColor = Colors.systemGray(.r500)
    }
    
    private let alarmButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.setImage(UIImage(systemName: "bell"), for: .normal)
        $0.tintColor = Colors.systemColor(.r400)
        $0.backgroundColor = Colors.systemColor(.r50)
    }
    
    private let deleteButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = UIColor(red: 248/256, green: 113/256, blue: 113/256, alpha: 1.0)
        $0.backgroundColor = .clear
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

private extension AlarmCollectionViewCell {
    
    func setupUI() {
        configure()
        setupLayout()
    }
    
    func configure() {
        self.backgroundColor = Colors.appBackground
        self.layer.cornerRadius = 12
        self.layer.shadowColor = Colors.systemDarkGray.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowRadius = 15
        [self.timeLabel,
         self.weekDaysIcons,
         self.editButton,
         self.note,
         self.alarmButton,
         self.deleteButton
        ].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        
        self.timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        self.weekDaysIcons.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.timeLabel)
        }
        
        self.editButton.snp.makeConstraints { make in
            make.top.equalTo(self.weekDaysIcons.snp.bottom).offset(10)
            make.leading.equalTo(self.weekDaysIcons)
            make.width.height.equalTo(30)
        }
        
        self.note.snp.makeConstraints { make in
            make.centerY.equalTo(self.editButton)
            make.leading.equalTo(self.editButton.snp.trailing).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        self.alarmButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.weekDaysIcons)
            make.leading.equalTo(self.note.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
        
        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.alarmButton)
            make.leading.equalTo(self.alarmButton.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
    }
}

// Preview
@available(iOS 17.0, *)
#Preview {
    AlarmCollectionViewCell()
}
