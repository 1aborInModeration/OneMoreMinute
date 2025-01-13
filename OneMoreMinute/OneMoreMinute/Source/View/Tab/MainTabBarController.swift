//
//  MainTabBarController.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

/// 메인 화면의 탭바 컨트롤러.
/// 4개의 탭을 가지고 있으며, 각 탭은 독립적인 뷰 컨트롤러를 관리.
/// 커스텀 탭바를 사용하여 UI를 구성.
final class MainTabBarController: UIViewController {
    // 각 탭에 해당하는 자식 뷰 컨트롤러 리스트
    private let childVCList = [
        AViewController(),
        WorldTimeViewController(),
        StopwatchViewController(),
        DViewController()
    ]
    
    private let gradientLayer = CAGradientLayer()
    private let currentTimeAndDate = CurrentTimeAndDateView()
    private let tabBar = MainTabBar()
    
    private var selectedIndex = 0
    private let viewModel = MainTabViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        configureHierarchy()
        setupFirstVC()
        bindTabBar()
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        configureGradientColor()
    }
}

// MARK: - Configuration

extension MainTabBarController {
    private func configureHierarchy() {
        [
            currentTimeAndDate,
            tabBar
        ].forEach { view.addSubview($0) }
        
        currentTimeAndDate.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(72)
        }
        
        tabBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func setupFirstVC() {
        addChildVC(at: 0)
    }
    
    /// 탭바의 이벤트를 구독하고 처리
    /// 탭 선택 시 해당하는 뷰 컨트롤러로 전환
    private func bindTabBar() {
        tabBar.tappedIndexRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                guard index != self.selectedIndex else { return }
                self.addChildVC(at: index)
                self.removeChildVC(at: self.selectedIndex)
                self.selectedIndex = index
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: Observable.just(Void())
            )
        )
        
        output.currentTime
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] time in
                self?.currentTimeAndDate.updateTimeLabel(with: time)
            })
            .disposed(by: disposeBag)
        
        output.currentDate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] date in
                self?.currentTimeAndDate.updateDateLabel(with: date)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Background Gradient Color Configuration

extension MainTabBarController {
    /// 라이트, 다크 모드 변경에 따라 gradient 색상 변경
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureGradientColor()
        }
    }
    
    /// 현재 뷰의 trait collection에 따라 색상 할당
    private func configureGradientColor() {
        let traitCollection = view.traitCollection
        
        gradientLayer.colors = [
            UIColor.appBackgroundStart.resolvedColor(with: traitCollection).cgColor,
            UIColor.appBackgroundEnd.resolvedColor(with: traitCollection).cgColor
        ]
    }
}

// MARK: - Child VC 관리

extension MainTabBarController {
    /// 지정된 인덱스의 자식 뷰 컨트롤러를 추가
    /// - Parameter index: 추가할 뷰 컨트롤러의 인덱스
    private func addChildVC(at index: Int) {
        guard let vc = childVCList[safe: index] else {
            AppLogger.error("Error: index out of range")
            return
        }
        
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.top.equalTo(currentTimeAndDate.snp.bottom).offset(48)
            make.bottom.equalTo(tabBar.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        vc.didMove(toParent: self)
        view.bringSubviewToFront(tabBar)
    }
    
    /// 지정된 인덱스의 자식 뷰 컨트롤러를 제거
    /// - Parameter index: 제거할 뷰 컨트롤러의 인덱스
    private func removeChildVC(at index: Int) {
        guard let vc = childVCList[safe: index] else {
            AppLogger.error("Error: index out of range")
            return
        }
        
        vc.willMove(toParent: nil)
        vc.view.snp.removeConstraints()
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}

// TODO: 각 임시 뷰컨 실제 뷰컨으로 변경하기

/// 임시 뷰 컨트롤러 A - 카운터 기능을 가진 테스트용 뷰 컨트롤러
final class AViewController: UIViewController {
    private let label = UILabel().then {
        $0.text = "A"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [
            label,
        ].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

final class BViewController: UIViewController {
    private let label = UILabel().then {
        $0.text = "B"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [
            label,
        ].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

final class CViewController: UIViewController {
    private let label = UILabel().then {
        $0.text = "C"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [
            label,
        ].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

final class DViewController: UIViewController {
    private let label = UILabel().then {
        $0.text = "D"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [
            label,
        ].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainTabBarController()
}
