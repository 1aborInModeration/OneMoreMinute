//
//  BodyLabel.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit
import SnapKit


class BodyLabel: UILabel {
    // MARK: - Life Cycles
    
    /// 기본 텍스트 라벨
    ///
    /// 본문을 담당하는 라벨
    /// 기본적으로 왼쪽 정렬이며, 배경색은 없습니다.
    /// 기본 폰트 색상은 Label 색상입니다.
    /// 사이즈는 단일로 기본 14 / 줄간격은 150%입니다.
    ///
    /// ``setLineSpacing`` 메소드를 사용하여 줄간격을 조절할 수 있습니다.
    /// ``setSystemColor`` 메소드를 사용하여 원하는 시스템 컬러로 색상 변경할 수 있습니다.
    /// ``setTextColor`` 메소드를 사용하여 기본 폰트 색상 중 선택하여 변경할 수 있습니다.
    ///
    /// - Parameters:
    ///   - isBold: 볼드 여부. 기본 레귤러.
    init(isBold: Bool = false) {
        super.init(frame: .zero)
        
        setupUIProperties(isBold: isBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BodyLabel {
    func setupUIProperties(isBold: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.textColor = .fontLabel
        self.textAlignment = .left
        self.numberOfLines = 0
        self.font = isBold ? Fonts.body : Fonts.bold
        self.setLineSpacing(lineSpacing: font.pointSize * 1.5)
    }
}
