//
//  SplashViewController.swift
//  App
//
//  Created by Woody on 2022/09/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem

final class SplashViewController: BaseViewController, View {

    lazy var animationView: UIImageView = {
        let v = UIImageView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        guard let path = Bundle.main.path(forResource: "splash", ofType: "gif") else {
            fatalError("Gif does not exist at that path")
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else {
            fatalError("Gif does not exist at that path")
        }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        v.animationImages = images
        v.startAnimating()
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        animateSplash()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        animationView.stopAnimating()
    }

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)

        self.view.addSubview(self.animationView)

        self.animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }

    func bind(reactor: SplashViewReactor) {
        reactor.pulse(\.$step)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)

        reactor.pulse(\.$errorMessage)
            .compactMap { $0 }
            .subscribe(onNext: { message in
                DWToastFactory.show(message: message, type: .error)
            }).disposed(by: disposeBag)
    }

    private func animateSplash() {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(splashTimeOut), userInfo: nil, repeats: false)
    }

    @objc func splashTimeOut() {
        reactor?.action.onNext(.splashEnd)
    }
}

extension SplashViewController: UIGestureRecognizerDelegate {
    func move(to step: SplashStep) {
        switch step {
        case .home:
            routeToHomeViewController()
        case .login:
            routeToLoginViewController()
        case .paymentCardList(let response):
            let paymentCardList = createPaymentCardListViewController(with: response)
            routeToPaymentCardListViewController(paymentCardList)
        }
    }

    private func routeToLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.reactor = LoginViewReactor()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.isNavigationBarHidden = true
        navigationController.interactivePopGestureRecognizer?.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        UIView.transition(
            with: self.window!,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.window?.rootViewController = navigationController
            }, completion: nil)
    }

    private func routeToHomeViewController() {
        let homeViewController = HomeViewController()
        homeViewController.reactor = HomeReactor()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.isNavigationBarHidden = true
        navigationController.interactivePopGestureRecognizer?.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        UIView.transition(
            with: self.window!,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.window?.rootViewController = navigationController
            }, completion: nil)
    }

    private func routeToPaymentCardListViewController(_ paymentCardList: PaymentCardListViewController) {
        let home = HomeViewController()
        home.reactor = HomeReactor()
        let navigationController = UINavigationController(rootViewController: home)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(paymentCardList, animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        UIView.transition(
            with: self.window!,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.window?.rootViewController = navigationController
            }, completion: nil)
    }

    private func createPaymentCardListViewController(with response: SpaceModels.JoinSpace.Response) -> PaymentCardListViewController {
        let paymentCardListViewController = PaymentCardListViewController()
        paymentCardListViewController.reactor = PaymentCardListReactor(
            spaceID: response.id, adminID: response.adminID, status: response.status
        )
        return paymentCardListViewController
    }

    private var window: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.windows.first
        }
        return nil
    }
}
