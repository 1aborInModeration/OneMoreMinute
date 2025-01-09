//
//  ShowModalButton.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit

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

private extension ShowModalButton {
    
    func setupUI() {
        self.layer.cornerRadius = 25
        self.backgroundColor = Colors.systemColor(.r400)
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = UIColor.white
        self.layer.shadowColor = Colors.systemDarkGray.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowRadius = 10
    }
    
}
