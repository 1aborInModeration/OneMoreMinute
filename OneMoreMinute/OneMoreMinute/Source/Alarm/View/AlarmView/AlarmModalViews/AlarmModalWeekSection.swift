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
    
    private(set) var cellSelectedStates = BehaviorRelay(value: [Bool]())
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        let items = [Bool](repeating: false, count: 7)
        self.cellSelectedStates.accept(items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        let items = [Bool](repeating: false, count: 7)
        self.cellSelectedStates.accept(items)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !self.weeks.frame.contains(point) else {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}

// MARK: - UI Setting Method

private extension AlarmModalWeekSection {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        bind()
    }
    
    func configureSelf() {
        self.backgroundColor = .clear
        [self.title,
         self.weeks].forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(15)
        }
        
        self.weeks.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    /// 데이터 바인딩 메소드
    func bind() {
        /// Driver를 공유하여 두가지 바인딩에서 재사용
        let sharedStream = cellSelectedStates.asDriver()
        
        sharedStream
            .drive(self.weeks.rx.items(
                cellIdentifier: AlarmModalWeekViewCell.id,
                cellType: AlarmModalWeekViewCell.self)
            ) { (row, element, cell) in
                cell.configCell(element, index: row)
            }.disposed(by: self.disposeBag)
        
        // 셀 선택 액션 바인딩
        weeks.rx.itemSelected
        /// 매번 cellSelectedStates의 최신값을 읽어서 수정하지 않고, withLatestFrom 연산자로 최신값 receive
            .withLatestFrom(sharedStream) { indexPath, values -> [Bool] in
                var newValues = values
                
                newValues[indexPath.item].toggle()
                return newValues
            }
            /// 암시적 약한 참조 처리, emit 대신자동 바인딩을 통해 상태 업데이트
            .bind(to: cellSelectedStates)
            .disposed(by: self.disposeBag)
    }
    
}
