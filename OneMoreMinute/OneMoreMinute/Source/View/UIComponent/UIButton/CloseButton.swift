//
//  CloseButton.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import SnapKit

class CloseButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CloseButton {
    func setupUIProperties() {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(systemName: "xmark")
        config.baseForegroundColor = .grayButtonLabel
        
        config.contentInsets = NSDirectionalEdgeInsets(top: Layouts.itemSpacing1, leading: Layouts.itemSpacing1, bottom: Layouts.itemSpacing1, trailing: Layouts.itemSpacing1)
        
        self.configurationUpdateHandler = { _ in
            switch self.state {
            case .normal:
                config.baseForegroundColor = .grayButtonLabel
            case .highlighted:
                config.baseForegroundColor = .fontGray
            default:
                config.baseBackgroundColor = .grayButtonLabel
            }
        }
        
        self.configuration = config

    }

    func setupLayouts() {
        self.snp.makeConstraints { make in
            make.size.equalTo(Layouts.buttonHeightSmall)
        }
    }
}
