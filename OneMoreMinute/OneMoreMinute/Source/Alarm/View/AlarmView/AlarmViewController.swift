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
    
    // MARK: - AlarmViewController Rx Properties
    
    private let disposeBag = DisposeBag()
    private let alarmToggleButtonTapped = PublishRelay<IndexPath>()
    private let deleteButtonTapped = PublishRelay<IndexPath>()
    private let saveButtonTapped = PublishRelay<CGPoint>()
        
    // MARK: - AlarmViewController UI
    
    private let alarmView = AlarmView()
        
    private let showModalButton = ShowModalButton()
    
    // 모달뷰가 열렸을 때 뒤를 가려줄 뷰
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.alpha = 0
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
        configureSelf()
        setupLayout()
        bind()
    }
    
    func configureSelf() {
        self.view = self.alarmView
        self.view.addSubview(self.showModalButton)
    }
    
    func setupLayout() {
        self.showModalButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Layouts.padding)
            make.trailing.equalToSuperview().inset(Layouts.padding)
            make.width.height.equalTo(Layouts.buttonHeight)
        }
    }
    
    /// 삭제 확인 알럿을 Present하는 메소드
    /// - Parameter data: 삭제할 데이터
    func confirmDeleteAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "경고", message: "정말 알람을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
            self?.deleteButtonTapped.accept(indexPath)
        }))
        self.present(alert, animated: true)
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
            
            cell.alarmButton.rx.tap
                .map { indexPath }
                .asDriver(onErrorDriveWith: .empty())
                .drive {
                    
                    self.alarmToggleButtonTapped.accept($0)
                    
                }.disposed(by: cell.disposeBag)
            
            cell.deleteButton.rx.tap
                .map { indexPath }
                .asDriver(onErrorDriveWith: .empty())
                .drive {
                 
                    self.confirmDeleteAlert($0)
                    
                }.disposed(by: cell.disposeBag)
            
            return cell
        })
    }
    
    /// 모든 바인딩 메소드를 실행하는 메소드
    func bind() {
        bindData()
        bindShowModalButton()
        bindCellSelect()
    }
    
    /// 컬렉션뷰의 데이터소스와 바인딩하는 메소드
    func bindData() {
        let input = AlarmViewModel.Input(
            alarmToggleButtonTapped: self.alarmToggleButtonTapped,
            deleteButtonTapped: self.deleteButtonTapped,
            saveButtonTapped: self.saveButtonTapped
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.dataRelay
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.alarmView.collectionView.rx.items(dataSource: self.datasource))
            .disposed(by: self.disposeBag)
        
        output.reloadIndex
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                owner.alarmView.collectionView.reloadItems(at: [indexPath])
                owner.alarmView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                
            }.disposed(by: self.disposeBag)
        
        output.deleteIndex
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, indexPath in
                
                let indexPaths = owner.alarmView.collectionView.indexPathsForVisibleItems
                if indexPaths.contains(indexPath) {
                    owner.alarmView.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                } else {
                    guard let lastIndex = indexPaths.last else { return }
                    owner.alarmView.collectionView.scrollToItem(at: lastIndex, at: .top, animated: true)
                }
                
            }.disposed(by: self.disposeBag)
        
        output.scrollIndex
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, location in
                
                owner.alarmView.collectionView.setContentOffset(location, animated: true)
                
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
                
                owner.showModal(.create, data: nil)
                
            }.disposed(by: self.disposeBag)
    }
    
    /// 모달뷰를 Present하는 메소드
    /// - Parameters:
    ///   - state: 모달뷰의 state
    ///   - data: 모달뷰에 넘길 데이터(edit일 때만)
    func showModal(_ state: AlarmModalState, data: Alarm?) {
        let modalVC = AlarmModalViewController(state: state, data: data)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
            guard let topView = AppHelpers.getTopViewController() else { return }
            topView.view.addSubview(self.backgroundView)
            self.backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.backgroundView.alpha = 1
        }
        
        modalVC.modalPresentationStyle = .overFullScreen
        self.present(modalVC, animated: true)
        
        self.modalViewBind(modalVC)
    }
    
    func dismissBackgroundView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
            self.backgroundView.removeFromSuperview()
            self.backgroundView.snp.removeConstraints()
            self.backgroundView.alpha = 0
        }
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
                
                owner.dismissBackgroundView()
                modalVC.dismiss(animated: true)
                
            }.disposed(by: modalVC.disposeBag)
        
        modalVC.modalView.saveButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.dismissBackgroundView()
                
                switch modalVC.state {
                case .create:
                    owner.viewModel.dataFetch()
                    let currentOffset = owner.alarmView.collectionView.contentOffset.y
                    let contentSizeY = owner.alarmView.collectionView.contentSize.height
                    let frameSize = owner.alarmView.collectionView.frame.height
                    let maxY = contentSizeY - frameSize
                    
                    if currentOffset < maxY {
                        let location = CGPoint(x: 0, y: maxY)
                        owner.alarmView.collectionView.setContentOffset(location, animated: true)
                    }
                    
                case .edit:
                    let location = owner.alarmView.collectionView.contentOffset
                    owner.saveButtonTapped.accept(location)
                }
                
                modalVC.dismiss(animated: true)
                
            }.disposed(by: modalVC.disposeBag)
        
        modalVC.modalView.closeButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.dismissBackgroundView()
                modalVC.dismiss(animated: true)
                
            }.disposed(by: modalVC.disposeBag)
        
        modalVC.modalView.cancelButton.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .withUnretained(self)
            .emit { owner, _ in
                
                owner.dismissBackgroundView()
                modalVC.dismiss(animated: true)
                
            }.disposed(by: modalVC.disposeBag)
    }

}
