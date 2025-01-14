
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
    
    let worldTimesRelay = BehaviorRelay<[WorldTime]>(value: [])
    private let disposeBag = DisposeBag()
    private let worldTimeDataManager = WorldTimeDataManager.shared
    
    
    // MARK: - Life Cycles
}


// MARK: - View Update

extension WorldTimeViewModel {
    func setupClock() {
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
                currentDate: currentDate,
                timeZoneId: timeZone.identifier
            )
        }
        
        worldTimesRelay.accept(worldTimes)
    }
    
    func deleteWorldTime(timeZoneId: String) {
        if let worldTime = worldTimeDataManager.searchByTzId(by: timeZoneId) {
            worldTimeDataManager.delete(worldTime)
        }
    }
}
