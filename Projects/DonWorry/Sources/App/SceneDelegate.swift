//
//  SceneDelegate.swift
//  DonWorry
//
//  Created by Woody on 2022/07/31.
//

import UIKit

import DesignSystem
import RxFlow
import Models

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var coordinator = FlowCoordinator()
    
//    let userService = UserService()
//    lazy var appServices = {
//        return AppServices(userService: userService)
//    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
#warning("테스트용, 배포할 때 데브버전으로 옮겨야 함.")
        UserDefaults.standard.writeCodable(User.dummyUser2, key: .user)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let appFlow = AppFlow(with: window)
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())
        
        window.makeKeyAndVisible()
        self.window = window
    }
}

//struct AppServices: HasUserService {
//    let userService: UserService
//}
