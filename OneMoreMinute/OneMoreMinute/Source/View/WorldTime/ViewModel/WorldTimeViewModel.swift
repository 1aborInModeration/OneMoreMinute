
//
//  WorldTimeViewModel.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit


class WorldTimeViewModel {
    // MARK: - Properties
    
    let worldTimesRelay = PublishRelay<[WorldTime]>()
    private let disposeBag = DisposeBag()
    private let worldTimeDataManager = WorldTimeDataManager.shared
    private var timer: Timer?
    
    
    // MARK: - Life Cycles
    
    init() {
        startClock()
    }
    
    deinit {
        stopClock()
    }
}


// MARK: - View Update

extension WorldTimeViewModel {
    func updateWorldTimes() {
        let worldTimes: [WorldTimeEntity?] = worldTimeDataManager.fetch()
        print(worldTimes)
        
//        let citiTimeZones = worldTimes.map(
//            return CityTimeZone(
//                cityName: $0.cityName,
//                timeZone: TimeZone(identifier: $0.identifier)
//            )
//        )
    }
    
    /// 시계
    private func startClock() {
        updateClock()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateClock()
        }
    }
    
    
    /// 매 초마다 세계시간 인스턴스를 죄다 새로 만들어서 렌더링하는 미친 업데이트.
    /// 각 인스턴스마다 타이머가 돌아가는 것보다 타이머를 하나로 하는 편이 좋다고 생각하였으나,
    /// 정작 인스턴스 초기화와 시간 글자 업데이트를 분리하지 못해서 아래와 같은 결과물이 탄생하였다.
    private func updateClock() {
        let worldTimes = WorldTimeDataManager.shared.fetch().compactMap { entity -> WorldTime? in
            guard let cityName = entity.cityName,
                  let timeZone = TimeZone(identifier: entity.timeZoneId ?? "Asia/Seoul") else {
                return nil
            }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = timeZone
            formatter.dateFormat = "HH:mm"
            
            let currentTime = formatter.string(from: Date())
            
            formatter.dateFormat = "MM월 dd일 EEEE"
            let currentDate = formatter.string(from: Date())
            
            return WorldTime(
                cityName: cityName,
                currentTime: currentTime,
                currentDate: currentDate
            )
        }
        
        worldTimesRelay.accept(worldTimes)
    }
    
    private func stopClock() {
        timer?.invalidate()
        timer = nil
    }
}
