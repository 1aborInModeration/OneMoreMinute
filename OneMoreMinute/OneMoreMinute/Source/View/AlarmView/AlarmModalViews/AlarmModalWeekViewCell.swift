//
//  AlarmModalCollectionViewCell.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

final class AlarmModalWeekViewCell: UICollectionViewCell {
    
    static let id: String = "AlarmModalWeekViewCell"
    
    private let icon = UILabel().then {
        $0.font = Fonts.title2
        $0.textColor = Colors.systemLightGray
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.backgroundColor = Colors.systemGray(.r50)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func configCell(_ isSelected: Bool, index: Int) {
        self.icon.text = iconTitle(index)
        switch isSelected {
        case true:
            self.icon.backgroundColor = Colors.systemColor(.r400)
            self.icon.textColor = .white
            
        case false:
            self.icon.backgroundColor = Colors.systemGray(.r100)
            self.icon.textColor = Colors.systemLightGray
        }
    }
    
}

private extension AlarmModalWeekViewCell {
    
    func setupUI() {
        configure()
        setupLayout()
    }

    func configure() {
        self.backgroundColor = .clear
        self.addSubview(self.icon)
    }
    
    func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func iconTitle(_ index: Int) -> String {
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
