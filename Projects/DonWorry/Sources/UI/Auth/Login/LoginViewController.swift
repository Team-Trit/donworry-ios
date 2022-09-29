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
            make.bottom.equalTo(kakaoLoginButton.snp.top).inset(-10)
            make.centerX.equalToSuperview()
        }
        
        /*
        googleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).inset(10)
            make.centerX.equalToSuperview()
        }
         */
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension LoginViewController {
    private func dispatch(to reactor: LoginViewReactor) {
        appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentAppleLogin()
            })
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
        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.route(to: step)
            })
            .disposed(by: disposeBag)
    }

    private func presentAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Routing

extension LoginViewController {
    private func route(to step: LoginStep) {
        switch step {
        case let .signup(token, authorizationCode ,oauthType):
            let vc = EnterUserInfoViewController()
            vc.reactor = EnterUserInfoViewReactor(
                oauthType: oauthType,
                token: token,
                authorizationCode: authorizationCode
            )
            self.navigationController?.pushViewController(vc, animated: true)
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
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let authorizationCode = appleIDCredential.authorizationCode {
            let tokenString = String(decoding: identityToken, as: UTF8.self)
            let authorizationCode = String(decoding: authorizationCode, as: UTF8.self)
            print(tokenString)
            print(authorizationCode)
            reactor?.action.onNext(.proceedWithAppleToken(identityToken: tokenString, authorizationCode: authorizationCode))
        } else {
            DWToastFactory.show(message: "애플 로그인 실패", type: .error)
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        DWToastFactory.show(message: "애플 로그인 실패", type: .error)
    }
}
