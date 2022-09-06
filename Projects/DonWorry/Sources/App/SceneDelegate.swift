import UIKit

import DesignSystem
import KakaoSDKAuth
import RxFlow
import RxKakaoSDKAuth
import Models

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    
    private let userService: UserService = UserServiceImpl()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
#warning("테스트용, 배포할 때 데브버전으로 옮겨야 함.")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if let _ = userService.fetchLocalToken() {
            // MARK: Local Storage에 토큰이 저장되어 있으므로 HomeView로 이동
            // TODO: Access Token의 만료 시간에 대해서 정해야함
            let rootViewController = HomeViewController()
            rootViewController.reactor = HomeReactor()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            window.rootViewController = rootViewController
        } else {
            // MARK: Login Flow
            let appFlow = AppFlow(with: window)
            self.coordinator.coordinate(flow: appFlow, with: AppStepper())
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}
