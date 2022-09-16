import UIKit

import DesignSystem
import DonWorryLocalStorage
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxSwift
import Models
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // 앱이 Running 상태가 아닐 때 수신
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        } else {
            window.rootViewController = createSplash(withShardID: nil)
        }
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
        
    }
}

// MARK: Dynamic Link 처리

extension SceneDelegate {
    
    // DynamicLink 처리
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("이 Dynamic Link Object 는 URL 을 가지고 있지 않습니다")
            return
        }
        print("🐥🐥🐥🐥🐥 Dynamic Link Parameter : \(url.absoluteString) 🐥🐥🐥🐥🐥")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return }
        for queryItem in queryItems {
            print("🥚Parameter🥚 \(queryItem.name) : \(queryItem.value ?? "")")
        }
        // DynamicLink로 들어오게 된 유저는 모두 Splash 화면으로 넘어가게 된다.
        animateWindow(withShareID: queryItems.first?.value)

    }

    private func animateWindow(withShareID shareID: String?) {
        UIView.transition(
            with: self.window!,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.window?.rootViewController = self.createSplash(withShardID: shareID)
            },
            completion: nil
        )
    }

    // DynamicLink 수신
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL)
            { (dynamiclink, error) in
                guard error == nil else {
                    print("🚨 ERROR: \(error!.localizedDescription)")
                    return
                }
                if let dynamiclink = dynamiclink {
                    self.handleIncomingDynamicLink(dynamiclink)
                }
            }
        }
    }
}

extension SceneDelegate {

    private func createSplash(withShardID shareID: String?) -> SplashViewController {
        let splash = SplashViewController()
        splash.reactor = SplashViewReactor(shareID: shareID)
        return splash
    }
}
