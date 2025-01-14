//
//  SearchCityModalViewController.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/13/25.
//

import UIKit
import SnapKit
import MapKit
import RxSwift
import RxCocoa


class SearchCityModalViewController: UIViewController, ModalCloseDelegate {
    
    // MARK: - Properties

    var dismissCompletion: (() -> Void)?
    let searchCityView = SearchCityView()
    let searchCityViewModel = SearchCityViewModel()
    
    let disposeBag = DisposeBag()

    // MARK: - init & Life cyclesas

    init( ) {
        super.init(nibName: nil, bundle: nil)
        
        searchCityView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupTargetView()
        setupBindings()
    }
    
    /// 모달이 화면에 나타날 때 호출
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// 모달이 사라질 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed {
            dismissCompletion?()
        }
    }
}

// MARK: - Setup UI Layouts

extension SearchCityModalViewController {
    
    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    private func setupTargetView() {
        view.addSubview(searchCityView)
        searchCityView.translatesAutoresizingMaskIntoConstraints = false
        
        searchCityView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(500)
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
    }
}

// MARK: - Binding

extension SearchCityModalViewController {
    
    func setupBindings() {
        searchCityView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter {
                return $0.count > 1
            }
            .subscribe(
                onNext: { [weak self] query in
                    self?.searchCityViewModel.searchCities(with: query)
                }
            )
            .disposed(by: disposeBag)
        
        searchCityViewModel.cityListRelay
            .bind(to: searchCityView.cityListCollectionView.rx.items(
                cellIdentifier: CityListCell.id,
                cellType: CityListCell.self
            )) { index, cityTimeZone, cell in
                cell.configure(with: cityTimeZone)
            }
            .disposed(by: disposeBag)
        
        searchCityView.cityListCollectionView.rx
            .itemSelected
            .withLatestFrom(searchCityViewModel.cityListRelay) { (indexPath, cityList) in
                cityList[indexPath.row]
            }
            .subscribe(onNext: { [weak self] cityTimeZone in
                self?.searchCityViewModel.saveCity(cityTimeZone: cityTimeZone)
                self?.closeModal()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Action Management & Mapping

extension SearchCityModalViewController {
    
    func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
