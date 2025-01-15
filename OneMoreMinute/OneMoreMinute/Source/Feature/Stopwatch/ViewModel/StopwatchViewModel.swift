//
//  StopwatchViewModel.swift
//  OneMoreMinute
//
//  Created by DoyleHWorks on 2025-01-12.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

private enum UserDefaultsKeys {
    static let laps = "storedLaps"
    static let elapsedTime = "elapsedTime"
    static let lastTimestamp = "lastTimestamp"
    static let lastLapTime = "lastLapTime"
    static let isRunning = "isRunning"
}

final class StopwatchViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // Model
    private var model: StopwatchModel = StopwatchModel(isRunning: false, elapsedTime: 0, laps: [])
    
    // Outputs
    let isRunningRelay = BehaviorRelay<Bool>(value: false)
    let elapsedTimeRelay = BehaviorRelay<TimeInterval>(value: 0)
    let lapsRelay = BehaviorRelay<[LapViewModel]>(value: [])
    let currentLapRelay = BehaviorRelay<LapViewModel?>(value: nil)
    
    private var timerDisposable: Disposable?
    private var lastLapTime: TimeInterval = 0
    
    // MARK: - Initializer
    
    init() {
        
        /// - Note: 두개의 Relay를 하나의 PublishRelay로 통합한 후, 두개의 앱 상태를 정의한 열거형 타입 중 하나를 번갈아 변경시켜 이벤트를 방출시켰습니다.
        SceneLifeCycleObserver.shared.appStateRelay
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .willEnterForeground:
                    self?.handleSceneWillEnterForeground()
                case .didEnterBackground:
                    self?.handleSceneDidEnterBackground()
                }
            })
            .disposed(by: disposeBag)
        
        restoreState()
        
        if model.isRunning {
            startTimer()
        }
    }
    
    // MARK: - Private Methods
    
    private func handleSceneWillEnterForeground() {
        restoreState()
        if isRunningRelay.value {
            startTimer()
        }
    }
    
    private func handleSceneDidEnterBackground() {
        saveState()
        saveLaps()
    }
    
    private func updateCurrentLap() {
        let lapNumber = model.laps.count + 1
        let lapTime = model.elapsedTime - lastLapTime
        let currentLap = LapViewModel(
            model: LapModel(lapNumber: lapNumber, lapTime: lapTime),
            isFastest: false,
            isSlowest: false
        )
        currentLapRelay.accept(currentLap)
    }
    
    private func updateLapsRelay() {
        let laps = model.laps.map { $0.lapTime }
        guard let fastestLap = laps.min(), let slowestLap = laps.max() else { return }
        
        let lapViewModels = model.laps.map { lapModel in
            LapViewModel(
                model: lapModel,
                isFastest: lapModel.lapTime == fastestLap,
                isSlowest: lapModel.lapTime == slowestLap
            )
        }
        lapsRelay.accept(lapViewModels)
    }
    
    private func addLap() {
        let currentTime = model.elapsedTime
        let lapTime = currentTime - lastLapTime
        lastLapTime = currentTime
        
        let newLap = LapModel(lapNumber: model.laps.count + 1, lapTime: lapTime)
        model.laps.insert(newLap, at: 0)
        
        updateLapsRelay()
        saveLaps()
    }
    
    private func reset() {
        stopTimer()
        model.elapsedTime = 0
        lastLapTime = 0
        model.laps.removeAll()
        
        elapsedTimeRelay.accept(0)
        lapsRelay.accept([])
        currentLapRelay.accept(nil)
        saveLaps()
    }
    
    func toggleTimer() {
        if model.isRunning {
            stopTimer()
            isRunningRelay.accept(false)
        } else {
            startTimer()
            isRunningRelay.accept(true)
        }
        model.isRunning.toggle()
        isRunningRelay.accept(model.isRunning)
    }
    
    func resetOrAddLap() {
        if model.isRunning {
            addLap()
        } else {
            reset()
        }
    }
    
    // MARK: - Public Methods
    
    func saveLaps() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model.laps)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.laps)
        } catch {
            print("Failed to encode laps: \(error)")
        }
    }
    
    func restoreLaps() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.laps) else { return }
        let decoder = JSONDecoder()
        do {
            let laps = try decoder.decode([LapModel].self, from: data)
            model.laps = laps
            updateLapsRelay()
        } catch {
            print("Failed to decode laps: \(error)")
        }
    }
    
    // MARK: - Timer Logic
    
    func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>
            .interval(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.model.elapsedTime += 0.01
                self.elapsedTimeRelay.accept(self.model.elapsedTime)
                self.updateCurrentLap()
            })
    }
    
    func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
        stopBackgroundTask()
    }
    
    // MARK: - State Management
    
    func saveState() {
        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(model.elapsedTime, forKey: UserDefaultsKeys.elapsedTime)
        UserDefaults.standard.set(timestamp, forKey: UserDefaultsKeys.lastTimestamp)
        UserDefaults.standard.set(lastLapTime, forKey: UserDefaultsKeys.lastLapTime)
        UserDefaults.standard.set(model.isRunning, forKey: UserDefaultsKeys.isRunning)
    }
    
    func restoreState() {
        let savedElapsedTime = UserDefaults.standard.double(forKey: UserDefaultsKeys.elapsedTime)
        let savedTimestamp = UserDefaults.standard.double(forKey: UserDefaultsKeys.lastTimestamp)
        let savedLastLapTime = UserDefaults.standard.double(forKey: UserDefaultsKeys.lastLapTime)
        let isRunning = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isRunning)
        
        if isRunning {
            let currentTime = Date().timeIntervalSince1970
            let additionalTime = currentTime - savedTimestamp
            model.elapsedTime = savedElapsedTime + additionalTime
            startTimer()
        } else {
            model.elapsedTime = savedElapsedTime
        }
        
        model.isRunning = isRunning
        lastLapTime = savedLastLapTime
        updateCurrentLap()
        
        isRunningRelay.accept(isRunning)
        if elapsedTimeRelay.value != model.elapsedTime {
            elapsedTimeRelay.accept(model.elapsedTime)
        }
    }
    
    // MARK: - Background Task Handling
    
    func startBackgroundTask() {
        guard backgroundTask == .invalid else { return }
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "StopwatchBackgroundTask") {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
    
    private func stopBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
