//
//  AlarmSnoozeHostingViewController.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

import SwiftUI

final class AlarmSnoozeHostingViewController: UIHostingController<AlarmSnoozeView> {
    
    init(time: String, title: String, dismiss: @escaping () -> Void) {
        super.init(
            rootView: AlarmSnoozeView(
                alarmTime: time,
                alarmTitle: title,
                snoozeTapped: dismiss
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
    }
}
