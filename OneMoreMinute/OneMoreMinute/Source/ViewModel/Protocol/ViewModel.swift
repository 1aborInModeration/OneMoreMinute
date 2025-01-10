//
//  ViewModel.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/9/25.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
