//
//  AppDelegate.swift
//  DonWorry
//
//  Created by Woody on 2022/07/31.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

import DonWorryLocalStorage
import KakaoSDKCommon
import RxCocoa
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let isLoggedIn = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "edeee91b673464dc9a3a5b65b063faaa")
        
        let tokenObservable = UserDefaults.standard.rx.observe(String.self, UserDefaultsKey.accessToken.rawValue)
            .map { $0 != nil }
            .asObservable()
        let userObservable = UserDefaults.standard.rx.observe(Data.self, UserDefaultsKey.userAccount.rawValue)
            .map { $0 != nil }
            .asObservable()
        
        Observable.zip(tokenObservable, userObservable)
            .map { $0 && $1 }
            .bind(to: isLoggedIn)
            .disposed(by: disposeBag)
        
        // Firebase Configuration
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
