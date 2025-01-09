//
//  AppLogger.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/8/25.
//

import OSLog

/// 앱 전반에서 사용할 수 있는 로거
enum AppLogger {
    // MARK: - Private Properties
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "OneMoreMinute", category: "default")
    
    // MARK: - Public Static Methods
    
    /// 디버그 로그 출력
    static func debug(_ message: String) {
        #if DEBUG
        logger.debug("\(message)")
        #endif
    }
    
    /// 정보 로그 출력
    static func info(_ message: String) {
        logger.info("\(message)")
    }
    
    /// 경고 로그 출력
    static func warning(_ message: String) {
        logger.warning("\(message)")
    }
    
    /// 에러 로그 출력
    static func error(_ message: String) {
        logger.error("\(message)")
    }
}
