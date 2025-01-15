//
//  WorldTImeView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WorldTimeView: UIView {
    
    // MARK: - UIComponents & Properties
    
    let worldTimeCollectionView = VerticalCollectionView()
    let plusButton = ShowModalButton()
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Layouts

extension WorldTimeView {
    func setupSubViews() {
        [
            worldTimeCollectionView,
            plusButton
        ].forEach { addSubview($0) }
    }
    
    func setupUIProperties() {
        
    }
    
    func setupLayouts() {
        worldTimeCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Layouts.padding)
            make.trailing.equalToSuperview().inset(Layouts.padding)
            make.width.height.equalTo(Layouts.buttonHeight)
        }
    }
}

// MARK: - Actions

extension WorldTimeView {
    
}
