//
//  MainTabBar.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

/// 커스텀 탭바
final class MainTabBar: UIView {
    /// 탭이 선택되었을 때 해당 인덱스를 방출하는 PublishRelay
    let tappedIndexRelay = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: makeArrangedSubviews()
    ).then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        selectFirstTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selectFirstTab() {
        guard let item = stackView.arrangedSubviews.first as? MainTabBarItem else {
            AppLogger.error("탭 아이템 없음")
            return
        }
        
        item.selectWithoutAnimation()
    }
    
    /// 선택한 인덱스 탭 아이템만 selected 상태로 변경, 나머지는 deselected 상태로 변경
    private func selectTab(at index: Int) {
        // FIXME: 이전에 선택된 index 알고 있으면 전체 순환할 필요 없음
        for i in stackView.arrangedSubviews.indices {
            guard let item = stackView.arrangedSubviews[i] as? MainTabBarItem else {
                AppLogger.error("탭 아이템 없음")
                return
            }
            
            index == i ? item.select() : item.deselect()
        }
    }
}

// MARK: - Configuration

extension MainTabBar {
    private func configureHierarchy() {
        self.backgroundColor = .componentBackground
        [
            stackView
        ].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func makeArrangedSubviews() -> [UIView]{
        var arrangedSubViews: [UIView] = []
        for item in OneMoreMinuteTab.allCases {
            let item = MainTabBarItem(item: item)
            item.tappedIndexRelay
                .subscribe(onNext: { [weak self] index in
                    self?.selectTab(at: index)
                    self?.tappedIndexRelay.accept(index)
                })
                .disposed(by: disposeBag)
            arrangedSubViews.append(item)
        }
        return arrangedSubViews
    }
}

@available(iOS 17.0, *)
#Preview {
    MainTabBar()
}
