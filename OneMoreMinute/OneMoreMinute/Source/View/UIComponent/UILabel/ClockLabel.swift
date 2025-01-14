//
//  ClockLabel.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/13/25.
//

import UIKit

enum ClockLabelType {
    case header
    case timer
    case newAlarm
    case worldCard
    case alarmCard
    case alert
}

class ClockLabel: UILabel {
    
    // MARK: - Life Cycles
    
    /// 타이틀 라벨
    ///
    /// 가장 낮은 단계의 소제목 레벨의 타이틀을 담당하는 라벨
    /// 기본적으로 왼쪽 정렬이며, 배경색은 없습니다.
    /// 기본 폰트 색상은 Label 색상입니다.
    /// 줄간격은 140% 입니다.
    ///
    /// ``setLineSpacing`` 메소드를 사용하여 줄간격을 조절할 수 있습니다.
    /// ``setSystemColor`` 메소드를 사용하여 원하는 시스템 컬러로 색상 변경할 수 있습니다.
    /// ``setTextColor`` 메소드를 사용하여 기본 폰트 색상 중 선택하여 변경할 수 있습니다.
    ///
    /// - Parameters:
    ///   - size: 사이즈는 5가지가 있습니다. ``ClockLabelSize`` 참고
    init(type: ClockLabelType) {
        super.init(frame: .zero)
        
        setupUIProperties(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

extension ClockLabel {
    
    func setupUIProperties(type: ClockLabelType) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.textColor = .fontLabel
        self.numberOfLines = 0
        
        switch type {
        case .header:
            self.font = Fonts.headerClock
            self.textColor = .mainTitle
            self.textAlignment = .center
        case .timer:
            self.font = Fonts.timerClock
            self.textColor = .mainTitle
            self.textAlignment = .center
        case .newAlarm:
            self.font = Fonts.newAlarmClock
            self.textColor = .fontLabel
            self.textAlignment = .center
        case .worldCard:
            self.font = Fonts.cardClock
            self.textColor = .mainTitle
            self.textAlignment = .right
        case .alarmCard:
            self.font = Fonts.cardClock
            self.textColor = .fontLabel
            self.textAlignment = .left
        case .alert:
            self.font = Fonts.alertClock
            self.textColor = .subTitle
            self.textAlignment = .center
        }
    }
}
