//
//  WeekDaysIcons.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import Then

final class WeekDaysIcons: UIView {
    
    private var weekDays: [Bool] = []
    
    private let stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.alignment = .leading
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupIcons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadIcons(data: [Bool]) {
        UIView.animate(withDuration: 0.2) {
            self.weekDays.removeAll()
            self.stack.arrangedSubviews.forEach { [weak self] subView in
                self?.stack.removeArrangedSubview(subView)
            }
        } completion: { _ in
            self.weekDays = data
            self.setupIcons()
        }

        
    }
    
    private func setupIcons() {
        guard self.weekDays.filter({ $0 == true }).count != 0 else {
            self.stack.isHidden = true
            return
        }
        
        self.weekDays.enumerated().forEach { [weak self] index, data in
            guard data == true else { return }
            let label = UILabel()
            label.text = index.weekTitle
            label.font = Fonts.title2
            label.textColor = Colors.systemColor(.r400)
            label.textAlignment = .center
            label.numberOfLines = 1
            label.layer.cornerRadius = 15
            label.backgroundColor = Colors.systemColor(.r50)
            label.clipsToBounds = true
            
            label.snp.makeConstraints { make in
                make.height.width.equalTo(30)
            }
            
            self?.stack.addArrangedSubview(label)
            self?.stack.isHidden = false
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.stack)
        
        self.stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

