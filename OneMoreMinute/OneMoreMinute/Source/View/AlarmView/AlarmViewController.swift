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

/// 알람 뷰 컨트롤러
final class AlarmViewController: UIViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<AlarmSectionModel>
    private lazy var datasource = self.makeDataSource()
    
    private let viewModel = AlarmViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let repository = AlarmDataManager.shared
    
    private let alarmView = AlarmView()
        
    private let showModalButton = ShowModalButton()
    
    // 모달뷰가 열렸을 때 뒤를 가려줄 뷰
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isHidden = true
    }
    
    // MARK: - AlarmViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - AlarmViewController UI Setting Method
private extension AlarmViewController {
    
    func setupUI() {
        configure()
        setupLayout()
        bind()
    }
    
    func configure() {
        self.view = self.alarmView
        self.view.addSubview(self.showModalButton)
    }
    
    func setupLayout() {
        self.showModalButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
    }
    
    /// 컬렉션뷰의 데이터소스를 만드는 메소드
    /// - Returns: RxCollectionViewSectionedAnimatedDataSource
    ///
    /// ``AlarmSectionModel``
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
    
    /// 모든 바인딩 메소드를 실행하는 메소드
    func bind() {
        bindData()
        bindAlarmOnButton()
        bindDeleteButton()
        bindShowModalButton()
        bindCellSelect()
    }
    
    /// 컬렉션뷰의 데이터소스와 바인딩하는 메소드
    func bindData() {
        // 데이터소스와 바인딩
        self.viewModel.dataRelay
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.alarmView.collectionView.rx.items(dataSource: self.datasource))
            .disposed(by: self.disposeBag)
        
        // 데이터소스에서 이벤트가 방출되었을 때 UI 업데이트
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
    
    /// 알람 버튼을 탭 이벤트 바인딩 메소드
    ///
    /// 코어데이터에 isActive 속성 업데이트
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
    
    /// 삭제 버튼 탭 액션 바인딩 메소드
    ///
    /// 삭제 버튼을 선택시 Alert으로 경고 후 최종 삭제 결정
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
    
    /// 셀 선택 액션 바인딩 메소드
    ///
    /// 셀 선택시 데이터 수정을 위한 모달 뷰 Present
    func bindCellSelect() {
        self.alarmView.collectionView.rx.itemSelected
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                guard
                    let cell = owner.alarmView.collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell,
                    let data = cell.data
                else { return }
                
                guard let topView = AppHelpers.getTopViewController() else { return }
                topView.view.addSubview(owner.backgroundView)
                owner.backgroundView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                owner.showModal(.edit, data: data)
                
            }.disposed(by: self.disposeBag)
    }
    
    /// +버튼의 탭 액션 바인딩 메소드
    ///
    /// 새로운 알람을 추가하기 위한 모달 뷰 Present
    func bindShowModalButton() {
        self.showModalButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                guard let topView = AppHelpers.getTopViewController() else { return }
                topView.view.addSubview(owner.backgroundView)
                owner.backgroundView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                owner.showModal(.create, data: nil)
                
            }.disposed(by: self.disposeBag)
    }
    
    /// 삭제 확인 알럿을 Present하는 메소드
    /// - Parameter data: 삭제할 데이터
    func confirmDeleteAlert(delete data: Alarm) {
        let alert = UIAlertController(title: "경고", message: "정말 알람을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
            self?.repository.delete(data)
            self?.viewModel.dataFetch()
        }))
        self.present(alert, animated: true)
    }
    
    /// 모달뷰를 Present하는 메소드
    /// - Parameters:
    ///   - state: 모달뷰의 state
    ///   - data: 모달뷰에 넘길 데이터(edit일 때만)
    func showModal(_ state: AlarmModalState, data: Alarm?) {
        let modalVC = AlarmModalViewController(state: state, data: data)
        
        self.backgroundView.isHidden = false
        
        modalVC.modalPresentationStyle = .overFullScreen
        self.present(modalVC, animated: true)
        
        self.modalViewBind(modalVC)
    }
    
    /// 모달뷰의 데이터 바인딩 메소드
    /// - Parameter vc: 모달뷰 컨트롤러
    func modalViewBind(_ vc: UIViewController) {
        guard let modalVC = vc as? AlarmModalViewController else { return }
        
        modalVC.backgroundTapped
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, tap in
                guard tap else { return }
                
                owner.backgroundView.removeFromSuperview()
                owner.backgroundView.snp.removeConstraints()
                modalVC.dismiss(animated: true)
                owner.backgroundView.isHidden = true
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.saveButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.backgroundView.removeFromSuperview()
                owner.backgroundView.snp.removeConstraints()
                modalVC.dismiss(animated: true)
                owner.backgroundView.isHidden = true
                owner.viewModel.dataFetch()
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.closeButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.backgroundView.removeFromSuperview()
                owner.backgroundView.snp.removeConstraints()
                owner.backgroundView.isHidden = true
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
        
        modalVC.modalView.cancelButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.backgroundView.removeFromSuperview()
                owner.backgroundView.snp.removeConstraints()
                owner.backgroundView.isHidden = true
                modalVC.dismiss(animated: true)
                
            }.disposed(by: self.disposeBag)
    }

}
