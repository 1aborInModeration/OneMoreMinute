//
//  AlarmViewModel.swift
//  OneMoreMinute
//
//  Created by 장상경 on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AlarmViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let coreDataManager = AlarmDataManager.shared
    
    private let disposeBag = DisposeBag()
    
    private(set) var data = BehaviorRelay(value: [Alarm]())
    
    init() {
        let data = self.coreDataManager.fetch()
        self.data.accept(data)
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
