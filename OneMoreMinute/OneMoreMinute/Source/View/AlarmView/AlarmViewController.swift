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
    
    private let showModalButton = ShowModalButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

private extension AlarmViewController {
    
    func setupUI() {
        configure()
        setupLayout()
        bind()
    }
    
    func configure() {
        self.view = self.alarmView
        self.view.addSubview(showModalButton)
    }
    
    func setupLayout() {
        self.showModalButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
    }
    
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
                
                guard
                    let id = cell.data?.objectID,
                    let data = cell.updateAlarmIsOn()
                else { return }
                AlarmDataManager.shared.update(id, updateData: data)
                
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
