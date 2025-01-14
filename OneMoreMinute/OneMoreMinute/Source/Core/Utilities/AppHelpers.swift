//
//  AppHelpers.swift
//  OneMoreMinute
//
//  Created by MaxBook on 1/7/25.
//

import UIKit

struct AppHelpers {
    
    /// 현재 최상위 뷰컨트롤러를 가져와서 해당 뷰 컨트롤러에 접근할 수 있도록 해주는 함수.
    ///
    /// - **요약** : 현재 보이는 ViewController를 모르는 상황에서, 어디서든 Alert나 Modal을 띄울 수 있는 능력
    ///   - 일반적으로 iOS 앱에서 Alert, Modal, Navigation 등과 같이 현재 보이는 화면에 무언가를 추가하거나 보여줘야 할 때 사용하는 용도. 일단은 모달과 Alert 용으로 제작.
    ///   - NavigationController, TabBarController, Modal 등이 다양하게 생성될 경우 현재 뷰 컨트롤러 추적이 어려울 수 있으며, 뷰가 아닌 전역 함수 등에서 alert 등을 구현하고자 할때 작성해야할 코드가 많아지는 것을 방지.
    /// - Returns: ?
    static func getTopViewController() -> UIViewController? {
        // 1. 현재 활성화된 UIWindowScene을 가져옵니다.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
                
        // 루트 ViewController 가져오기
        var topViewController = window.rootViewController
        
        // 네비게이션컨트롤러가 있을 경우 이를 탐색하여 사용.
        if let navigationController = topViewController as? UINavigationController {
            topViewController = navigationController.visibleViewController
        }
        
        // 여러 개의 뷰컨트롤러가 present를 통해 보여지고 있을 때 최상위 ViewController 탐색
        // present를 연달아 사용하는 경우에도 navigationController 처럼 스택으로 쌓이기 때문.
        while let presentedVC = topViewController?.presentedViewController {
            topViewController = presentedVC
        }
        
        print(topViewController ?? "root가 없어?")
        return topViewController
    }

    /// getTopViewController() 를 활용해 어디서든 Alert를 띄워주는 함수
    /// - Parameters:
    ///   - title: Alert 타이틀
    ///   - message: Alert 메시지
    ///   - action: Alert의 확인 버튼을 눌렀을 때 실행시키고자 하는 함수를 클로져로 전달.
    static func showBasicAlert(
        title: String,
        message: String,
        action: @escaping () -> Void = {}
    ) {
        guard let topVC = getTopViewController() else {
            print("ERROR: 뷰컨트롤러가 없습니다?")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        
        alert.addAction(confirmAction)
        topVC.present(alert, animated: true, completion: nil)
    }
    
    /// Date 타입의 데이터를 월, 일, 요일의 문자열로 반환하는 메소드
    ///
    /// - Parameter date: 변환하고자 하는 날짜 데이터
    /// - Returns: 문자열 타입의 결과물
    static func formattedDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 EEEE"
        
        return formatter.string(from: date)
    }
}
