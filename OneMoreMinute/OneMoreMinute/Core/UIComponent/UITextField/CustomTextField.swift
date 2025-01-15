//
//  CustomTextField.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/15/25.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String = "여기에 입력하세요") {
        super.init(frame: .zero)
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextField {
    
    func setupProperties() {
        self.placeholder = "알람 메모를 입력하세요"
        self.textColor = UIColor.textFieldFont
        self.font = Fonts.body
        self.borderStyle = .none
        self.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        self.leftViewMode = .always
        self.backgroundColor = UIColor.textFieldBackground
        self.layer.cornerRadius = Layouts.radiusSmall
        self.layer.borderWidth = Layouts.borderWidthThin
        self.layer.borderColor = UIColor.textFieldStroke.cgColor
        self.keyboardType = .default
        self.autocapitalizationType = .none
    }
}
