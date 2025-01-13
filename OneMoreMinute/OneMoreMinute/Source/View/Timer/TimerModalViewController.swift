import UIKit
import SnapKit
import Then

final class TimeModalViewController: UIViewController {
    
    private var initialMinutes: Int
    
    /// 모달의 컨텐츠를 담는 컨테이너 뷰
    private let containerView = UIView().then {
        $0.backgroundColor = Colors.appBackground
        $0.layer.cornerRadius = 24
    }
    
    /// 모달의 제목 레이블
    private let titleLabel = UILabel().then {
        $0.text = "시간 설정"
        $0.font = Fonts.title1Bold
        $0.textAlignment = .left
    }
    
    /// 시간 선택을 위한 피커뷰
    /// - Note: private(set)으로 설정되어 외부에서 읽기만 가능
    private(set) var pickerView = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    
    /// 모달 취소 버튼
    /// - Note: private(set)으로 설정되어 외부에서 읽기만 가능
    private(set) var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(Colors.systemGray(.r800), for: .normal)
        $0.titleLabel?.font = Fonts.title2
        $0.backgroundColor = Colors.systemGray(.r100)
        $0.layer.cornerRadius = 12
    }
    
    /// 시간 설정 확인 버튼
   /// - Note: private(set)으로 설정되어 외부에서 읽기만 가능
    private(set) var confirmButton = UIButton().then {
        $0.setTitle("설정", for: .normal)
        $0.setTitleColor(Colors.appBackground, for: .normal)
        $0.titleLabel?.font = Fonts.title2Bold
        $0.backgroundColor = Colors.systemColor(.r400)
        $0.layer.cornerRadius = 12
    }
    
    /// 취소/확인 버튼을 담는 스택 뷰
    private lazy var buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 10
        $0.addArrangedSubview(cancelButton)
        $0.addArrangedSubview(confirmButton)
    }
    
    /// 초기 시간 값을 받아 View Controller를 초기화하는 생성자
    /// - Parameter initialMinutes: 초기 설정할 시간(분), 기본값 5분
    init(initialMinutes: Int = 5) {
        self.initialMinutes = initialMinutes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI Setup

private extension TimeModalViewController {
    
    /// UI 초기 설정을 위한 메서드들을 호출
    func setupUI() {
        configure()
        setupLayout()
        setupPickerView()
    }
    
    /// 뷰 계층 구조 설정
    func configure() {
        [titleLabel,pickerView,buttonStack].forEach{
            containerView.addSubview($0)
        }
        view.addSubview(containerView)
    }
    
    /// Auto Layout 제약 조건 설정
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(25)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(150)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    /// PickerView의 delegate와 dataSource 설정
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(initialMinutes, inComponent: 0, animated: false)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TimeModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /// PickerView의 컴포넌트(열) 수 반환
    /// - Returns: 항상 1을 반환 (시간 선택만 필요)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// PickerView의 각 컴포넌트별 행 수 반환
    /// - Returns: 60을 반환 (0~59분)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    /// PickerView의 각 행에 표시될 문자열 반환
    /// - Returns: "N분" 형식의 문자열
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Array(1...60)[row])분"
    }
}
