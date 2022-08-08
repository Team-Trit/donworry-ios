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
        // MARK: Background Gradient
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
        
        // MARK: Background Image
        backgroundImage.image = UIImage(named: "SignInImage")
        
        view.addSubviews(backgroundView, backgroundImage)
    }
    
    private func setLabelStackView() {
        // TODO: 폰트 및 색상 추가 후 수정 예정
        let titleLabel = UILabel()
        titleLabel.text = "돈 워리"
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "떼인 돈 받아드립니다.\n걱정마세요."
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 20
        labelStackView.alignment = .center
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        view.addSubview(labelStackView)
    }
    
    private func setButtonStackView() {
        let appleLoginButton = UIButton()
        appleLoginButton.setBackgroundImage(UIImage(named: "apple_login_button"), for: .normal)
        
        let googleLoginButton = UIButton()
        googleLoginButton.setBackgroundImage(UIImage(named: "google_login_button"), for: .normal)
        
        let kakaoLoginButton = UIButton()
        kakaoLoginButton.setBackgroundImage(UIImage(named: "kakao_login_button"), for: .normal)
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(googleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        view.addSubview(buttonStackView)
    }
    
    // MARK: - Layout Helper
    private func setBackgroundLayout() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.widthAnchor.constraint(equalToConstant: 263),
            backgroundImage.heightAnchor.constraint(equalToConstant: 233),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        ])
    }
    
    private func setLabelStackViewLayout() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        ])
    }
    
    private func setButtonStackViewLayout() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}
