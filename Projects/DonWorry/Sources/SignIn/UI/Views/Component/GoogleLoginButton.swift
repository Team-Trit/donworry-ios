//
//  GoogleLoginButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class GoogleLoginButton: UIView {
    private let iconView = UIImageView()
    private let loginLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attributes()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension GoogleLoginButton {
    private func attributes() {
        layer.cornerRadius = 7
        backgroundColor = .white
        
        addSubviews(iconView, loginLabel)
        iconView.image = UIImage(named: "googlelogo")
        // TODO: Google loginLabel Roboto 폰트로 수정하기
        loginLabel.text = "Google 계정으로 로그인"
    }
    
    private func layout() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 60),
            loginLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 330),
            heightAnchor.constraint(equalToConstant: 50),
            centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
