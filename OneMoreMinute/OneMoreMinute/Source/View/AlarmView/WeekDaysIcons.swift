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
    
    private var weekDays: [String] = []
    private let stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.alignment = .leading
        $0.backgroundColor = .clear
    }
    
    init(weekDays: [String]) {
        self.weekDays = weekDays
        super.init(frame: .zero)
        
        setupIcons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIcons() {
        self.weekDays.forEach { [weak self] in
            let label = UILabel()
            label.text = $0
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
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.stack)
        
        self.stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// Preview
@available(iOS 17.0, *)
#Preview {
    WeekDaysIcons(weekDays: ["월", "화", "수", "목", "금"])
}
