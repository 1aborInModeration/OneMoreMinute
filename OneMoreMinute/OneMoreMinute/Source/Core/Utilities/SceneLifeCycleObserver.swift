//
//  SceneLifeCycleObserver.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-14.
//

import RxRelay

final class SceneLifeCycleObserver {
    static let shared = SceneLifeCycleObserver()
    private init() {}
    
    let sceneWillEnterForegroundRelay = PublishRelay<Void>()
    let sceneDidEnterBackgroundRelay = PublishRelay<Void>()
    
    func sceneWillEnterForeground() {
        sceneWillEnterForegroundRelay.accept(())
    }
    
    func sceneDidEnterBackground() {
        sceneDidEnterBackgroundRelay.accept(())
    }
}
