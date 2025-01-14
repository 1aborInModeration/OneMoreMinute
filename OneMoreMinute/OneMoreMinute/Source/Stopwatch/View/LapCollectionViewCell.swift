//
//  LapCollectionViewCell.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-09.
//

import UIKit
import SnapKit
import Then

final class LapCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "LapCollectionViewCell"
    
    // MARK: - UI Components
    
    private let lapLabel = UILabel().then {
        $0.font = Fonts.cardClock2
        $0.textColor = UIColor(resource: .fontLabel)
        $0.textAlignment = .left
    }
    
    private let lapTimeLabel = UILabel().then {
        $0.font = Fonts.cardClock2
        $0.textColor = UIColor(resource: .mainTitle)
        $0.textAlignment = .right
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(lapLabel)
        contentView.addSubview(lapTimeLabel)
        
        lapLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        lapTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        contentView.backgroundColor = UIColor(resource: .wrapperBackground)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor(resource: .wrapperStroke).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 4
    }
    
    // MARK: - Configure
    
    func configure(with viewModel: LapViewModel) {
        lapLabel.text = viewModel.lapLabel
        lapTimeLabel.text = viewModel.lapTimeLabel
        
        if viewModel.isFastest {
            lapLabel.textColor = .systemGreen
        } else if viewModel.isSlowest {
            lapLabel.textColor = .systemRed
        } else {
            lapLabel.textColor = UIColor(resource: .fontLabel)
        }
    }
}
