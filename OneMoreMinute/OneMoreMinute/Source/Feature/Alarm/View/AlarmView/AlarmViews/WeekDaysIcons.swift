//
//  WeekDaysIcons.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import Then

/// 알람뷰 셀의 반복 요일을 표시하는 뷰
final class WeekDaysIcons: UIView {
    
    private var weekDays: [Bool] = [] // 요일 UI를 추가하기 위한 데이터
    private var avoidDuplication: Set<String> = []
    
    private let stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 5
        $0.alignment = .leading
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    /// 아이콘을 다시 생성하는 메소드
    /// - Parameter data: 아이콘 생성을 위한 데이터
    func reloadIcons(data: [Bool]) {
        self.stack.arrangedSubviews.forEach { subView in
            self.stack.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        self.weekDays = data
        setupIcons()
    }
}

// MARK: - UI Setting Method

private extension WeekDaysIcons {
    
    func setupUI() {
        configureSelf()
        setupIcons()
        setupLayout()
    }
    
    func configureSelf() {
        self.addSubview(self.stack)
        self.backgroundColor = .clear
    }
    
    /// 스택뷰에 요일 아이콘 레이블을 추가하는 메소드
    func setupIcons() {
        guard !self.weekDays.allSatisfy({ $0 }) else { return }
        avoidDuplication.removeAll()
        
        for (index, isActive) in self.weekDays.enumerated() where isActive {
            guard let week = WeekDaysTitle(rawValue: index)?.title,
                  !avoidDuplication.contains(week) else { continue }
            
            let label = createLabel(for: week)
            self.stack.addArrangedSubview(label)
            avoidDuplication.insert(week)
        }
        
        self.stack.isHidden = false
    }
    
    /// 레이블을 생성하는 메소드
    /// - Parameter week: 레이블 타이틀
    /// - Returns: 요일 아이콘 레이블
    func createLabel(for week: String) -> UILabel {
        let label = UILabel()
        label.text = week
        label.font = Fonts.title2
        label.textColor = UIColor.mainTitle
        label.textAlignment = .center
        label.numberOfLines = 1
        label.layer.cornerRadius = 15
        label.backgroundColor = UIColor.buttonBackground
        label.clipsToBounds = true
        
        label.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        return label
    }
    
    func setupLayout() {
        self.stack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
}

