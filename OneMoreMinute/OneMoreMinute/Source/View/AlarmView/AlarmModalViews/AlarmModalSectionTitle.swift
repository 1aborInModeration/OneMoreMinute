//
//  AlarmModalSectionTitle.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit

/// 모달뷰의 섹션 타이블의 커스텀 레이블 뷰
final class AlarmModalSectionTitle: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupLabel(title: title)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 레이블을 세팅하는 메소드
    /// - Parameter title: 레이블 텍스트
    private func setupLabel(title: String) {
        self.text = title
        self.font = Fonts.body
        self.numberOfLines = 1
        self.textColor = UIColor.fontGray
        self.backgroundColor = .clear
        self.textAlignment = .left
    }
}
