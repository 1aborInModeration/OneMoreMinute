//
//  SearchCityViewModel.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit


class SearchCityViewModel {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let cityListRelay = PublishRelay<[CityTimeZone]>()


    func searchCities(with query: String){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.resultTypes = .address
                
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else { return }
            
            let cityTimeZones = response.mapItems.compactMap { item -> CityTimeZone? in
                guard let name = item.name,
                      let coordinate = item.placemark.location?.coordinate else {
                    return nil
                }
                
                print(item)
                                
                // 좌표를 기반으로 타임존 찾기
                if let timeZone = self?.getTimeZone(from: coordinate) {
                    print(timeZone)
                    let timeDifference = self?.calculateTimeDifference(with: timeZone)
                    return CityTimeZone(cityName: name, timeZone: timeZone, timeDifference: timeDifference!)
                }
                
                return nil
            }
                               
            self?.cityListRelay.accept(cityTimeZones)
        }
    }

    func saveCity(city: CityTimeZone) {
        
    }
}


extension SearchCityViewModel {
    private func getTimeZone(from coordinate: CLLocationCoordinate2D) -> TimeZone? {
        print("im in")
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        var timeZone: TimeZone?
        
        let semaphore = DispatchSemaphore(value: 0)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let tz = placemark.timeZone {
                timeZone = tz
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return timeZone
    }
    
    private func calculateTimeDifference(with timeZone: TimeZone) -> String {
        let currentTimeZone = TimeZone.current
        let differenceInSeconds = timeZone.secondsFromGMT() - currentTimeZone.secondsFromGMT()
        let differenceInHours = differenceInSeconds / 3600
        
        if differenceInHours == 0 {
            return "현지 시간과 동일"
        } else if differenceInHours > 0 {
            return "\(differenceInHours)시간 빠름"
        } else {
            return "\(-differenceInHours)시간 느림"
        }
    }
}
