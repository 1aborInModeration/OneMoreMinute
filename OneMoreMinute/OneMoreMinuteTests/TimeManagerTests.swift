//
//  TimeManagerTests.swift
//  TimeManagerTests
//
//  Created by 권승용 on 1/9/25.
//

import XCTest
import RxSwift
@testable import OneMoreMinute

final class TimeManagerTests: XCTestCase {
    var timeManager: TimeManager!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        timeManager = TimeManager()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        timeManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_시간업데이트_정상작동() {
        // Given
        let expectation = XCTestExpectation(description: "시간 업데이트 테스트")
        var receivedTime: String?
        
        // When
        timeManager.timeRelay
            .take(1)
            .subscribe(onNext: { time in
                receivedTime = time
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        timeManager.startTimeUpdates()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(receivedTime)
        
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.time
        let currentTime = formatter.string(from: Date())
        print(currentTime)
        XCTAssertEqual(receivedTime, currentTime)
    }
    
    func test_날짜업데이트_정상작동() {
        // Given
        let expectation = XCTestExpectation(description: "날짜 업데이트 테스트")
        var receivedDate: String?
        
        // When
        timeManager.dateRelay
            .take(1)
            .subscribe(onNext: { date in
                receivedDate = date
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        timeManager.updateCurrentDate()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.date
        formatter.locale = Locale(identifier: TimeFormat.localeIdentifier)
        let currentDate = formatter.string(from: Date())
        print(currentDate)
        XCTAssertEqual(receivedDate, currentDate)
    }
}
