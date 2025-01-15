//
//  VerticalCollectionView.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit

class VerticalCollectionView: UICollectionView {
    
    // MARK: - Initializer
    
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
        return UICollectionViewCompositionalLayout(section: VerticalCollectionView.createSection())
    }
    
    private static func createSection() -> NSCollectionLayoutSection {
        
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

// MARK: - Swipe Button

extension VerticalCollectionView {
    
    /// swipe로 액션버튼을 추가하기
    ///  
    /// UICollectionViewCompositionalLayout 에 UICollectionLayoutListConfiguration 을 적용하여 스와이프를 통해 액션 버튼을 추가하도록 하였다.
    /// - Parameter trailingActionProvider: UIContextualAction 의 배열로 이루어진 스와이프 액션 버튼 모음
    /// - Parameter leadingActionProvider: UIContextualAction 의 배열로 이루어진 스와이프 액션 버튼 모음
    func addSwipeAction(
        trailingActionProvider: @escaping (IndexPath) -> [UIContextualAction] = { _ in [] },
        leadingActionProvider: @escaping (IndexPath) -> [UIContextualAction] = { _ in [] }
    ) {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = sectionIndex == 0 ? .supplementary : .none
            config.backgroundColor = .clear
            
            // Trailing 스와이프 액션 추가
            config.trailingSwipeActionsConfigurationProvider = { indexPath in
                let actions = trailingActionProvider(indexPath)
                return UISwipeActionsConfiguration(actions: actions)
            }
            
            // Leading 스와이프 액션 추가
            config.leadingSwipeActionsConfigurationProvider = { indexPath in
                let actions = leadingActionProvider(indexPath)
                return UISwipeActionsConfiguration(actions: actions)
            }
            
            // 리스트 섹션 생성
            let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            
            // 기존 섹션의 레이아웃 수치를 동일하게 사용하여 간격 및 인셋 설정
            listSection.interGroupSpacing = Layouts.itemSpacing2
            listSection.contentInsets = NSDirectionalEdgeInsets(
                top: Layouts.itemSpacing1,
                leading: Layouts.paddingLarge,
                bottom: Layouts.itemSpacing1,
                trailing: Layouts.paddingLarge
            )
            
            return listSection
        }
        
        self.collectionViewLayout = layout
    }
}
