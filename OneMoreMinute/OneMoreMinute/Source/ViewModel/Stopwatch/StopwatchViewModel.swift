//
//  StopwatchViewModel.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-12.
//

import Foundation
import RxSwift
import RxCocoa

final class StopwatchViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // Model
    private var model: StopwatchModel = StopwatchModel(isRunning: false, elapsedTime: 0, laps: [])
    
    // Outputs
    let isRunningRelay = BehaviorRelay<Bool>(value: false)
    let elapsedTimeRelay = BehaviorRelay<TimeInterval>(value: 0)
    let lapsRelay = BehaviorRelay<[LapViewModel]>(value: [])
    
    private var timerDisposable: Disposable?

    // MARK: - Public Methods
    func toggleTimer() {
        if model.isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        model.isRunning.toggle()
        isRunningRelay.accept(model.isRunning)
    }
    
    func resetOrAddLap() {
        if model.isRunning {
            // Add a new lap
            let lapTime = model.elapsedTime
            let lapModel = LapModel(lapNumber: model.laps.count + 1, lapTime: lapTime)
            model.laps.insert(lapModel, at: 0)
            
            // Update lapsRelay
            let lapViewModels = model.laps.map { LapViewModel(model: $0) }
            lapsRelay.accept(lapViewModels)
        } else {
            // Reset timer
            stopTimer()
            model.elapsedTime = 0
            model.laps.removeAll()
            
            elapsedTimeRelay.accept(model.elapsedTime)
            lapsRelay.accept([])
            isRunningRelay.accept(false)
        }
    }
    
    // MARK: - Timer Logic
    private func startTimer() {
        timerDisposable = Observable<Int>
            .interval(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.model.elapsedTime += 0.01
                self.elapsedTimeRelay.accept(self.model.elapsedTime)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
}
