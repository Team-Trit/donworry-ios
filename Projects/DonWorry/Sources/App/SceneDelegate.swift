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
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let userService: UserService = UserServiceImpl()
    private let disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
        #warning("테스트용, 배포할 때 데브버전으로 옮겨야 함.")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        appDelegate?.isLoggedIn
            .asDriver()
            .drive(onNext: { isLoggedIn in
                if isLoggedIn {
                    let rootViewController = HomeViewController()
                    rootViewController.reactor = HomeReactor()
                    let navigationController = UINavigationController(rootViewController: rootViewController)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window.rootViewController = navigationController
                } else {
                    let rootViewController = LoginViewController()
                    rootViewController.reactor = LoginViewReactor()
                    let navigationController = UINavigationController(rootViewController: rootViewController)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window.rootViewController = navigationController
                }
            })
            .disposed(by: disposeBag)
        
        window.makeKeyAndVisible()
        self.window = window
        
        // 앱이 Running 상태가 아닐 때 수신
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
        
    }
    
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
            print("🥚Parameter🥚 \(queryItem.name) : \(queryItem.value??"")")
        }
        dynamicLink.matchType
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
