//
//  customSearchBar.swift
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
}

extension CustomSearchBar {
    func setupUIProperties() {
        self.searchBarStyle = .minimal

        self.searchTextField.backgroundColor = .textFieldBackground
        self.searchTextField.layer.cornerRadius = Layouts.radiusSmall
        self.searchTextField.layer.borderWidth = 1
        self.searchTextField.layer.borderColor = UIColor.wrapperStroke.cgColor
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
