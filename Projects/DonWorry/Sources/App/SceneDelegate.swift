//
//  SceneDelegate.swift
//  DonWorry
//
//  Created by Woody on 2022/07/31.
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// Reference : https://stackoverflow.com/questions/22653993/programmatically-change-rootviewcontroller-of-storyboard
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

