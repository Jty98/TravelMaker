//
//  SideMenuModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/24.
//

import Foundation
import UIKit
import SideMenu

class SideMenuModule {
    static let shared = SideMenuModule()
    
    private init() {}
    
    // SideMenuNavigationController 인스턴스 생성
    func createMenuNavigationController(withRootViewController rootViewController: UITableViewController) -> SideMenuNavigationController {
        let menuNavigationController = SideMenuNavigationController(rootViewController: rootViewController)
        menuNavigationController.leftSide = true
        menuNavigationController.presentationStyle = .menuSlideIn
        
        // 다른 메뉴 설정 및 사용자 정의 코드 추가 가능
        
        return menuNavigationController
    }
}

struct SideMenuModel {
    var icon: UIImage
    var title: String
}
