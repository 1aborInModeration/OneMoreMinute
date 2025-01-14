//
//  CityListCollectionView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import SnapKit


final class CityListCollectionView: UICollectionView {
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero, collectionViewLayout: CityListCollectionView.createCompositionalLayout())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Compositional Layout Setup

extension CityListCollectionView {
    
    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: CityListCollectionView.createCityListSection())
    }
    
    private static func createCityListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
       
        section.interGroupSpacing = Layouts.itemSpacing1
        
        return section
    }
    
    private func setupCollectionView() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        register(
            CityListCell.self,
            forCellWithReuseIdentifier: CityListCell.id
        )
    }
}

