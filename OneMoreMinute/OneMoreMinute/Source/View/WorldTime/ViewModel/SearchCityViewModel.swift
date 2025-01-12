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
    
    let cityListRelay = BehaviorRelay<[CityTimeZone]>(value: [])


    func searchCities(with query: String){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.resultTypes = .address
        
        print("query!!!!")
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                return
            }
            
            guard let response = response else {
                return
            }
            
            let cityTimeZones = response.mapItems.compactMap { item -> CityTimeZone? in
                guard let name = item.name, let timeZone = TimeZone(identifier: TimeZone.current.identifier) else {
                    return nil
                }
                
                return CityTimeZone(cityName: name, timeZone: timeZone)
            }
            
            self.cityListRelay.accept(cityTimeZones)
        }
    }

    func saveCity(city: CityTimeZone) {
        
    }
}
