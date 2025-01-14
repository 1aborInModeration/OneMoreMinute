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
    private let worldTimeDataManager = WorldTimeDataManager.shared

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
            
            let group = DispatchGroup()
            var cityTimeZones: [CityTimeZone] = []
            
            response.mapItems.forEach { item in
                guard let name = item.name,
                      let coordinate = item.placemark.location?.coordinate else { return }
                
                group.enter()
                self?.getTimeZone(from: coordinate) { timeZone in
                    if let timeZone = timeZone {
                        let timeDifference = self?.calculateTimeDifference(with: timeZone) ?? "-"
                        let cityTimeZone = CityTimeZone(cityName: name, timeZone: timeZone, timeDifference: timeDifference)
                        cityTimeZones.append(cityTimeZone)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self?.cityListRelay.accept(cityTimeZones)
            }
        }
    }

    
    func saveCity(cityTimeZone: CityTimeZone) {
        guard worldTimeDataManager.searchByTzId(by: cityTimeZone.timeZone.identifier) == nil else {
            print("\(cityTimeZone.timeZone.identifier)은 이미 존재합니다.")
            return
        }
        
        let newCityDto = WorldTimeDTO(
            cityName: cityTimeZone.cityName,
            timeZoneId: cityTimeZone.timeZone.identifier,
            createdAt: Date()
        )
        worldTimeDataManager.create(with: newCityDto)
    }
}


// MARK: - 내부 메소드

extension SearchCityViewModel {
    private func getTimeZone(from coordinate: CLLocationCoordinate2D, completion: @escaping (TimeZone?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let timeZone = placemark.timeZone {
                completion(timeZone)
            } else {
                completion(nil)
            }
        }
    }
    
    private func calculateTimeDifference(with timeZone: TimeZone) -> String {
        let currentTimeZone = TimeZone.current
        let differenceInSeconds = timeZone.secondsFromGMT() - currentTimeZone.secondsFromGMT()
        let differenceInHours = differenceInSeconds / 3600
        let diffGMTText = currentTimeZone.localizedName(for: .shortStandard, locale: Locale.current) ?? ""
        
        if differenceInHours == 0 {
            return "(\(diffGMTText)) 현재 시간과 동일"
        } else if differenceInHours > 0 {
            return "(\(diffGMTText)) 현재 시간보다 \(differenceInHours)시간 빨라요."
        } else {
            return "(\(diffGMTText)) 현재 시간보다 \(-differenceInHours)시간 느려요."
        }
    }
}
