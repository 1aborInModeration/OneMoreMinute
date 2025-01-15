//
//  CustomSearchBar.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import SnapKit

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 텍스트 필드에 Dynamic Border 추가
    ///
    /// - 현재 테마에 따라 변경되는 텍스트필드에 Border 색상 적용
    /// - Parameter previousTraitCollection: ``UITraitCollection`` 타입. 시스템에서 자동으로 이루어집니다.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.searchTextField.layer.borderColor = UIColor.textFieldStroke.cgColor
        }
    }
}

extension CustomSearchBar {
    
    func setupUIProperties() {
        self.searchBarStyle = .minimal
        
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.searchTextField.backgroundColor = .textFieldBackground
        self.searchTextField.layer.borderColor = UIColor.textFieldStroke.cgColor
        self.searchTextField.layer.cornerRadius = Layouts.radiusSmall
        self.searchTextField.layer.borderWidth = Layouts.borderWidthThin
        self.searchTextField.font = Fonts.body
        self.searchTextField.textColor = .textFieldFont
        self.searchTextField.clearButtonMode = .whileEditing
        self.searchTextField.returnKeyType = .done
        self.searchTextField.enablesReturnKeyAutomatically = true
    }

    func setupLayouts() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Layouts.buttonHeight)
        }
    }
}
