//
//  UIButton+Extensions.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit


/// 버튼에 사용되는 색상을 다음과 같이 제한합니다.
enum ButtonColor {
    case statusRed
    case statusGreen
    case statusYellow
    case primary
    case secondary
    case disalbled
}

/// 버튼의 코너 라운딩을 다음과 같이 제한합니다.
enum ButtonCorner {
    case none
    case rounded
    case fullRounded
}


extension UIButton {
    
    /// 버튼 색상 변경
    ///
    /// 버튼의 색상을 변경해줍니다.
    /// - Parameter color: ``ButtonColor`` 내에서 변경 가능합니다.
    /// - Returns: 정한 색상을 반환합니다.
    func getButtonColor(_ color: ButtonColor) -> UIColor {
        switch color {
        case .statusRed:
            return .statusRed
        case .statusGreen:
            return .statusGreen
        case .statusYellow:
            return .statusYellow
        case .primary:
            return Colors.systemColor(.r900) ?? .black900
        case .secondary:
            return Colors.systemColor(.r500) ?? .black500
        case .disalbled:
            return Colors.systemColor(.r100) ?? .black100
        }
    }
}

// MARK: - Button Action Assignment

extension UIButton {
    
    /// 부모로부터 액션을 할당받아 버튼의 터치 동작과 연결.
    /// - Parameter action: 동작을 수행하는 클로저
    func applyButtonAction(action: @escaping () -> Void) {
        let actionHandler = UIAction { _ in
            action()
        }
        
        self.addAction(actionHandler, for: .touchUpInside)
    }
    
    /// 부모로부터 비동기 액션을 할당받아 버튼의 터치 동작과 연결.
    /// - Parameter action: 비동기 동작을 수행하는 클로저
    func applyButtonAsyncAction(action: @escaping () async -> Void) {
        let actionHandler = UIAction { _ in
            Task {
                await action()
            }
        }
        
        self.addAction(actionHandler, for: .touchUpInside)
    }
}
