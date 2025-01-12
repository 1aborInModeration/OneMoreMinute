//
//  Colors.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit

/// 시스템 컬러는 검정과 프로젝트 맞춤 컬러 보라색 두가지만 사용합니다.
enum SystemColors: String {
    case Black = "Black"
    case Purple = "Purple"
}

/// 컬러의 ramp 어레인지를 다음과 같이 제한합니다.
enum SystemColorRamps: String {
    case r50 = "50"
    case r100 = "100"
    case r200 = "200"
    case r300 = "300"
    case r400 = "400"
    case r500 = "500"
    case r600 = "600"
    case r700 = "700"
    case r800 = "800"
    case r900 = "900"
}

/// 아무 폰트나 쓰지 말고 텍스트는 텍스트용 폰트를 사용해주세요.
enum FontColor: String {
    case label = "FontLabel"
    case secondary = "FontSecondary"
    case disabled = "FontDisabled"
    case gray = "FontGray"
    case background = "FontBackground"
}


struct Colors {
    // MARK: - SystemColor
        
    /// 앱 전체의 시스템 컬러 지정용.
    /// 해당값을 변경하면 전체 테마 컬러를 변경할 수 있습니다.
    /// 서비스 내에서 변경을 구현하려면 ``changeSystemColor`` 메소드를 사용.
    static var selectedColor: SystemColors = .Purple
    
    /// 시스템 컬러를 변경하는 메소드
    /// - Parameter color: 원하는 컬러를 지정.
    static func changeSystemColor(_ color: SystemColors) {
        selectedColor = color
    }
    
    
    /// 지정된 시스템 컬러 램프 중 원하는 색상을 사용하는 용도의 메소드.
    /// - Parameter ramp: 원하는 레벨의 진한 정도를 선택. 최대 900, 최소 50
    /// - Returns: UIColor 값 반환.
    static func systemColor(_ ramp: SystemColorRamps) -> UIColor? {
        return UIColor(named: "\(selectedColor.rawValue)-\(ramp.rawValue)" )
    }
    
    /// 숫자가 낮을수록 연하다.
    /// `.Black-<ramp>`로 직접 확인 가능.
    /// - Parameter ramp: 원하는 레벨의 진한 정도를 선택. 최대 900, 최소 50
    /// - Returns: UIColor 값 반환.
    static func systemGray(_ ramp: SystemColorRamps) -> UIColor? {
        return UIColor(named: "Black-\(ramp.rawValue)")
    }
    
    
    // MARK: - Basic Color
    
    /// 현재 앱의 백그라운드 색상으로 정한 컬러. 일반적으로 기본적인 흰/다크 색상.
    static var appBackground: UIColor = .backgroundLightGray
    
    /// 그냥 회색이 필요할 때 사용하는  그냥 Gray
    static var systemGray: UIColor = .black500
    /// 그냥 옅은 회색이 필요할 때 사용하는  그냥 LightGray
    static var systemLightGray: UIColor = .black200
    /// 그냥 진한 회색이 필요할 때 사용하는  그냥 DarkGray
    static var systemDarkGray: UIColor = .black800
}
