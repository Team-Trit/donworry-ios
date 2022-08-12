//
//  LoginButtonStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final class LoginButtonStackView: UIStackView {
    private lazy var loginButtonStackView: UIStackView = {
       let loginButtonStackView = UIStackView()
        loginButtonStackView.axis = .vertical
        loginButtonStackView.spacing = 10
        loginButtonStackView.alignment = .center
        loginButtonStackView.distribution = .fillEqually
        return loginButtonStackView
    }()
    private lazy var appleLoginButton: UIButton = {
        let appleLoginButton = UIButton()
        appleLoginButton.setBackgroundImage(UIImage(named: "apple_login_button"), for: .normal)
        appleLoginButton.addTarget(self, action: #selector(appleButtonPressed(_:)), for: .touchUpInside)
        return appleLoginButton
    }()
    private lazy var googleLoginButton: UIButton = {
        let googleLoginButton = UIButton()
        googleLoginButton.setBackgroundImage(UIImage(named: "google_login_button"), for: .normal)
        googleLoginButton.addTarget(self, action: #selector(googleButtonPressed(_:)), for: .touchUpInside)
        return googleLoginButton
    }()
    private lazy var kakaoLoginButton: UIButton = {
        let kakaoLoginButton = UIButton()
        kakaoLoginButton.setBackgroundImage(UIImage(named: "kakao_login_button"), for: .normal)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoButtonPressed(_:)), for: .touchUpInside)
        return kakaoLoginButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension LoginButtonStackView {
    private func setUI() {
        loginButtonStackView.addArrangedSubview(appleLoginButton)
        loginButtonStackView.addArrangedSubview(googleLoginButton)
        loginButtonStackView.addArrangedSubview(kakaoLoginButton)
        addSubview(loginButtonStackView)
        
        loginButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Interaction Functions
extension LoginButtonStackView {
    @objc private func appleButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가 및 화면 이동
    }
    
    @objc private func googleButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가 및 화면 이동
    }
    
    @objc private func kakaoButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가 및 화면 이동
    }
}
