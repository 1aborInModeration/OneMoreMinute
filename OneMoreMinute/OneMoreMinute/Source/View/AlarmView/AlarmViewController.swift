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
import RxDataSources

final class AlarmViewController: UIViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<AlarmSectionModel>
    
    private let viewModel = AlarmViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let alarmView = AlarmView()
    
    private let showModalButton = ShowModalButton()
    
    private lazy var datasource = self.makeDataSource()
    
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
    
    func makeDataSource() -> DataSource {
        return DataSource(configureCell: { [weak self] datasource, collectionView, indexPath, item in
            guard
                let self,
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlarmCollectionViewCell.id,
                    for: indexPath
                ) as? AlarmCollectionViewCell
            else { return .init() }
            
            cell.configCell(item.data)
            
            cell.alarmButtonTapped
                .map { indexPath }
                .bind(to: self.viewModel.alarmButtonTapped)
                .disposed(by: self.disposeBag)
            
            cell.deleteButtonTapped
                .map { indexPath }
                .bind(to: self.viewModel.deleteButtonTapped)
                .disposed(by: self.disposeBag)
            
            return cell
        })
    }
    
    func bind() {
        bindData()
        bindAlarmOnButton()
        bindDeleteButton()
    }
    
    func bindData() {
        self.viewModel.data
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.alarmView.collectionView.rx.items(dataSource: self.datasource))
            .disposed(by: self.disposeBag)
    }
    
    func bindAlarmOnButton() {
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
    }
    
    func bindDeleteButton() {
        self.viewModel.deleteButtonTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                guard
                    let cell = owner.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell,
                    let data = cell.data
                else { return }
                
                AlarmDataManager.shared.delete(data)
                
                owner.viewModel.dataFetch()
                
            }.disposed(by: self.disposeBag)
    }
}
