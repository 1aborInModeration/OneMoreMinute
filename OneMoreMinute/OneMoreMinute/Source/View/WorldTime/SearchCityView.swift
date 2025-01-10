//
//  SearchCityView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit

class SearchCityView: UIView {
    
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

extension SearchCityView {
    func setupSubViews() {
        [
            
        ].forEach { addSubview($0) }
    }
    
    func setupUIProperties() {

    }
    
    func setupLayouts() {
        
    }
}
