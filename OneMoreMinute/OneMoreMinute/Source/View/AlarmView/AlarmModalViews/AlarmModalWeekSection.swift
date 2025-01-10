//
//  AlarmModalWeekSection.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/9/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

/// 모달뷰의 반복 요일을 설정하는 섹션 뷰
final class AlarmModalWeekSection: UIView {
    
    // MARK: - Rx Properties
    
    private(set) var isSelecteds = BehaviorRelay(value: [Bool]())
    private let disposeBag = DisposeBag()
    
    // MARK: - AlarmModalWeekSection UI
    
    private let title = AlarmModalSectionTitle(title: "반복 요일")
    
    private lazy var weeks = UICollectionView(frame: .zero, collectionViewLayout: self.layout).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.register(AlarmModalWeekViewCell.self, forCellWithReuseIdentifier: AlarmModalWeekViewCell.id)
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/5),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let firstGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let firstGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: firstGroupSize,
            repeatingSubitem: item,
            count: 5
        )
        firstGroup.interItemSpacing = .fixed(10)
        
        let secondGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let secondGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: secondGroupSize,
            repeatingSubitem: item,
            count: 5
        )
        secondGroup.interItemSpacing = .fixed(10)
        
        let containerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(90)
        )
        
        let containerGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: containerGroupSize,
            subitems: [firstGroup, secondGroup]
        )
        containerGroup.interItemSpacing = .fixed(10)
        
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }()
    
    // MARK: - AlarmModalWeekSection Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        let items = [Bool](repeating: false, count: 7)
        self.isSelecteds.accept(items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        let items = [Bool](repeating: false, count: 7)
        self.isSelecteds.accept(items)
    }
    
}

// MARK: - AlarmModalWeekSection UI Setting Method
private extension AlarmModalWeekSection {
    
    func setupUI() {
        configure()
        setupLayout()
        bind()
    }
    
    func configure() {
        self.backgroundColor = .clear
        [self.title,
         self.weeks].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.weeks.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    /// 데이터 바인딩 메소드
    func bind() {
        // 컬렉션뷰의 데이터소스 바인딩
        self.isSelecteds
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.weeks.rx.items(
                cellIdentifier: AlarmModalWeekViewCell.id,
                cellType: AlarmModalWeekViewCell.self)
            ) { (row, element, cell) in
                
                cell.configCell(element, index: row)
                
            }.disposed(by: self.disposeBag)
        
        // 셀 선택 액션 바인딩
        self.weeks.rx.itemSelected
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                var currentValues = owner.isSelecteds.value
                
                guard indexPath.item >= 0 && indexPath.item < currentValues.count else { return }
                
                currentValues[indexPath.item].toggle()
                
                owner.isSelecteds.accept(currentValues)
                
            }.disposed(by: self.disposeBag)
        
    }
    
}
