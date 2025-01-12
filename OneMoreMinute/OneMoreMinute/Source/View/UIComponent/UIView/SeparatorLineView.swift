//
//  SeparatorLineView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import SnapKit

class SeparatorLineView: UIView {
    init(height: CGFloat = 1.0) {
        super.init(frame: .zero)
        
        setupUIProperties()
        setupLayouts(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SeparatorLineView {
    func setupUIProperties() {
        self.backgroundColor = UIColor.wrapperStroke
    }

    func setupLayouts(height: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
