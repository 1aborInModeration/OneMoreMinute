//
//  TimeManager.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/9/25.
//

import Foundation
import RxSwift
import RxRelay

enum TimeFormat {
    static let time = "h:mm"
    static let date = "yyyy년 M월 dd일 EEEE"
    static let localeIdentifier = "en-US"
    static let timeUpdateInterval: TimeInterval = 1.0
}

/// 시간과 날짜 정보를 관리하고 업데이트하는 매니저 클래스
final class TimeManager {
    /// 현재 시간을 실시간으로 전달하는 PublishRelay
    let timeRelay = BehaviorRelay<String>(value: "")
    /// 현재 날짜를 전달하는 PublishRelay
    let dateRelay = BehaviorRelay<String>(value: "")
    
    private let timeFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private var timer: Timer?
    
    /// 초기화 및 날짜 변경 옵저버 등록
    init() {
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = TimeFormat.time
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = TimeFormat.date
        dateFormatter.locale = Locale(identifier: TimeFormat.localeIdentifier)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDayChange),
            name: .NSCalendarDayChanged,
            object: nil
        )
    }
    
    /// 옵저버 해제
    deinit {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 주기적인 시간 업데이트를 시작
    /// - Note: TimeFormat.timeUpdateInterval 간격으로 시간을 업데이트
    func startTimeUpdates() {
        // timer는 run loop와 강한 결합으로 선언, 따라서 명시적으로 해제해줘야 함
        timer = Timer.scheduledTimer(
            withTimeInterval: TimeFormat.timeUpdateInterval,
            repeats: true
        ) { [weak self] _ in
            self?.updateTime()
        }
        timer?.tolerance = 0.1
    }
    
    /// 현재 날짜 정보를 업데이트
    func updateCurrentDate() {
        updateDate()
    }
    
    /// 현재 시각 정보를 업데이트
    func updateCurrentTime() {
        updateTime()
    }
    
    /// 현재 시간을 업데이트하고 timeRelay를 통해 전달
    private func updateTime() {
        let now = Date()
        configureDateFormatter(format: TimeFormat.time)
        
        let timeString = dateFormatter.string(from: now)
        timeRelay.accept(timeString)
    }
    
    /// 현재 날짜를 업데이트하고 dateRelay를 통해 전달
    private func updateDate() {
        let now = Date()
        configureDateFormatter(format: TimeFormat.date)
        
        dateFormatter.locale = Locale(identifier: TimeFormat.localeIdentifier)
        let dateString = dateFormatter.string(from: now)
        dateRelay.accept(dateString)
    }
    
    /// DateFormatter 설정 구성
    private func configureDateFormatter(format: String) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
    }
    
    /// 날짜 변경 시 날짜 업데이트
    @objc
    private func handleDayChange() {
        updateCurrentDate()
    }
}
