//
//  LoginViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/16.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import AuthenticationServices
import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: BaseViewController, View {
    private lazy var labelStackView = LabelStackView()
    
    // TODO: 삭제하기
    lazy var testUserButton: UIButton = {
        let v = UIButton()
        v.setTitle("", for: .normal)
        v.setBackgroundColor(.clear, for: .normal)
        return v
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(.init(.apple_login_button), for: .normal)
        return v
    }()
    /*
    private lazy var googleLoginButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(.init(.google_login_button), for: .normal)
        return v
    }()
     */
    private lazy var kakaoLoginButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(.init(.kakao_login_button), for: .normal)
        return v
    }()
    private lazy var backgroundView = BackgroundView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func bind(reactor: LoginViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension LoginViewController {
    private func setUI() {
        view.addSubviews(backgroundView, labelStackView, appleLoginButton, kakaoLoginButton)
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            make.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(270)
        }
        
        /*
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
         */
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // TODO: 삭제하기
        view.addSubview(testUserButton)
        testUserButton.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.trailing.equalToSuperview().inset(30)
        }
        testUserButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { .didTapTestUserButton }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension LoginViewController {
    private func dispatch(to reactor: LoginViewReactor) {
        appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /*
        googleLoginButton.rx.tap
            .map { Reactor.Action.googleLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
         */
        
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: LoginViewReactor) {
        reactor.pulse(\.$appleLoginTrigger)
            .asDriver(onErrorJustReturn: ())
            .compactMap { $0 }
            .drive(onNext: { _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.route(to: step)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension LoginViewController {
    private func route(to step: LoginStep) {
        switch step {
        case let .enterUserInfo(provider, token):
            let vc = EnterUserInfoViewController()
            vc.reactor = EnterUserInfoViewReactor(provider: provider, token: token)
            self.navigationController?.pushViewController(vc, animated: true)
            
            // TODO: 삭제하기
        case .home:
            let homeViewController = HomeViewController()
            homeViewController.reactor = HomeReactor()
            self.navigationController?.setViewControllers([homeViewController], animated: true)
            
        default:
            break
        }
    }
}

// MARK: - Apple Login
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityToken = appleIDCredential.identityToken else { return }
            let tokenString = String(decoding: identityToken, as: UTF8.self)
            reactor?.action.onNext(.proceedWithAppleToken(identityToken: tokenString))

        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

// TODO: 삭제하기
/*
extension LoginViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            let viewcontroller = TestViewController()
            self.present(viewcontroller, animated: true)
        default:
            break
        }
    }
}
*/
