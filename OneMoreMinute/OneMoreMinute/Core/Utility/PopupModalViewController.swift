//
//  PopupModalViewController.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit
import SnapKit

final class PopupModalViewController: UIViewController, ModalCloseDelegate {
    
    // MARK: - Properties

    private let modalContentsView: UIView

    
    // MARK: - Initializer

    init(modalContentsView: ModalCloseable) {
        self.modalContentsView = modalContentsView as! UIView
        super.init(nibName: nil, bundle: nil)
        
        modalContentsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupTargetView()
    }
    
    /// 모달이 화면에 나타날 때 호출
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let targetView = modalContentsView as? ModalLifecycleNotifiable {
            targetView.onModalWillAppear()
        }
    }
    
    /// 모달이 사라질 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let targetView = modalContentsView as? ModalLifecycleNotifiable {
            targetView.onModalWillDisappear()
        }
    }
}

// MARK: - Setup UI Layouts

extension PopupModalViewController {
    
    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    private func setupTargetView() {
        view.addSubview(modalContentsView)
        modalContentsView.translatesAutoresizingMaskIntoConstraints = false
        
        modalContentsView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Layouts.paddingSmall)
        }
    }
}

// MARK: - Action Management & Mapping

extension PopupModalViewController {
    func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
