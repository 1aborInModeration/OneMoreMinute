//
//  AlarmView.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class AlarmView: UIView {
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout).then {
        $0.backgroundColor = .clear
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

private extension AlarmView {
    
    func setupUI() {
        configure()
        setupLayout()
    }
    
    func configure() {
        self.backgroundColor = .clear
        self.addSubview(self.collectionView)
    }
    
    func setupLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

