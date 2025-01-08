//
//  AlarmViewController.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AlarmViewController: UIViewController {
    
    private let viewModel = AlarmViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let alarmView = AlarmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = self.alarmView
        bind()
    }
    
}

private extension AlarmViewController {
    
    func bind() {
        self.viewModel.data
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.alarmView.collectionView.rx.items(
                cellIdentifier: AlarmCollectionViewCell.id,
                cellType: AlarmCollectionViewCell.self)
            ) { (row, element, cell) in
                
                cell.configCell(element)
                
            }.disposed(by: self.disposeBag)
        
    }
}
