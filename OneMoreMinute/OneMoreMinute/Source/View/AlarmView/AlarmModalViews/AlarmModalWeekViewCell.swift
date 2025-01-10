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
        self.icon.text = index.weekTitle
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
}
