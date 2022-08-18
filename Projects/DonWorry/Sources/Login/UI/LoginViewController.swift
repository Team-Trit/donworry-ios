//
//  LoginViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/16.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: BaseViewController {
    private lazy var labelStackView = LabelStackView()
    private lazy var loginButtonStackView: LoginButtonStackView = {
        let v = LoginButtonStackView()
        v.delegate = self
        return v
    }()
    private lazy var backgroundView = BackgroundView()
    let viewModel = LoginViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension LoginViewController {
    private func setUI() {
        view.addSubviews(backgroundView, labelStackView, loginButtonStackView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            make.centerX.equalToSuperview()
        }
        
        loginButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - LoginButtonDelegate
extension LoginViewController: LoginButtonDelegate {
    func appleLogin(_ sender: UIButton) {
        
    }
    
    func googleLogin(_ sender: UIButton) {
        
    }
    
    func kakaoLogin(_ sender: UIButton) {
        
    }
}
