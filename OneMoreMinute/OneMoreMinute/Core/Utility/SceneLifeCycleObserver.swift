//
//  SceneLifeCycleObserver.swift
//  OneMoreMinute
//
//  Created by DoyleHWorks on 2025-01-14.
//

import RxRelay

enum AppState {
    case willEnterForeground
    case didEnterBackground
}

/// 앱의 생명주기 상태 변화를 관찰하고 이를 전달하는 싱글톤 클래스입니다.
final class SceneLifeCycleObserver {
    static let shared = SceneLifeCycleObserver()
    private init() {}
    
    let appStateRelay = PublishRelay<AppState>()
    
    func switchAppState(into state: AppState) {
        appStateRelay.accept(state)
    }
}
