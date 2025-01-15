# 📱 OneMoreMinute
![image](https://github.com/user-attachments/assets/3befc632-93f3-4bbb-a4f5-7f1345d2bdb6)

알람, 세계시간, 스톱워치, 타이머 기능을 제공하는 iOS 앱 프로젝트

## 📚 Tech Stacks
<div>
  <a href="https://developer.apple.com/xcode/" target="_blank">
    <img src="https://img.shields.io/badge/Xcode_16.1-147EFB?style=for-the-badge&logo=xcode&logoColor=white" alt="Xcode">
  </a>
  <a href="https://swift.org/" target="_blank">
    <img src="https://img.shields.io/badge/Swift_5-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  </a>
  <a href="https://developer.apple.com/documentation/uikit" target="_blank">
    <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=uikit&logoColor=white" alt="UIKit">
  </a>
  <a href="https://github.com/SnapKit/SnapKit" target="_blank">
    <img src="https://img.shields.io/badge/SnapKit-00aeb9?style=for-the-badge&logoColor=white" alt="SnapKit">
  </a>
  <a href="https://github.com/devxoul/Then" target="_blank">
    <img src="https://img.shields.io/badge/Then-00aeb9?style=for-the-badge&logoColor=white" alt="Then">
  </a>
  <br> 
  <a href="https://github.com/ReactiveX/RxSwift" target="_blank">
    <img src="https://img.shields.io/badge/reactivex-B7178C?style=for-the-badge&logoColor=white" alt="reactivex">
  </a>
  <a href="https://github.com/RxSwiftCommunity/RxDataSources" target="_blank">
    <img src="https://img.shields.io/badge/rxdatasources-B7178C?style=for-the-badge&logoColor=white" alt="rxdatasources">
  </a>
    <a href="https://github.com/RxSwiftCommunity/RxKeyboard" target="_blank">
    <img src="https://img.shields.io/badge/rxkeyboard-B7178C?style=for-the-badge&logoColor=white" alt="rxkeyboard">
  </a>
  <br>
  <a href="https://www.gitkraken.com/" target="_blank">
    <img src="https://img.shields.io/badge/gitkraken-179287?style=for-the-badge&logo=gitkraken&logoColor=white" alt="GitKraken">
  </a>
  <a href="https://github.com/" target="_blank">
    <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
  <br>
</div>

## 👥 The Team
| Name     | GitHub   | Roles    | Main Developments |
|:--------:| -------- | -------- |:-----------------:|
| 권승용 <br> Seung-Yong Kwon | [@ericKwon95](https://github.com/ericKwon95) | MVVM Architecture Designer | MainTabBarViewController <br> Alarm and Core Services |
| 김형석 <br> Hyeong-Seok Kim | [@NeoSelf1](https://github.com/NeoSelf1) | RxSwift Flow Manager | TimerViewController <br> Code Convention Review |
| 임성수 <br> Seong-Soo Lim | [@seongto](https://github.com/seongto) | UI Components Manager | WorldTimeViewController <br> Utility and Helper Services |
| 장상경 <br> Sang-Kyeong Jang | [@Crois0509](https://github.com/Crois0509) | CoreData Manager | AlarmViewController <br> App UI and Icon Designs |
| 황도일 <br> Doyle Hwang | [@DoyleHWorks](https://github.com/DoyleHWorks) | GitHub/Docs Manager | StopwatchViewController <br> Project Initialization |

## ⏰ Project Scope
- **시작일**: 2025/01/07 (화)
- **종료일**: 2025/01/15 (수)

## 📂 Folder Organization
```bash
OneMoreMinute/
├── App/                  # 애플리케이션 설정 및 메타 데이터
│   ├── AppDelegate       # 앱의 생명주기 및 초기화 관리
│   ├── Info.plist        # 앱의 설정 정보
│   ├── LaunchScreen      # 앱 실행 시 로딩 화면
│   ├── OneMoreMinute.entitlements  # 앱 권한 및 특정 기능 활성화 설정
│   ├── OneMoreMinute.xcdatamodeld  # Core Data 모델
│   └── SceneDelegate     # Scene 생명주기 관리
├── Resource/             # 앱의 Asset 파일들
└── Source/               # 기능별 애플리케이션 로직
    ├── Core/             # 공통 로직 및 서비스
    │   ├── Extension/    # 시스템 클래스 확장
    │   ├── Manager/      # 공통 기능 관리 (AlarmManager, TimeManager, RepositoryManager 등)
    │   ├── Protocol/     # 공통 프로토콜 (CoreDataProtocol, ModalProtocol, ViewModelType)
    │   ├── Theme/        # 앱의 테마 정의 (Colors, Fonts, Layouts)
    │   └── Utility/      # 공통 유틸리티 (AppHelpers, HapticService, SceneLifeCycleObserver 등)
    ├── Feature/          # 기능별 화면 및 로직
    │   ├── Alarm/        # 알람 기능
    │   ├── MainTab/      # 메인 탭바 기능
    │   ├── Stopwatch/    # 스톱워치 기능
    │   ├── Timer/        # 타이머 기능
    │   └── WorldTime/    # 세계시간 기능
    └── UIComponent/      # 공통 UI 컴포넌트들
OneMoreMinuteTests/       # 단위 테스트 및 테스트 코드 (TimeManagerTests)
```

## 🖼️ Preview
|![Simulator Screen Recording - iPhone 16 Pro - 2025-01-15 at 14 09 41](https://github.com/user-attachments/assets/fdfdc3d8-030e-474a-90c2-35b314699a3b)|![Simulator Screen Recording - iPhone 16 Pro - 2025-01-15 at 14 10 45](https://github.com/user-attachments/assets/6c4052be-7521-479d-a952-4d44152c039a)|![Simulator Screen Recording - iPhone 16 Pro - 2025-01-15 at 14 11 10](https://github.com/user-attachments/assets/61a0469f-3774-45e5-8e26-9cf9c6c18491)|![Simulator Screen Recording - iPhone 16 Pro - 2025-01-15 at 14 12 31](https://github.com/user-attachments/assets/463cd64d-af21-421c-8c3d-171a7bd887af)|
|-|-|-|-|

## 🏷 Main Features
#### 알람 기능
- 사용자가 원하는 시간에 알람을 설정하고 관리할 수 있습니다.
- 반복 알람 설정 기능을 제공합니다.

#### 세계시간 기능
- 다양한 도시의 현재 시간을 확인할 수 있습니다.
- 사용자가 관심이 있는 도시를 추가하고 목록을 관리할 수 있습니다.

#### 스톱워치 기능
- 시간 측정 시작, 일시정지, 재개 및 초기화 기능을 제공합니다.
- 랩 타임 측정 및 기록이 가능하고 베스트 랩과 워스트 랩을 한 눈에 보여줍니다.

#### 타이머 기능
- 사용자가 원하는 시간으로 타이머를 설정하고 시작할 수 있습니다.
- 타이머 종료 시 알림을 제공합니다.

## ✨ Considerations
#### MVVM 아키텍처와 RxSwift
- MVVM 아키텍처를 채택하여 코드의 모듈화와 유지 보수성을 향상시켰습니다.
- RxSwift를 활용하여 비동기 데이터 흐름과 바인딩을 구현하였습니다.

#### 재사용성 높은 개발 
- 앱 전반에 걸쳐 일관된 디자인을 유지하기 위해 공용 테마를 정의하고, 재사용 가능한 UI 컴포넌트를 분리하였습니다.
- 유틸리티, 매니저 등을 코어 서비스로 분리하여 구현하였습니다.

#### CoreData & UserDefaults 관리
- 사용자 데이터와 설정을 효율적으로 저장하고 관리하기 위해 CoreData와 UserDefaults를 활용하였습니다.
- 알람과 세계시간 기능은 CoreData를 사용하고 스톱워치 기능은 UserDefaults를 사용하였습니다.

#### 배너 알림 기능 및 백그라운드 플로우 구현
- 앱 내에서 중요한 정보를 사용자에게 전달하기 위해 배너 알림 기능을 구현하였습니다.
- SceneDelegate의 Lifecycle을 통해 스톱워치 등의 백그라운드 플로우를 구현하였습니다.

#### 디바이스 리소스 효율
- 세계시간 기능을 외부 API를 이용하지 않고 내부 로직으로 구현하여 네트워크 사용을 최소화하였습니다.
- 메모리 누수 방지뿐만 아니라 메모리 효율적인 코드를 작성하기 위해 지속적으로 검토하고 최적화하였습니다.

## 📦 How to Install  
1. Clone this repository:  
   ```bash  
   git clone https://github.com/1aborInModeration/OneMoreMinute.git  
   ```  
