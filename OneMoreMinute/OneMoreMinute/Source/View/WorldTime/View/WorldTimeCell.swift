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
        
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        contentWrapperView.backgroundColor = .wrapperBackground
        contentWrapperView.layer.borderWidth = 1
        contentWrapperView.layer.borderColor = UIColor.wrapperStroke.cgColor
        contentWrapperView.layer.cornerRadius = Layouts.radius
                
        cityNameLabel.textColor = .fontLabel
        dateLabel.textColor = .fontGray
        cityTimeLabel.textColor = .mainTitle
        
        deleteButton.applyButtonAction(action: deleteButtonTapped)
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
    }
}



// MARK: - Gesture Recognizers

extension WorldTimeCell {

    private func setupGestureRecognizers() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        self.addGestureRecognizer(swipeGesture)
    }
        
    @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        
        if gesture.state == .changed {
            if translation.x < -(Layouts.buttonHeight + Layouts.itemSpacing1) && !isDeleteButtonVisible {
                showDeleteButton()
            } else if translation.x > (Layouts.buttonHeight + Layouts.itemSpacing1) && isDeleteButtonVisible {
                hideDeleteButton()
            }
        }
    }
    
    private func showDeleteButton() {
        isDeleteButtonVisible = true
        deleteButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
//            self.cityTimeLabel.transform = CGAffineTransform(translationX: -70, y: 0)
            
            self.contentWrapperView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(Layouts.buttonHeight + Layouts.itemSpacing1)
            }
        }
    }
    
    private func hideDeleteButton() {
        isDeleteButtonVisible = false
        UIView.animate(withDuration: 0.3) {
            self.cityNameLabel.transform = .identity
        } completion: { _ in
            self.deleteButton.isHidden = true
        }
    }
    
    // MARK: - Button Action
    func deleteButtonTapped() {
        print("삭제 버튼 클릭!")
        // 여기에 삭제 로직을 추가하세요.
    }
}
