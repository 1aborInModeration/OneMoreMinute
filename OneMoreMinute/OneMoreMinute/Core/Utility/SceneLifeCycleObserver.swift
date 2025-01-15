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

final class SceneLifeCycleObserver {
    static let shared = SceneLifeCycleObserver()
    private init() {}
    
    let appStateRelay = PublishRelay<AppState>()
    
    func switchAppState(into state: AppState) {
        appStateRelay.accept(state)
    }
}
