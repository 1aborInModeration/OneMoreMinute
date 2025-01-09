//
//  AlarmModalSectionTitle.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit

final class AlarmModalSectionTitle: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupLabel(title: title)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(title: String) {
        self.text = title
        self.font = Fonts.body
        self.numberOfLines = 1
        self.textColor = Colors.systemLightGray
        self.backgroundColor = .clear
        self.textAlignment = .left
    }
}
