//
//  SearchCityView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit

class SearchCityView: WrapperView {

    let titleLabel = TitleLabel(size: .title1)
    let closeButton = CloseButton()
    let searchBar = CustomSearchBar()
    let separatorView = SeparatorLineView()
    let cityListCollectionView = CityListCollectionView()
        
    weak var delegate: ModalCloseDelegate?

    override init() {
        super.init()
        
        setupSubViews()
        setupUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetupUI Layouts

extension SearchCityView {
    
    func setupSubViews() {
        [
            titleLabel,
            closeButton,
            searchBar,
            separatorView,
            cityListCollectionView
        ].forEach { addSubview($0) }
    }
    
    func setupUIProperties() {
        self.backgroundColor = .wrapperBackground
        self.layer.borderWidth = Layouts.borderWidthThin
        self.layer.cornerRadius = Layouts.radius
        
        titleLabel.text = "세계시간 추가"
        searchBar.placeholder = "도시 검색"
        
        closeButton.applyButtonAction(action: closeModal)
    }
    
    func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing7)
            make.leading.equalToSuperview().inset(Layouts.padding)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layouts.itemSpacing7)
            make.trailing.equalToSuperview().inset(Layouts.padding)
            make.height.equalTo(titleLabel.snp.height)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layouts.itemSpacing4)
            make.leading.trailing.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(Layouts.itemSpacing4)
            make.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }

        cityListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Layouts.itemSpacing4)
            make.leading.trailing.equalToSuperview().inset(Layouts.padding)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Modal Porotocol Constraints

extension SearchCityView {
    
    func closeModal() {
        delegate?.closeModal()
    }
}

