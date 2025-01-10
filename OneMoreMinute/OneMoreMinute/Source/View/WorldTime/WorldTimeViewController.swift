//
//  WorldTimeViewController.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Inject


class WorldTimeViewController: UIViewController {
    // MARK: - Properties

    let worldTImeView = Inject.ViewHost(WorldTimeView())
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        self.view = worldTImeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    
}

// MARK: - Bindings

extension WorldTimeViewController {
    func setupBindings() {
        
    }
}


// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    WorldTimeViewController()
}
