//
//  MainTabBarItem.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit
import SnapKit
import Then
import RxRelay

/// 커스텀 탭바 아이템
final class MainTabBarItem: UIControl {
    private let tabItem: OneMoreMinuteTab
    
    /// 탭이 선택되었을 때 해당 인덱스를 방출하는 PublishRelay
    let tappedIndexRelay = PublishRelay<Int>()
    
    // MARK: - View Property
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = UIColor(resource: .tabBarTint)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(ofSize: 10, weight: .regular)
        $0.textColor = UIColor(resource: .tabBarTint)
    }
    
    private let backgroundView = UIView().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Initializer
    
    /// TabBarItem을 기반으로 새로운 MainTabBarItem을 생성합니다.
    /// - Parameter item: 탭바 아이템 정보를 담고 있는 TabBarItem enum
    init(item: OneMoreMinuteTab) {
        self.tabItem = item
        super.init(frame: .zero)
        initialSetup(with: item)
        configureHierarchy()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Mehtod
    
    /// 런치 시 첫 탭바 아이템을 선택하는 메소드
    /// layoutIfNeeded가 제외되어 오토레이아웃 충돌을 방지
    func selectWithoutAnimation() {
        backgroundView.backgroundColor = UIColor(resource: .tabBarSelectedBackground)
        imageView.tintColor = UIColor(resource: .tabBarSelectedTint)
        titleLabel.textColor = UIColor(resource: .tabBarSelectedTint)
    }
    
    /// 탭바 아이템이 선택되었을 때 호출되는 메서드
    ///
    /// 아이템의 텍스트 색상, 이미지 틴트 색상, 배경색을 선택된 상태로 변경합니다.
    ///
    /// Example:
    /// ```swift
    /// let tabBarItem = MainTabBarItem(item: .alarm)
    /// tabBarItem.select() // 선택된 상태로 UI 변경
    /// ```
    func select() {
        backgroundView.backgroundColor = UIColor(resource: .tabBarSelectedBackground)
        imageView.tintColor = UIColor(resource: .tabBarSelectedTint)
        titleLabel.textColor = UIColor(resource: .tabBarSelectedTint)

        backgroundView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3) { [weak self] in
            self?.backgroundView.transform = .identity
            self?.layoutIfNeeded()
        }
    }
    
    /// 탭바 아이템이 선택 해제되었을 때 호출되는 메서드
    ///
    /// 아이템의 텍스트 색상, 이미지 틴트 색상을 기본 상태로 변경하고,
    /// 배경색을 투명하게 설정합니다.
    ///
    /// Example:
    /// ```swift
    /// let tabBarItem = MainTabBarItem(item: .alarm)
    /// tabBarItem.deselect() // 기본 상태로 UI 변경
    /// ```
    func deselect() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.titleLabel.textColor = UIColor(resource: .tabBarTint)
            self?.imageView.tintColor = UIColor(resource: .tabBarTint)
            self?.backgroundView.backgroundColor = UIColor(resource: .tabBarSelectedBackground).withAlphaComponent(0)
            self?.layoutIfNeeded()
        }
    }
}

// MARK: - Configuration

extension MainTabBarItem {
    private func configureHierarchy() {
        [
            imageView,
            titleLabel,
        ].forEach { backgroundView.addSubview($0) }
        
        addSubview(backgroundView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    private func initialSetup(with item: OneMoreMinuteTab) {
        imageView.image = item.image.withRenderingMode(.alwaysTemplate)
        titleLabel.text = item.title
    }
    
    private func configureAction() {
        addAction(
            UIAction { [weak self, tabItem] _ in
                self?.tappedIndexRelay.accept(tabItem.index)
                HapticService.selection.run()
            },
            for: .touchUpInside
        )
    }
}

@available(iOS 17.0, *)
#Preview {
    let tabbarItem = MainTabBarItem(item: .alarm)
    return tabbarItem
}

@available(iOS 17.0, *)
#Preview {
    let tabbarItem = MainTabBarItem(item: .alarm)
    tabbarItem.select()
    return tabbarItem
}
