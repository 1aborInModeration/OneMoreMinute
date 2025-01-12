//
//  StopwatchViewController.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class StopwatchViewController: UIViewController {
    
    // MARK: - UI Components
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(resource: .wrapperBackground)
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.layer.borderColor = UIColor(resource: .wrapperStroke).cgColor
        $0.layer.borderWidth = 1
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "00:00.00"
        $0.font = UIFont.pretendard(ofSize: 48, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = UIColor(resource: .mainTitle)
    }
    
    private let playButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.tintColor = UIColor(resource: .subTitle)
        $0.backgroundColor = UIColor(resource: .buttonBackground)
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    
    private let resetButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        $0.tintColor = UIColor(resource: .grayButtonLabel)
        $0.backgroundColor = UIColor(resource: .grayButtonBackground)
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 80, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LapCollectionViewCell.self, forCellWithReuseIdentifier: LapCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Properties
    private let viewModel = StopwatchViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGradient()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateContainerLayerColors()
            configureGradient()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(containerView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(resetButton)
        view.addSubview(collectionView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(235)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview().offset(-40)
            make.width.height.equalTo(56)
        }
        
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.centerX.equalToSuperview().offset(40)
            make.width.height.equalTo(56)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateContainerLayerColors() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.borderColor = UIColor(resource: .wrapperStroke).cgColor
    }
    
    private func configureGradient() {
        gradientLayer.colors = [
            UIColor(resource: .appBackgroundStart).cgColor,
            UIColor(resource: .appBackgroundEnd).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    // MARK: - Rx Bindings
    private func setupBindings() {
        // Bind elapsed time
        viewModel.elapsedTimeRelay
            .map { elapsedTime in
                let minutes = Int(elapsedTime) / 60
                let seconds = elapsedTime.truncatingRemainder(dividingBy: 60)
                return String(format: "%02d:%05.2f", minutes, seconds)
            }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Bind laps
        viewModel.lapsRelay
            .bind(to: collectionView.rx.items(cellIdentifier: LapCollectionViewCell.identifier, cellType: LapCollectionViewCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel)
            }
            .disposed(by: disposeBag)
        
        // Play button tap
        playButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleTimer()
            })
            .disposed(by: disposeBag)
        
        // Reset button tap
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.resetOrAddLap()
            })
            .disposed(by: disposeBag)
        
        // Update button states
        viewModel.isRunningRelay
            .subscribe(onNext: { [weak self] isRunning in
                self?.updateButtonStates(isRunning: isRunning)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateButtonStates(isRunning: Bool) {
        if isRunning {
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
            resetButton.setImage(UIImage(systemName: "flag"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
            resetButton.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        }
    }
}
