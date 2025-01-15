//
//  MainTabViewModel.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/9/25.
//

import Foundation
import RxSwift
import RxRelay

/// viewDidLoad 시 시간과 날짜를 방출하는 뷰모델
/// MainTabBarController에서 사용
final class MainTabViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let currentTime: Observable<String>
        let currentDate: Observable<String>
    }
    
    let timeManager = TimeManager()
    let disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        timeManager.updateCurrentTime()
        timeManager.updateCurrentDate()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.timeManager.startTimeUpdates()
            })
            .disposed(by: disposeBag)
        
        return Output(
            currentTime: timeManager.timeRelay.asObservable(),
            currentDate: timeManager.dateRelay.asObservable()
        )
    }
}

