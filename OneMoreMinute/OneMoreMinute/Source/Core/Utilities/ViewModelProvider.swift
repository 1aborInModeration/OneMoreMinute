//
//  ViewModelProvider.swift
//  OneMoreMinute
//
//  Created by t0000-m0112 on 2025-01-14.
//

protocol ViewModelProviding {
    var stopwatchViewModel: StopwatchViewModel { get }
}

final class ViewModelProvider: ViewModelProviding {
    static let shared = ViewModelProvider()
    lazy var stopwatchViewModel = StopwatchViewModel()
}
