//
//  VerticalCollectionView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit


final class VerticalCollectionView: UICollectionView {
    
    // MARK: - Life Cycles
    init() {
        super.init(frame: .zero, collectionViewLayout: VerticalCollectionView.createCompositionalLayout())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


// MARK: - Compositional Layout Setup

extension VerticalCollectionView {
    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: VerticalCollectionView.createWorldTimeSection())
    }
    
    private static func createWorldTimeSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
       
        section.interGroupSpacing = Layouts.itemSpacing2
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Layouts.itemSpacing1,
            leading: Layouts.paddingLarge,
            bottom: Layouts.itemSpacing1,
            trailing: Layouts.paddingLarge
        )
        
        return section
    }
    
    private func setupCollectionView() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        register(
            WorldTimeCell.self,
            forCellWithReuseIdentifier: WorldTimeCell.id
        )
    }
}
