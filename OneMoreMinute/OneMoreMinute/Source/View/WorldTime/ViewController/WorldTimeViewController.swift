//
//  WorldTimeViewController.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Inject


class WorldTimeViewController: UIViewController {
    // MARK: - Properties

    let worldTimeViewModel = WorldTimeViewModel()
    let worldTimeView = Inject.ViewHost(WorldTimeView())
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        self.view = worldTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupSwipeActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 해당 뷰가 보여질 때마다 새로 시계 셋업.
        worldTimeViewModel.setupClock()
    }
    
    
}

// MARK: - Bindings

extension WorldTimeViewController {
    func setupBindings() {
        worldTimeView.plusButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                if let topVC = AppHelpers.getTopViewController() {
                    let searchModalVC = Inject.ViewControllerHost(SearchCityModalViewController())
                    searchModalVC.modalPresentationStyle = .overFullScreen
                    searchModalVC.modalTransitionStyle = .crossDissolve
                    topVC.present(searchModalVC, animated: true) {
                        searchModalVC.dismissCompletion = { [weak self] in
                            self?.worldTimeViewModel.setupClock()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        worldTimeViewModel.worldTimesRelay
            .bind(to: worldTimeView.worldTimeCollectionView.rx.items(
                cellIdentifier: WorldTimeCell.id,
                cellType: WorldTimeCell.self
            )) { row, worldTime, cell in
                cell.configure(worldTime: worldTime)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Actions

extension WorldTimeViewController {
    
    func setupSwipeActions() {
        worldTimeView.worldTimeCollectionView.addSwipeAction(
            trailingActionProvider: { indexPath in
                var actions: [UIContextualAction] = []
                
                // 삭제 액션 추가
                let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completionHandler in
                    print(indexPath.row)
//                    self.deleteWorldTime(timeZoneId: indexPath.row.)
                    completionHandler(true)
                }
                deleteAction.backgroundColor = .buttonRed
                deleteAction.image = UIImage(systemName: "trash")
                actions.append(deleteAction)
                
                let alertAction = UIContextualAction(style: .normal, title: "알림") { _, _, completionHandler in
                    AppHelpers.showBasicAlert(title: "알림", message: "알림 기능 준비중")
                    completionHandler(true)
                }
                alertAction.backgroundColor = .subTitle
                alertAction.image = UIImage(systemName: "bell")
                actions.append(alertAction)
                
                return actions
            },
            leadingActionProvider: { indexPath in
                var actions: [UIContextualAction] = []
                
                // 즐겨찾기 액션 추가
                let favoriteAction = UIContextualAction(style: .normal, title: "즐겨찾기") { _, _, completionHandler in
                    AppHelpers.showBasicAlert(title: "즐겨찾기", message: "\(indexPath.row + 1)번째 항목을 즐겨찾기에 추가! 하는 척해보았습니다.")
                    completionHandler(true)
                }
                favoriteAction.backgroundColor = .statusYellow
                favoriteAction.image = UIImage(systemName: "star")
                actions.append(favoriteAction)
                
                return actions
            }
        )
    }
}
