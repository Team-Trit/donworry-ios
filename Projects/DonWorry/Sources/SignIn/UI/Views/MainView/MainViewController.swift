//
//  MainViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import RxCocoa
import RxSwift
import UIKit

final class MainViewController: BaseViewController {
    private lazy var labelStackView = UIStackView()
    private lazy var buttonStackView = UIStackView()
    private let backgroundView = UIView()
    private let backgroundImage = UIImageView() 
    let viewModel = MainViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension MainViewController {
    private func attributes() {
        setBackground()
        setLabelStackView()
        setButtonStackView()
    }
    
    private func layout() {
        setBackgroundLayout()
        setLabelStackViewLayout()
        setButtonStackViewLayout()
    }
    
    // MARK: - Attributes Helper
    private func setBackground() {
        backgroundView.frame = view.bounds
        /// Reference : https://babbab2.tistory.com/55
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.bounds
        let colors: [CGColor] = [
            .init(red: 1, green: 1, blue: 1, alpha: 1),
            .init(red: 0.1098, green: 0.4196, blue: 1, alpha: 1)
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0.47, 0.75]
        gradientLayer.type = .axial
        backgroundView.layer.addSublayer(gradientLayer)
        backgroundImage.image = UIImage(named: "SignInImage")
    }
    
    private func setLabelStackView() {
        let titleLabel = UILabel()
        titleLabel.text = "돈.워리"
        titleLabel.font = .gmarksans(weight: .bold, size: ._30)
        titleLabel.textColor = .designSystem(.mainBlue)
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "떼인 돈 받아드립니다.\n걱정마세요."
        descriptionLabel.font = .gmarksans(weight: .light, size: ._15)
        labelStackView.axis = .vertical
        labelStackView.spacing = 20
        labelStackView.alignment = .center
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setButtonStackView() {
        let appleLoginButton = UIButton()
        appleLoginButton.setBackgroundImage(UIImage(named: "apple_login_button"), for: .normal)
        appleLoginButton.addTarget(self, action: #selector(appleButtonPressed(_:)), for: .touchUpInside)
        let googleLoginButton = UIButton()
        googleLoginButton.setBackgroundImage(UIImage(named: "google_login_button"), for: .normal)
        googleLoginButton.addTarget(self, action: #selector(googleButtonPressed(_:)), for: .touchUpInside)
        let kakaoLoginButton = UIButton()
        kakaoLoginButton.setBackgroundImage(UIImage(named: "kakao_login_button"), for: .normal)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoButtonPressed(_:)), for: .touchUpInside)
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(googleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
    }
    
    // MARK: - Layout Helper
    private func setBackgroundLayout() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.widthAnchor.constraint(equalToConstant: 263),
            backgroundImage.heightAnchor.constraint(equalToConstant: 233),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
        ])
    }
    
    private func setLabelStackViewLayout() {
        view.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        ])
    }
    
    private func setButtonStackViewLayout() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - Interaction Functions
extension MainViewController {
    @objc private func appleButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가
        navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
    
    @objc private func googleButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가
        navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
    
    @objc private func kakaoButtonPressed(_ sender: UIButton) {
        // TODO: 소셜 로그인 기능 추가
        navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
}
