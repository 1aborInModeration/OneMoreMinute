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
    
    private let repository = AlarmDataManager.shared
    
    private let alarmView = AlarmView()
        
    private let showModalButton = ShowModalButton()
    
    private lazy var datasource = self.makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.dataFetch()
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
        bindShowModalButton()
        bindCellSelect()
    }
    
    func bindData() {
        self.viewModel.dataRelay
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
                
                owner.repository.update(id, updateData: data)
                
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
                
                owner.confirmDeleteAlert(delete: data)
                
            }.disposed(by: self.disposeBag)
    }
    
    func bindCellSelect() {
        self.alarmView.collectionView.rx.itemSelected
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                guard
                    let cell = owner.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell,
                    let data = cell.data
                else { return }
                
                owner.showModal(.edit)
                
            }.disposed(by: self.disposeBag)
    }
    
    func bindShowModalButton() {
        self.showModalButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.showModal(.crate)
                
            }.disposed(by: self.disposeBag)
    }
    
    func confirmDeleteAlert(delete data: Alarm) {
        let alert = UIAlertController(title: "경고", message: "정말 알람을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
            self?.repository.delete(data)
            self?.viewModel.dataFetch()
        }))
        self.present(alert, animated: true)
    }
    
    func showModal(_ state: AlarmModalState) {
        let modalVC = AlarmModalViewController(state: state)
        
        modalVC.modalPresentationStyle = .overFullScreen
        self.present(modalVC, animated: true)
        
        self.modalViewBind(modalVC)
    }
    
    func modalViewBind(_ vc: UIViewController) {
        guard let modalVC = vc as? AlarmModalViewController else { return }
        
        modalVC.modalView.saveButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                modalVC.dismiss(animated: true)
                
                owner.viewModel.dataFetch()
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.closeButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.cancleButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
    }

}
