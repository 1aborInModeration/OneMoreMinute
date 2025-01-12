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
    let currentLapRelay = BehaviorRelay<LapViewModel?>(value: nil)
    
    private var timerDisposable: Disposable?
    private var lastLapTime: TimeInterval = 0

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
               let currentTime = model.elapsedTime
               let lapTime = currentTime - lastLapTime // 현재 시간에서 마지막 랩 시간을 뺌
               lastLapTime = currentTime // 마지막 랩 시간을 현재 시간으로 업데이트
               
               let lapModel = LapModel(lapNumber: model.laps.count + 1, lapTime: lapTime)
               model.laps.insert(lapModel, at: 0)
               
               // Update lapsRelay
               let lapViewModels = model.laps.map { LapViewModel(model: $0) }
               lapsRelay.accept(lapViewModels)
           } else {
               // Reset timer
               stopTimer()
               model.elapsedTime = 0
               lastLapTime = 0 // 마지막 랩 시간 초기화
               model.laps.removeAll()
               
               elapsedTimeRelay.accept(model.elapsedTime)
               lapsRelay.accept([])
               isRunningRelay.accept(false)
               currentLapRelay.accept(nil)
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
                   self.updateCurrentLap() // 임시 랩 업데이트
               })
       }
       
       private func stopTimer() {
           timerDisposable?.dispose()
           timerDisposable = nil
       }
       
       private func updateCurrentLap() {
           let lapNumber = model.laps.count + 1
           let lapTime = model.elapsedTime - lastLapTime // 현재 시간에서 마지막 랩 시간을 뺌
           let currentLap = LapViewModel(model: LapModel(lapNumber: lapNumber, lapTime: lapTime))
           currentLapRelay.accept(currentLap)
       }
}
