//
//  LoginViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/16.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

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
    private lazy var googleLoginButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(.init(.google_login_button), for: .normal)
        return v
    }()
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
        view.addSubviews(backgroundView, labelStackView, appleLoginButton, googleLoginButton, kakaoLoginButton)
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            make.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(200)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(googleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension LoginViewController {
    private func dispatch(to reactor: LoginViewReactor) {
        appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        googleLoginButton.rx.tap
            .map { Reactor.Action.googleLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: LoginViewReactor) {
        reactor.pulse(\.$routeTo)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] routeTo in self?.move(to: routeTo) })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func move(to routeTo: LoginRouteTo) {
        switch routeTo {
        case .home:
            let homeViewController = HomeViewController()
            homeViewController.reactor = HomeReactor()
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}

#if DEBUG
extension LoginViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if event?.subtype == .motionShake {
            let testVC = UIViewController()
            testVC.view.backgroundColor = .white
            let button = UIButton(type: .system)
            button.setTitle("로그인하기", for: .normal)
            testVC.view.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
            present(testVC, animated: true)
        }
    }

    @objc
    private func buttonDidTap() {
//        let authUseCase = AuthUseCaseImpl()
//        authUseCase.fetchTestUser(2)
//            .subscribe(onNext: {
//            })
//            .disposed(by: disposeBag)

    }
}

#endif
