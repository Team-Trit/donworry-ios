//
//  SceneDelegate.swift
//  DonWorry
//
//  Created by Woody on 2022/07/31.
//

import UIKit
import DesignSystem
import Models

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
        #warning("테스트용, 배포할 때 데브버전으로 옮겨야 함.")
        UserDefaults.standard.writeCodable(User.dummyUser2, key: .user)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

//        let rootViewController = UIStoryboard(name: "CreateRoom", bundle: nil).instantiateInitialViewController()!
        let rootViewController = RoomNameEditViewController()
//        rootViewController.view.backgroundColor = .systemIndigo
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}


