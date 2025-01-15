//
//  IconButton.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/15/25.
//

import UIKit
import SnapKit


enum IconButtonSize {
    case regular
    case large
}

class IconButton: UIButton  {
        
    // MARK: - Properties
    
    let imageId: String
    let size: IconButtonSize
    var buttonColor: UIColor
    var iconColor: UIColor
    
    // MARK: - Initializer
    
    /// 아이콘용 버튼
    ///
    /// 원형 아이콘 표시용 아이콘
    /// 기본 텍스트는 가운데 정렬이며 시스템컬러를 기본 배경색으로 가집니다..
    /// 기본 폰트 색상은 Label 색상입니다.
    ///
    /// ``applyButtonAction`` 메소드를 사용하여 액션을 매핑할 수 있습니다.
    /// ``applyButtonAsyncAction`` 메소드를 사용하여 async 액션을 매핑할 수 있습니다.
    ///
    /// - Parameters:
    ///   - imageId: 이미지의 아이디 문자열 값
    ///   - size: 버튼의 사이즈. ``IconButtonSize``  참고
    ///   - buttonColor: 버튼의 배경 색상. 기본값은 grayButton
    ///   - iconColor: 버튼의 이미지 색상. 기본값은 grayButton
    init(
        imageId: String = "star",
        size: IconButtonSize = .regular,
        buttonColor: UIColor = .grayButtonBackground,
        iconColor: UIColor = .grayButtonLabel
    ){
        self.imageId = imageId
        self.size = size
        self.buttonColor = buttonColor
        self.iconColor = iconColor
        
        super.init(frame: .zero)
        
        setupProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

extension IconButton {
    
    func setupProperties() {
        self.setImage(UIImage(systemName: imageId), for: .normal)
        self.tintColor = iconColor
        self.backgroundColor = buttonColor
        
        switch self.size {
        case .regular:
            self.layer.cornerRadius = Layouts.buttonHeightSmall / 2
        case .large:
            self.layer.cornerRadius = Layouts.buttonHeight / 2
        }
        
    }
    
    func setupLayouts() {
        self.snp.makeConstraints { make in
            switch self.size {
            case .regular:
                make.width.equalTo(Layouts.buttonHeightSmall)
                make.height.equalTo(Layouts.buttonHeightSmall)
            case .large:
                make.width.equalTo(Layouts.buttonHeight)
                make.height.equalTo(Layouts.buttonHeight)
            }
        }
    }
}
