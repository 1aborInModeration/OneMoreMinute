//
//  UIFont+Extensions.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit

/// 현재 프로젝트에 사용되는 폰트 종류를 선언.
/// 이번 프로젝트에서 사용하는 폰트의 굵기는 3가지이며, semiBold를 그냥 볼드로 사용.
enum FontName: String {
    case pretendardLight = "Pretendard-Light"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardSemiBold = "Pretendard-SemiBold"
}

extension UIFont {
    static func pretendard(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"
        var weightString: String
    
        switch weight {
        case .light:
            weightString = "Light"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        default:
            weightString = "Regular"
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
    }
}
