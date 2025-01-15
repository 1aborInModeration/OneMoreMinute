//
//  CustomDatePicker.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/15/25.
//

import UIKit

class CustomDatePicker: UIDatePicker {
        
    init() {
        super.init(frame: .zero)
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDatePicker {
    
    func setupProperties() {
        self.preferredDatePickerStyle = .wheels
        self.datePickerMode = .time
        self.minuteInterval = 1
        self.locale = Locale(identifier: "ko_KR")
        self.backgroundColor = UIColor.textFieldBackground
        self.layer.cornerRadius = Layouts.radiusSmall
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textFieldStroke.cgColor
        self.clipsToBounds = true
    }
}
