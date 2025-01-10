//
//  AlarmViewController.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import UIKit
import SnapKit
import Then
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
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isHidden = true
    }
    
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
        [self.showModalButton,
         self.backgroundView].forEach { self.view.addSubview($0) }
    }
    
    func setupLayout() {
        self.showModalButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        self.viewModel.dataRelay
            .asDriver(onErrorDriveWith: .empty())
            .compactMap { $0.first?.items }
            .map { items -> [Alarm] in
                var alarms: [Alarm] = []
                items.forEach {
                    alarms.append($0.data)
                }
                return alarms
            }
            .drive { [weak self] data in
                
                data.enumerated().forEach { index, data in
                    let indexPath = IndexPath(item: index, section: 0)
                    guard let cell = self?.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell else { return }
                    cell.configCell(data)
                }
                
            }.disposed(by: self.disposeBag)
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
                
                owner.showModal(.edit, data: data)
                
            }.disposed(by: self.disposeBag)
    }
    
    func bindShowModalButton() {
        self.showModalButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.showModal(.crate, data: nil)
                
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
    
    func showModal(_ state: AlarmModalState, data: Alarm?) {
        let modalVC = AlarmModalViewController(state: state, data: data)
        
        self.backgroundView.isHidden = false
        
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
                
                owner.backgroundView.isHidden = true
                
                owner.viewModel.dataFetch()
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.closeButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.backgroundView.isHidden = true
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.cancleButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.backgroundView.isHidden = true
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
    }

}
