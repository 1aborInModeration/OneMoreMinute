//
//  UILabel+Extensions.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit


extension UILabel {
    /// 라벨의 텍스트 색상을 기본 폰트 색상중 하나로 선택하여 변경하는 메소드
    /// - Parameter color: 지정된 기본 폰트 컬러 중 선택
    func setTextColor(_ color: FontColor) {
        self.textColor = UIColor(named: color.rawValue)
    }
    
    /// 라벨의 텍스트 색상을 시스템 컬러로 선택하여 변경하는 메소드. 램프 선택
    /// - Parameter ramp: 시스템 컬러의 램프 중 선택.
    func setSystemColor(_ ramp: SystemColorRamps) {
        self.textColor = Colors.systemColor(ramp)
    }
}

// MARK: - UILabel Utilities

extension UILabel {
    /// UILabel 에 줄간격을 쉽게 적용시켜 사용하기 위한 메소드
    /// 기본값을 설정하였으므로 아래 둘 중 하나를 선택하여 사용.
    /// - Parameters:
    ///   - lineSpacing: 각 줄 사이의 간격을 의미합니다.
    ///   - paragraphSpacing: 문단 간격을 설정합니다.
    func setLineSpacing(lineSpacing: CGFloat = 0.0, paragraphSpacing:CGFloat = 0.0) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        let attributedString:NSMutableAttributedString
        
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
        
        /*
         위 메소드는 다음과 같은 형식으로 사용합니다.
         let label = UILabel()
         
         label.setLineSpacing(lineSpacing: 10.0)
         label.setLineSpacing(paragraphSpacing: 10.0)
         label.setLineSpacing(lineSpacing: 10.0, paragraphSpacing: 10.0)
         */
    }
}
