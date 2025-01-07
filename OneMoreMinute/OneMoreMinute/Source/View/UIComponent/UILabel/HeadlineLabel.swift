//
//  HeadlineLabel.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit
import SnapKit

class HeadlineLabel: UILabel {
    // MARK: - Life Cycles
    
    /// 헤드라인 라벨
    ///
    /// 섹션 제목 레벨의 타이틀을 담당하는 라벨
    /// 기본적으로 왼쪽 정렬이며, 배경색은 없습니다.
    /// 기본 폰트 색상은 Label 색상입니다.
    /// 줄간격은 130% 입니다.
    ///
    /// ``setLineSpacing`` 메소드를 사용하여 줄간격을 조절할 수 있습니다.
    /// ``setSystemColor`` 메소드를 사용하여 원하는 시스템 컬러로 색상 변경할 수 있습니다.
    /// ``setTextColor`` 메소드를 사용하여 기본 폰트 색상 중 선택하여 변경할 수 있습니다.
    ///
    /// - Parameters:
    ///   - size: 사이즈는 두 가지(32, 28)가 있습니다. 기본은 작은 28 사이즈.
    ///   - isBold: 볼드 여부. 기본 볼드.
    init(size: HeadlineSize = .headline2, isBold: Bool = true) {
        super.init(frame: .zero)
        
        setupUIProperties(size: size, isBold: isBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeadlineLabel {
    func setupUIProperties(size: HeadlineSize, isBold: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.textColor = .fontLabel
        self.textAlignment = .left
        self.numberOfLines = 0
        
        switch size {
        case .headline1:
            self.font = isBold ? Fonts.headline1Bold : Fonts.headline1
        default :
            self.font = isBold ? Fonts.headline2Bold : Fonts.headline2
        }
        
        self.setLineSpacing(lineSpacing: font.pointSize * 1.3)
    }
}
