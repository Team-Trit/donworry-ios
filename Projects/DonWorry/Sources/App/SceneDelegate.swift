import UIKit

import DesignSystem
import DonWorryLocalStorage
import KakaoSDKAuth
import RxFlow
import RxKakaoSDKAuth
import RxSwift
import Models

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    private let disposeBag = DisposeBag()
    private let userService: UserService = UserServiceImpl()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Font.registerFonts()
        #warning("테스트용, 배포할 때 데브버전으로 옮겨야 함.")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let tokenObservable = UserDefaults.standard.rx.observe(String.self, UserDefaultsKey.accessToken.rawValue)
            .map { $0 != nil }
            .asObservable()
        let userObservable = UserDefaults.standard.rx.observe(Data.self, UserDefaultsKey.userAccount.rawValue)
            .map { $0 != nil }
            .asObservable()
        
        Observable.zip(tokenObservable, userObservable)
            .map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
            .drive { isLoggedIn in
                if isLoggedIn {
                    let rootViewController = HomeViewController()
                    rootViewController.reactor = HomeReactor()
                    let navigationController = UINavigationController(rootViewController: rootViewController)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window.rootViewController = navigationController
                } else {
                    let appFlow = AppFlow(with: window)
                    self.coordinator.coordinate(flow: appFlow, with: AppStepper())
                }
            }
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
