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
                
                cell.alarmButtonTapped
                    .map { IndexPath(row: row, section: 0) }
                    .bind(to: self.viewModel.alarmButtonTapped)
                    .disposed(by: self.disposeBag)
                
                cell.deleteButtonTapped
                    .map { IndexPath(row: row, section: 0)}
                    .bind(to: self.viewModel.deleteButtonTapped)
                    .disposed(by: self.disposeBag)
                
            }.disposed(by: self.disposeBag)
        
        self.viewModel.alarmButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                guard let cell = owner.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell else { return }
                cell.isAlarmOn.toggle()
                
            }.disposed(by: self.disposeBag)
        
        self.viewModel.deleteButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                guard
                    let cell = owner.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell,
                    let data = cell.data
                else { return }
                
                AlarmDataManager.shared.delete(data)
                
                let alarmData = AlarmDataManager.shared.fetch()
                owner.viewModel.data.accept(alarmData)
                
            }.disposed(by: self.disposeBag)
        
    }
}
