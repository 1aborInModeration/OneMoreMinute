//
//  AlarmModalCollectionViewCell.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then

/// 모달뷰의 반복 요일 섹션 커스텀 셀
final class AlarmModalWeekViewCell: UICollectionViewCell {
    
    static let id: String = "AlarmModalWeekViewCell"
    
    private let icon = UILabel().then {
        $0.font = Fonts.title2
        $0.textColor = UIColor.grayButtonLabel
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.grayButtonBackground
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // MARK: - AlarmModalWeekViewCell Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    /// 셀 재사용 옵션
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    /// 셀의 설정을 하는 메소드
    /// - Parameters:
    ///   - isSelected: 셀이 선택되었는지 확인
    ///   - index: 선택된 셀의 인덱스
    func configCell(_ isSelected: Bool, index: Int) {
        self.icon.text = WeekDaysTitle(rawValue: index)?.title
        switch isSelected {
        case true:
            self.icon.backgroundColor = UIColor.plusButtonBackground
            self.icon.textColor = .white
            
        case false:
            self.icon.backgroundColor = UIColor.grayButtonBackground
            self.icon.textColor = UIColor.grayButtonLabel
        }
    }
}

// MARK: - AlarmModalWeekViewCell UI Setting Method

private extension AlarmModalWeekViewCell {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        self.backgroundColor = .clear
        self.addSubview(self.icon)
    }
    
    func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
