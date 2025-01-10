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
        layout.minimumLineSpacing = 10 // 셀 간 간격
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 80, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LapCollectionViewCell.self, forCellWithReuseIdentifier: LapCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - RxSwift Properties
    private let disposeBag = DisposeBag()
    private let isRunning = BehaviorRelay<Bool>(value: false)
    private let elapsedTime = BehaviorRelay<TimeInterval>(value: 0)
    private let laps = BehaviorRelay<[(String, String)]>(value: [])
    
    private var timerDisposable: Disposable?
    
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
    
    // MARK: - Handle Trait Collection Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 다크 모드 및 기타 환경 변화 감지
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateContainerLayerColors() // 색상 업데이트
            configureGradient() // 그라디언트 업데이트
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
//        view.backgroundColor = UIColor(resource: .appBackgroundEnd)
        
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
    
    // MARK: - Layer Colors Update
    private func updateContainerLayerColors() {
        // 다크 모드와 라이트 모드에 따라 색상을 다시 설정
        containerView.layer.shadowColor = UIColor.black.cgColor // 다크 모드에선 그대로 사용
        containerView.layer.borderColor = UIColor(resource: .wrapperStroke).cgColor
    }
    
    // MARK: - Gradient Configuration
    private func configureGradient() {
        gradientLayer.colors = [
            UIColor(resource: .appBackgroundStart).cgColor,
            UIColor(resource: .appBackgroundEnd).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    // MARK: - RxSwift Bindings
    private func setupBindings() {
        // Play button tap handling
        playButton.rx.tap
            .withLatestFrom(isRunning)
            .subscribe(onNext: { [weak self] running in
                guard let self = self else { return }
                if running {
                    self.stopTimer()
                } else {
                    self.startTimer()
                }
                self.isRunning.accept(!running)
            })
            .disposed(by: disposeBag)
        
        // Reset button tap handling
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.stopTimer()
                self.elapsedTime.accept(0)
                self.laps.accept([])
                self.isRunning.accept(false)
            })
            .disposed(by: disposeBag)
        
        // Update timeLabel with elapsed time
        elapsedTime
            .map { elapsedTime in
                let minutes = Int(elapsedTime) / 60
                let seconds = elapsedTime.truncatingRemainder(dividingBy: 60)
                return String(format: "%02d:$05.2f", minutes, seconds)
            }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Lap handling (add current time to laps)
        playButton.rx.tap
            .withLatestFrom(isRunning)
            .filter { $0 } // Only add lap when timer is running
            .withLatestFrom(elapsedTime)
            .subscribe(onNext: { [weak self] elapsedTime in
                guard let self = self else { return }
                let lapTime = String(format: "$02d:$05.2f", Int(elapsedTime / 60), elapsedTime.truncatingRemainder(dividingBy: 60))
                var currentLaps = self.laps.value
                currentLaps.insert(("랩 \(currentLaps.count + 1)", lapTime), at: 0)
                self.laps.accept(currentLaps)
            })
            .disposed(by: disposeBag)
        
        // Bind laps to collectionView using RxDataSources
        laps.bind(to: collectionView.rx.items(cellIdentifier: LapCollectionViewCell.identifier, cellType: LapCollectionViewCell.self)) { _, data, cell in
            cell.configure(with: data.0, time: data.1)
        }
        .disposed(by: disposeBag)
    }
    
    private func startTimer() {
        timerDisposable = Observable<Int>.interval(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.elapsedTime.accept(self.elapsedTime.value + 0.01)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
}

@available(iOS 17.0, *)
#Preview {
    return StopwatchViewController()
}
