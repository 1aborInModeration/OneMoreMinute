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
    }
    
    
}

// MARK: - Bindings

extension WorldTimeViewController {
    func setupBindings() {
        worldTimeView.plusButton.rx
            .tap
            .subscribe(onNext: {
                if let topVC = AppHelpers.getTopViewController() {
                    let searchModalVC = Inject.ViewControllerHost(SearchCityModalViewController())
                    searchModalVC.modalPresentationStyle = .overFullScreen
                    searchModalVC.modalTransitionStyle = .crossDissolve
                    topVC.present(searchModalVC, animated: true)
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

