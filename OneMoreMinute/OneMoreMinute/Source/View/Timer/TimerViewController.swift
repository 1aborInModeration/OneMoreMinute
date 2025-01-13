import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class TimerViewController: UIViewController {
    
    // MARK: - RxSwift Properties
    
    /// RxSwift의 메모리 관리를 위한 DisposeBag
    private let disposeBag = DisposeBag()
    /// 타이머의 실행 상태를 관리하는 BehaviorRelay
    private let isRunning = BehaviorRelay<Bool>(value: false)
    /// 타이머의 남은 시간을 관리하는 BehaviorRelay
    private let remainingTime = BehaviorRelay<TimeInterval>(value: 300)
    /// 사용자가 선택한 타이머 시간을 관리하는 BehaviorRelay
    private let selectedTime = BehaviorRelay<TimeInterval>(value: 300)
    /// 타이머 동작을 제어하는 Disposable 객체
    private var timerDisposable: Disposable?
    
    // MARK: - UI Components
    
    /// 타이머 컨텐츠를 담는 컨테이너 뷰
    private let containerView = UIView().then {
        $0.backgroundColor = Colors.appBackground
        $0.layer.cornerRadius = 12
        
        $0.layer.shadowColor = Colors.systemDarkGray.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowOffset = .init(width: 0, height: 10)
        $0.layer.shadowRadius = 10
    }
    
    /// 타이머의 시간을 표시하는 레이블
    private let timeLabel = UILabel().then {
        $0.text = "05:00"
        $0.textAlignment = .center
        $0.font = Fonts.display1Bold
        $0.textColor = Colors.systemColor(.r900)
    }
    
    /// 타이머 시간 설정 버튼
    private let timeSettingButton = UIButton().then {
        $0.setTitle("5분", for: .normal)
        $0.setTitleColor(Colors.systemDarkGray, for: .normal)
        $0.titleLabel?.font = Fonts.title2
        $0.backgroundColor = Colors.systemGray(.r100)
        $0.layer.cornerRadius = 8
    }
    
    /// 타이머 실행  / 일시정지 버튼
    private let playButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.tintColor = Colors.systemColor(.r700)
        $0.backgroundColor = Colors.systemColor(.r50)
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }

    /// 타이머 리셋 버튼
    private let resetButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        $0.tintColor = Colors.systemGray(.r700)
        $0.backgroundColor = Colors.systemGray(.r50)
        $0.layer.cornerRadius = 28
    }
    
    /// 배경 그라데이션 레이어
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGradient()
        setupBindings()
    }
    
    /// 뷰 레이아웃 변경 시 그라데이션 프레임 업데이트
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() /// UIViewController 상속하였기에, override
        gradientLayer.frame = view.bounds
    }

    // MARK: - UI Setup

    private func setupUI() {
        [timeLabel, timeSettingButton, playButton, resetButton,resetButton].forEach { containerView.addSubview($0) }
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(260)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
        
        timeSettingButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.width.equalTo(80)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(timeSettingButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(-40)
            make.width.height.equalTo(56)
        }
        
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.centerX.equalToSuperview().offset(40)
            make.width.height.equalTo(56)
        }
    }
    
    /// 배경 그라데이션 설정
    private func configureGradient() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = [
            UIColor(resource: .appBackgroundStart).cgColor,
            UIColor(resource: .appBackgroundEnd).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    
    /// RxSwift를 사용한 UI 컴포넌트들의 이벤트 바인딩 설정
    private func setupBindings() {
        /// 타이머 실행 중이 아닐 때만 시간 설정 모달을 표시하도록 timeSettingButton tap 이벤트 바인딩
       /// - Note: withLatestFrom으로 현재 타이머 상태를 가져와 실행 중이 아닐 때만 모달 표시 허용
       timeSettingButton.rx.tap
            .withLatestFrom(isRunning)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.showTimePickerModal()
            })
            .disposed(by: disposeBag)
        
        /// 재생/일시정지 버튼의 tap 이벤트 바인딩
       /// - Note: 현재 타이머 상태에 따라 타이머 시작/정지를 토글하고, 남은 시간이 0일 경우 선택된 시간으로 초기화
       playButton.rx.tap
            .withLatestFrom(isRunning)
            .subscribe(onNext: { [weak self] running in
                guard let self = self else { return }
                if running {
                    stopTimer()
                } else {
                    if self.remainingTime.value == 0 {
                        self.remainingTime.accept(self.selectedTime.value)
                    }
                    startTimer()
                }
                self.isRunning.accept(!running)
            })
            .disposed(by: disposeBag)
        
        /// 리셋 버튼의 tap 이벤트 바인딩
       /// - Note: 타이머를 정지하고 선택된 시간으로 초기화하며 실행 상태를 false로 설정
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                stopTimer()
                remainingTime.accept(self.selectedTime.value)
                isRunning.accept(false)
            })
            .disposed(by: disposeBag)
        
        /// 남은 시간을 "MM:SS" 형식의 문자열로 변환하여 timeLabel에 표시하는 바인딩
        remainingTime
            .map { time -> String in
                let minutes = Int(time) / 60
                let seconds = Int(time) % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        /// 선택된 시간을 "N분" 형식의 문자열로 변환하여 timeSettingButton의 타이틀로 설정하는 바인딩
        selectedTime
            .map { time -> String in
                let minutes = Int(time) / 60
                return "\(minutes)분"
            }
            .bind(to: timeSettingButton.rx.title())
            .disposed(by: disposeBag)
        
        /// 타이머 실행 상태에 따라 UI를 업데이트하는 바인딩
        /// - Note: 실행 중일 때는 일시정지 아이콘을 표시하고 시간 설정 버튼을 숨김
        isRunning
            .subscribe(onNext: { [weak self] isRunning in
                guard let self = self else { return }
                let image = isRunning ? UIImage(systemName: "pause") : UIImage(systemName: "play")
                playButton.setImage(image, for: .normal)
                timeSettingButton.isHidden = isRunning
            })
            .disposed(by: disposeBag)
    }
    
    /// 타이머 시작 메소드
    /// - Note: 1초 간격으로 remainingTime을 감소시킵니다.
    private func startTimer() {
        timerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let newTime = self.remainingTime.value - 1
                remainingTime.accept(newTime)
            })
    }
    
    /// 타이머 정지 메소드
    /// - Note: timerDisposable을 해제하고 nil로 설정힙니다.
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    /// 시간 선택 모달 표시 메소드
    /// - Note: 현재 선택된 시간을 기반으로 모달을 표시하고, 확인/취소 버튼에 대한 이벤트를 처리
    func showTimePickerModal() {
        // 현재 설정된 초딘위 시간을 분 단위로 변환
        let currentMinutes = Int(selectedTime.value / 60)
        let modalVC = TimeModalViewController(initialMinutes: currentMinutes)
        modalVC.modalPresentationStyle = .overFullScreen
        
        present(modalVC, animated: true)
        
        /// 취소 버튼 탭 이벤트에 대한 바인딩
       /// - Note: 모달을 닫고 백그라운드 뷰를 숨김 처리
        modalVC.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 확인 버튼 탭 이벤트에 대한 바인딩
        /// - Note: 선택된 시간을 초 단위로 변환하여 타이머에 적용
        /// - Note: selectedTime과 remainingTime을 업데이트하고 모달을 닫음
        modalVC.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 선택된 행에 1을 더해 1분부터 시작하도록 설정
                let currentSeconds = (modalVC.pickerView.selectedRow(inComponent: 0)+1) * 60
                selectedTime.accept(TimeInterval(currentSeconds))
                remainingTime.accept(TimeInterval(currentSeconds))
                
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    return TimerViewController()
}
