//
//  CurrentTimeView.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit
import SnapKit
import Then

/// 메인 화면에서 현재 시각과 날짜를 보여주는 뷰
final class CurrentTimeAndDateView: UIView {
    private let timeLabel = UILabel().then {
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        $0.numberOfLines = 1
        $0.text = " "
        $0.textColor = UIColor(resource: .timeAndDateLabel)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 1
        $0.text = " "
        $0.textColor = UIColor(resource: .timeAndDateLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTimeLabel(with time: String) {
        timeLabel.text = time
    }
    
    func updateDateLabel(with date: String) {
        dateLabel.text = date
    }
}

extension CurrentTimeAndDateView {
    private func configureHierarchy() {
        [
            timeLabel,
            dateLabel
        ].forEach { addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
