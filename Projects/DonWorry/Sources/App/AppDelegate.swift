//
//  AppDelegate.swift
//  DonWorry
//
//  Created by Woody on 2022/07/31.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseDynamicLinks
import UserNotifications
import KakaoSDKCommon
import DonWorryLocalStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "edeee91b673464dc9a3a5b65b063faaa")

        // Firebase Configuration
        setupFirebase(application: application)
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // MARK: 시뮬레이터에서 디버그할 시, 디바이스토큰을 못가져오기 때문에 회원가입, 로그인 오류납니다. 
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        UserDefaults.standard.write(token, key: .deviceToken)
    }
}

extension AppDelegate {
    func setupFirebase(application: UIApplication) {
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: authOptions) { (granted, error) in
            guard granted else {
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
