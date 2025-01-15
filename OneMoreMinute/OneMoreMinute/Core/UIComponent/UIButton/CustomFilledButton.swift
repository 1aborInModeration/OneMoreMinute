//
//  CustomFilledButton.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit
import SnapKit

class CustomFilledButton: UIButton  {
    
    // MARK: - Properties
    
    let title: String
    let isSmall: Bool
    let cornerRound: ButtonCorner
    
    // MARK: - Initializer
    
    /// 커스텀 filled 버튼
    ///
    /// 기본 형태의 버튼.
    /// 기본 텍스트는 가운데 정렬이며 시스템컬러를 기본 배경색으로 가집니다..
    /// 기본 폰트 색상은 Label 색상입니다.
    ///
    /// ``applyButtonAction`` 메소드를 사용하여 액션을 매핑할 수 있습니다.
    /// ``applyButtonAsyncAction`` 메소드를 사용하여 async 액션을 매핑할 수 있습니다.
    ///
    /// - Parameters:
    ///   - color: 버튼 색상을 고를 수 있습니다. 기본값은 시스템 컬러입니다.
    ///   - title: 버튼에 들어갈 텍스트입니다. 기본은 **확인**입니다.
    ///   - isSmall: 버튼 높이 사이즈입니다. 기본은 48, 작은 사이즈는 32입니다.
    ///   - cornerRound: 버튼의 코너 라운드입니다.
    init(
        color: ButtonColor = .primary,
        title: String = "확인",
        isSmall: Bool = false,
        cornerRound: ButtonCorner = .none
    ){
        self.title = title
        self.isSmall = isSmall
        self.cornerRound = cornerRound
        
        super.init(frame: .zero)
        
        setupProperties(color)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

extension CustomFilledButton {
    
    func setupProperties(_ color: ButtonColor) {
        let buttonColor = self.getButtonColor(color)
        var config = UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = Fonts.bold
        
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        config.titleAlignment = .center
        
        switch self.cornerRound {
        case .none:
            config.background.cornerRadius = 0
        case .rounded:
            config.background.cornerRadius = Layouts.radiusSmall
        case .fullRounded:
            config.background.cornerRadius = isSmall ? Layouts.buttonHeightSmall / 2 : Layouts.buttonHeight / 2
        }
        
        config.baseForegroundColor = .fontLabel
        config.contentInsets = NSDirectionalEdgeInsets(top: Layouts.itemSpacing1, leading: Layouts.paddingSmall, bottom: Layouts.itemSpacing1, trailing: Layouts.paddingSmall)
        
        self.configurationUpdateHandler = { _ in
            switch self.state {
            case .normal:
                config.baseBackgroundColor = buttonColor
            case .highlighted:
                config.baseBackgroundColor = buttonColor.withAlphaComponent(0.8)
            case .disabled:
                config.baseBackgroundColor = self.getButtonColor(.disalbled)
            default:
                config.baseBackgroundColor = buttonColor
            }
        }
        
        self.configuration = config
    }
    
    func setupLayouts() {
        self.snp.makeConstraints { make in
            make.height.equalTo(isSmall ? Layouts.buttonHeightSmall : Layouts.buttonHeight)
            make.width.greaterThanOrEqualTo(80)
            
        }
    }
}
