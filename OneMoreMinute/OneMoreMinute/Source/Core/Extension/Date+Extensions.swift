//
//  Date+Extensions.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

import Foundation

extension Date {
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
