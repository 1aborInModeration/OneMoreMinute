//
//  UIView+Extensions.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit

extension UIView {
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
