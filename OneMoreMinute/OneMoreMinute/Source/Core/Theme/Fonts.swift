//
//  Fonts.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit

enum TitleSize {
    case title1
    case title2
}

enum HeadlineSize {
    case headline1
    case headline2
}

struct Fonts {
    // MARK: - default font style
    
    /// 커버나 주요 메시지 용 폰트 / size : 48 / regular
    static let display1 = UIFont.pretendard(ofSize: 48, weight: .regular)
    /// 커버나 주요 메시지 용 폰트 / size : 48 / bold
    static let display1Bold = UIFont.pretendard(ofSize: 48, weight: .semibold)
    
    /// 섹션 제목, 페이지 제목 등에 사용되는 폰트 / size : 32 / regular
    static let headline1 = UIFont.pretendard(ofSize: 32, weight: .regular)
    /// 섹션 제목, 페이지 제목 등에 사용되는 폰트 / size : 32 / bold
    static let headline1Bold = UIFont.pretendard(ofSize: 32, weight: .semibold)
    /// 섹션 제목, 페이지 제목 등에 사용되는 폰트 / size : 28 / regular
    static let headline2 = UIFont.pretendard(ofSize: 28, weight: .regular)
    /// 섹션 제목, 페이지 제목 등에 사용되는 폰트 / size : 28 / bold
    static let headline2Bold = UIFont.pretendard(ofSize: 28, weight: .semibold)
    
    /// 소제목 등에 사용되는 폰트 / size : 24 / regular
    static let title1 = UIFont.pretendard(ofSize: 24, weight: .regular)
    /// 소제목 등에 사용되는 폰트 / size : 24 / bold
    static let title1Bold = UIFont.pretendard(ofSize: 24, weight: .semibold)
    /// 소제목 등에 사용되는 폰트 / size : 18 / regular
    static let title2 = UIFont.pretendard(ofSize: 18, weight: .regular)
    /// 소제목 등에 사용되는 폰트 / size : 18 / bold
    static let title2Bold = UIFont.pretendard(ofSize: 18, weight: .semibold)
    
    /// 기본 본문용 폰트 / size : 14 / regular
    static let body = UIFont.pretendard(ofSize: 14, weight: .regular)
    /// 기본 본문용 폰트 / size : 14 / bold
    static let bold = UIFont.pretendard(ofSize: 14, weight: .semibold)
    /// 매우 작은 버튼이나 라벨용 폰트. 이보다 작은 크기는 사용하지 않는다. / size : 12 / regular
    static let caption = UIFont.pretendard(ofSize: 12, weight: .regular)
}
