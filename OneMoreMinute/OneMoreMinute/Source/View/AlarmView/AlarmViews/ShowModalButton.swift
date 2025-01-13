//
//  ShowModalButton.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit

/// 모달을 여는 커스텀 버튼
final class ShowModalButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

// MARK: - ShowModalButton UI Setting Method

private extension ShowModalButton {
    
    func setupUI() {
        self.layer.cornerRadius = 25
        self.backgroundColor = UIColor.plusButtonBackground
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = UIColor.white
        self.layer.shadowColor = Colors.systemDarkGray.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowPath = .init(rect: self.bounds, transform: nil)
    }
    
}
