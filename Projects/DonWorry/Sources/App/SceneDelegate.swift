import UIKit

import DesignSystem
import DonWorryLocalStorage
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxSwift
import Models

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
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}
