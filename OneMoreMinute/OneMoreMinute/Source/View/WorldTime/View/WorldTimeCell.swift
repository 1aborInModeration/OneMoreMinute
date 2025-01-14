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
    
    let contentWrapperView = UIView()
    let cityNameLabel = TitleLabel()
    let dateLabel = BodyLabel()
    let cityTimeLabel = ClockLabel(type: .worldCard)
    let deleteButton = CellGestureButton(type: .delete)
    
    private var isDeleteButtonVisible = false
    private var timer: Timer?
    private var timeZone: TimeZone?
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()  // 기존 타이머를 정리합니다.
    }
    
    deinit {
        timer?.invalidate()
    }
}


// MARK: - UI Layouts

extension WorldTimeCell {
    func setupSubViews() {
        [
            contentWrapperView,
            deleteButton
        ].forEach { self.addSubview($0) }
        
        [
            cityNameLabel,
            dateLabel,
            cityTimeLabel
        ].forEach { contentWrapperView.addSubview($0) }
    }
    
    func setupUIProperties() {
        self.backgroundColor = .clear
        
        contentWrapperView.backgroundColor = UIColor.wrapperBackground
        contentWrapperView.layer.borderWidth = Layouts.borderWidthThin
        contentWrapperView.layer.cornerRadius = Layouts.radius
        cityNameLabel.textColor = .fontLabel
        dateLabel.textColor = .fontGray
        cityTimeLabel.textColor = .mainTitle
    }
    
    func setupLayouts() {
        contentWrapperView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing4)
            make.leading.equalToSuperview().inset(Layouts.padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(Layouts.itemSpacing1)
            make.leading.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing4)
        }
        
        cityTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(Layouts.itemSpacing4)
            make.trailing.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing4)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Layouts.buttonHeight)
        }
    }
}


// MARK: - Cell Configure

extension WorldTimeCell {
    func configure(worldTime: WorldTime) {
        self.cityNameLabel.text = worldTime.cityName
        self.dateLabel.text = worldTime.currentDate
        self.cityTimeLabel.text = worldTime.currentTime
        
        startClock()
    }
}

// MARK: - Timer Setup

extension WorldTimeCell {
    
    private func startClock() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateClock()
        }
    }

    private func updateClock() {
        guard let timeZone = timeZone else { return }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"

        let currentTime = formatter.string(from: Date())
        cityTimeLabel.text = currentTime
    }
}


// MARK: - Gesture Recognizers

extension WorldTimeCell {
    /// 컨텐츠 에어리어가 터치되었을 때마다 삭제 버튼 토글
    func contentsAreaTapped() {
        isDeleteButtonVisible = !isDeleteButtonVisible
        deleteButton.isHidden = !isDeleteButtonVisible
        
        self.contentWrapperView.snp.makeConstraints { make in
            if isDeleteButtonVisible {
                make.trailing.equalToSuperview().inset(Layouts.buttonHeight + Layouts.itemSpacing1)
            } else {
                make.trailing.equalToSuperview()
            }
        }
    }

    
    // MARK: - Button Action
    func deleteButtonTapped() {
        print("삭제 버튼 클릭!")
    }
}
