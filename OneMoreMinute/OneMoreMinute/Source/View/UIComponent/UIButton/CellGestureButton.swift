//
//  CellGestureButton.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/13/25.
//

import UIKit
import SnapKit


enum gestureButtonType {
    case normal
    case delete
}

class CellGestureButton: UIButton {
    
    init(type: gestureButtonType = .normal) {
        super.init(frame: .zero)
        
        setupUIProperties(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellGestureButton {
    func setupUIProperties(type: gestureButtonType) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        
        switch type {
        case .delete:
            self.setTitle("삭제", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .buttonRed
            self.layer.cornerRadius = Layouts.radiusSmall
        default:
            self.setTitle("확인", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .wrapperBackground
            self.layer.cornerRadius = Layouts.radiusSmall
        }
    }
}
