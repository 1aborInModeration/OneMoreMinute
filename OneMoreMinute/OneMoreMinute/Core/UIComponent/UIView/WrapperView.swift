//
//  DynamicBorderView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/14/25.
//

import UIKit

class WrapperView: UIView {

    init() {
        super.init(frame: .zero)
        
        self.layer.borderColor = UIColor.wrapperStroke.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Dynamic Border 추가
    ///
    /// - 현재 View에 테마에 따라 변경되는 Border color 적용 코드
    /// - Parameter previousTraitCollection: ``UITraitCollection`` 타입. 시스템에서 자동으로 이루어집니다.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.layer.borderColor = UIColor.wrapperStroke.cgColor
        }
    }
}
