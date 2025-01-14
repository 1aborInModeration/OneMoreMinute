//
//  ViewModelType.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/9/25.
//

import RxSwift

/// 모든 뷰모델이 준수할 뷰모델 타입
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
