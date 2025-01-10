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
        AlarmViewController(),
        BViewController(),
        CViewController(),
        DViewController()
    ]
    
    private var selectedIndex = 0
    private let tabBar = MainTabBar()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setupFirstVC()
        bind()
    }
}

// MARK: - Configuration

extension MainTabBarController {
    private func configureHierarchy() {
        [
            tabBar
        ].forEach { view.addSubview($0) }
        
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
    private func bind() {
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
            make.edges.equalToSuperview()
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
    var count = 0
    
    let label = UILabel().then {
        $0.text = "0"
    }
    
    lazy var button = UIButton().then {
        $0.setTitle("Increase", for: .normal)
        $0.addAction(UIAction { _ in
            self.count += 1
            self.label.text = "\(self.count)"
        }, for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        [
            label,
            button
        ].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}

final class BViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

final class CViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

final class DViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}

@available(iOS 17.0, *)
#Preview {
    MainTabBarController()
}
