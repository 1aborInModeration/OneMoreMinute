//
//  AlarmNotificationManager.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/13/25.
//

import UserNotifications

protocol AlarmNotificationManageable {
    func requestNotificationPermission() throws
    func setRegularNotification(
        identifier: String,
        title: String,
        body: String,
        weekday: AlarmNotificationWeekDays?,
        hour: AlarmNotificationHours?,
        minute: AlarmNotificationMinutes,
        repeats: Bool
    )
    func setTimerNotification(
        identifier: String,
        title: String,
        body: String,
        timeInterval: TimeInterval
    )
    func removePendingNotification(by identifier: String)
}

final class AlarmNotificationManager: AlarmNotificationManageable {
    static let shared = AlarmNotificationManager()
    private init() {}
    
    private let center = UNUserNotificationCenter.current()
    var isNotificationPermissionGranted: Bool = false
    
    /// 알림 권한을 요청하는 함수.
    /// 적절한 시점에 호출 필수
    func requestNotificationPermission() throws {
        Task {
            let center = UNUserNotificationCenter.current()
            let granted = try await center.requestAuthorization(options: [.alert, .sound])
            
            // TODO: 알람 권한 허용 여부에 따라 로직 작성
            if granted {
                AppLogger.info("알림 권한 허용됨")
                isNotificationPermissionGranted = true
            } else {
                AppLogger.info("알림 권한 허용되지 않음")
                isNotificationPermissionGranted = false
            }
        }
    }
    
    /// 정기적 알림 노티피케이션
    /// - Parameters:
    ///   - identifier: 추가할 알림 식별자
    ///   - title: 알림 제목
    ///   - body: 알림 본문
    ///   - weekday: 알림이 반복될 요일
    ///   - hour: 알림이 반복될 시간
    ///   - minute: 알림이 반복될 분
    ///   - repeats: 알림 반복 여부
    func setRegularNotification(
        identifier: String,
        title: String,
        body: String,
        weekday: AlarmNotificationWeekDays? = nil,
        hour: AlarmNotificationHours? = nil,
        minute: AlarmNotificationMinutes,
        repeats: Bool = true
    ) {
        // content 설정
        let content = configureContent(title: title, body: body)
        let dateComponent = AlarmNotificationDateComponent(
            weekday: weekday,
            hour: hour,
            minute: minute
        )
        
        // 트리거 설정
        let request = configureRegularTrigger(
            identifier: identifier,
            content: content,
            dateComponent: dateComponent,
            repeats: repeats
        )
        
        // 시스템에 알림 추가
        Task {
            do {
                try await center.add(request)
            } catch {
                AppLogger.error("AlarmNotificationManager: \(error.localizedDescription)")
            }
        }
    }
    
    /// 타이머 종료 알림 노티피케이션
    /// - Parameters:
    ///   - title: 알림 제목
    ///   - body: 알림 본문
    ///   - timeInterval: 몇 초 후 알림을 보낼 것인지 결정하는 파라미터
    func setTimerNotification(
        identifier: String,
        title: String,
        body: String,
        timeInterval: TimeInterval
    ) {
        // content 설정
        let content = configureContent(title: title, body: body)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // 트리거 설정
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 시스템에 알림 추가
        Task {
            do {
                AppLogger.info("TimerNotification Added")
                try await center.add(request)
            } catch {
                AppLogger.error("AlarmNotificationManager: \(error.localizedDescription)")
            }
        }
    }
    
    /// 대기 중인 알림 삭제
    /// - Parameter identifier: 알림 식별자
    func removePendingNotification(by identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        AppLogger.info("AlarmNotification with identifier \(identifier) removed")
    }
    
    private func configureContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.interruptionLevel = .timeSensitive
        let soundName = UNNotificationSoundName("morningAlarm.caf")
        content.sound = UNNotificationSound(named: soundName)
        return content
    }
    
    private func configureRegularTrigger(
        identifier: String,
        content: UNMutableNotificationContent,
        dateComponent: AlarmNotificationDateComponent,
        repeats: Bool
    ) -> UNNotificationRequest {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponent.dateComponents(), repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        return request
    }
}
