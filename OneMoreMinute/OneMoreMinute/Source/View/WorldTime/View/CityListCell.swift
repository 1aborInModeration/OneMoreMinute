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
    
    var cityTimeZone: CityTimeZone
        
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        self.cityTimeZone = CityTimeZone(cityName: "", timeZone: TimeZone.current)
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
            timeZoneLabel
        ].forEach { self.addSubview($0) }
    }
    
    func setupUIProperties() {                
        cityNameLabel.textColor = .fontLabel
        timeZoneLabel.textColor = .fontGray
    }
    
    func setupLayouts() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing4)
            make.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }

        timeZoneLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).inset(Layouts.padding)
            make.leading.trailing.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview().inset(Layouts.itemSpacing4)
        }
    }
}


// MARK: - Cell Configure

extension CityListCell {
    func configure(with cityTimeZone: CityTimeZone) {
        self.cityTimeZone = cityTimeZone
        self.cityNameLabel.text = cityTimeZone.cityName
        
        let localTimeZone = TimeZone.current
        let cityTimeZone = cityTimeZone.timeZone

        let timeDifference = cityTimeZone.secondsFromGMT() - localTimeZone.secondsFromGMT()
        let hoursDifference = timeDifference / 3600
        
        let differenceString: String
        if hoursDifference == 0 {
            differenceString = "Same as local time"
        } else if hoursDifference > 0 {
            differenceString = "+\(hoursDifference) hours"
        } else {
            differenceString = "\(hoursDifference) hours"
        }
        
        self.timeZoneLabel.text = differenceString
    }
}


// MARK: - Actions

extension CityListCell {
    func tabPlusButton() {
        
    }
}
