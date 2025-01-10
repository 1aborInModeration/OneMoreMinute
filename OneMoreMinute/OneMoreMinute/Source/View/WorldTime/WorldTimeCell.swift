//
//  WorldTimeCell.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit

class WorldTimeCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let id: String = "WorldTimeCell"
    
    let cityNameLabel = TitleLabel()
    let dateLabel = BodyLabel()
    let cityTimeLabel = TitleLabel(size: .title1)
    
    private var timer: Timer?
    
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
        startClock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopClock()
    }
}


// MARK: - UI Layouts

extension WorldTimeCell {
    func setupSubViews() {
        [
            cityNameLabel,
            dateLabel,
            cityTimeLabel
        ].forEach { self.addSubview($0) }
    }
    
    func setupUIProperties() {
        self.backgroundColor = .wrapperBackground
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.wrapperStroke.cgColor
        self.layer.cornerRadius = Layouts.radius
                
        cityNameLabel.textColor = .fontLabel
        dateLabel.textColor = .fontGray
        cityTimeLabel.textColor = .mainTitle
    }
    
    func setupLayouts() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing6)
            make.leading.equalToSuperview().inset(Layouts.padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(Layouts.itemSpacing2)
            make.leading.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing6)
        }
        
        cityTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(Layouts.itemSpacing6)
            make.trailing.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing6)
        }
    }
}


// MARK: - Cell Configure

extension WorldTimeCell {
    func configure() {
        self.cityNameLabel.text = "Japan / Osaka"
        self.dateLabel.text = "01월 01일 일요일"
        print("aaasdfa")
    }
}


// MARK: - Actions

extension WorldTimeCell {
    private func startClock() {
        updateClock()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    @objc private func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        cityTimeLabel.text = formatter.string(from: Date())
    }
    
    private func stopClock() {
        timer?.invalidate()
        timer = nil
    }
}
