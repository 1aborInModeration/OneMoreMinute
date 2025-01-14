//
//  CityListCell.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import SnapKit
import MapKit

class CityListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id: String = "CityListCell"
    
    let cityNameLabel = BodyLabel(isBold: true)
    let timeZoneLabel = BodyLabel()

    
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
    
}


// MARK: - UI Layouts

extension CityListCell {
    
    func setupSubViews() {
        [
            cityNameLabel,
            timeZoneLabel,
        ].forEach { self.addSubview($0) }
    }
    
    func setupUIProperties() {
        cityNameLabel.textColor = .fontLabel
        timeZoneLabel.textColor = .fontGray
    }
    
    func setupLayouts() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing4)
            make.leading.trailing.equalToSuperview()
        }
        
        timeZoneLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(Layouts.itemSpacing1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing4)
        }
    }
}


// MARK: - Cell Configure

extension CityListCell {
    
    func configure(with cityTimeZone: CityTimeZone) {
        self.cityNameLabel.text = cityTimeZone.cityName
        self.timeZoneLabel.text = cityTimeZone.timeDifference
    }
}
