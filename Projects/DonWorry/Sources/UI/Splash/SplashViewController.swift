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

    lazy var logoImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_spash_logo))
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        animateSplash()
    }

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)

        self.view.addSubview(self.logoImageView)

        self.logoImageView.snp.makeConstraints { make in
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

extension SplashViewController {
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
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([home, paymentCardList], animated: true)
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
