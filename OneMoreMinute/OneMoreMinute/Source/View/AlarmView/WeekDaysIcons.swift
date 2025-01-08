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
    
    private var weekDays: WeekDaysDTO
    private let stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.alignment = .leading
        $0.backgroundColor = .clear
    }
    
    init(weekDays: WeekDaysDTO) {
        self.weekDays = weekDays
        super.init(frame: .zero)
        
        setupIcons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIcons() {
        self.weekDays.someProperties().enumerated().forEach { [weak self] index, data in
            guard data == true else { return }
            let label = UILabel()
            label.text = self?.iconTitle(index)
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
    
    private func iconTitle(_ index: Int) -> String {
        switch index {
        case 0:
            return "월"
        case 1:
            return "화"
        case 2:
            return "수"
        case 3:
            return "목"
        case 4:
            return "금"
        case 5:
            return "토"
        case 6:
            return "일"
        default:
            return ""
        }
    }
}

// Preview
@available(iOS 17.0, *)
#Preview {
    WeekDaysIcons(weekDays: .init(mon: false, tue: true, wed: true, thu: false, fri: true, sat: false, sun: true))
}
