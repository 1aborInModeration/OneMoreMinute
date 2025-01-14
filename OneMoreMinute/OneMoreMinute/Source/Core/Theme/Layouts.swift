//
//  Layouts.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit

struct Layouts {
    
    // MARK: - Padding values / 주로 Leading, Trailing 설정용.
    
    /// 레이아웃에서 좌우 패딩(inset) 영역 지정용 / regular / 24
    static let padding: CGFloat = 24
    /// 레이아웃에서 좌우 패딩(inset) 영역 지정용 / small / 16
    static let paddingSmall: CGFloat = 16
    /// 레이아웃에서 좌우 패딩(inset) 영역 지정용 / large / 32
    static let paddingLarge: CGFloat = 32
    
    // MARK: - Radius values
    
    /// UI 컴포넌트의 모서리 라운딩 사이즈 / regular / 16
    static let radius: CGFloat = 16
    /// UI 컴포넌트의 모서리 라운딩 사이즈 / small / 8
    static let radiusSmall: CGFloat = 8
    /// UI 컴포넌트의 모서리 라운딩 사이즈 / large / 24
    static let radiuslarge: CGFloat = 24
    
    // MARK: - Item Spacing values / 아이템 간 간격 설정.
    
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 8
    static let itemSpacing1: CGFloat = 8
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 12
    static let itemSpacing2: CGFloat = 12
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 16
    static let itemSpacing3: CGFloat = 16
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 20
    static let itemSpacing4: CGFloat = 20
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 24
    static let itemSpacing5: CGFloat = 24
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 28
    static let itemSpacing6: CGFloat = 28
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 32
    static let itemSpacing7: CGFloat = 32
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 40
    static let itemSpacing8: CGFloat = 40
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 48
    static let itemSpacing9: CGFloat = 48
    /// UI 컴포넌트 간의 상하 거리 간격 조정용 사이즈 / 72
    static let itemSpacing10: CGFloat = 72
    
    // MARK: - Height values / 버튼 등의 기본 높이값 공유용
    
    /// 주로 버튼 등의 한줄 컴포넌트의 높이 사이즈 / 48
    static let buttonHeight: CGFloat = 48
    /// 작은 버튼 등의 비교적 작은 크기의 한줄 컴포넌트의 높이 사이즈 / 32
    static let buttonHeightSmall: CGFloat = 32
    
    // MARK: - Border 속성
    
    /// 얇은 굵기의 외곽선 // size : 1
    static let borderWidthThin: CGFloat = 1
    /// 일반 굵기의 외곽선 // size : 2
    static let borderWidth: CGFloat = 2
    /// 굵은 굵기의 외곽선 // size : 4
    static let borderWidthBold: CGFloat = 4
}
