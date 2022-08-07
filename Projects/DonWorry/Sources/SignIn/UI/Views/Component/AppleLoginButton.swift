//
//  AppleLoginButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class AppleLoginButton: UIView {
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
extension AppleLoginButton {
    private func attributes() {
        layer.cornerRadius = 7
        backgroundColor = .black
        
        addSubviews(iconView, loginLabel)
        iconView.image = UIImage(named: "applelogo")
        loginLabel.text = "Apple로 로그인"
        
        iconView.tintColor = .white
        loginLabel.textColor = .white
    }
    
    private func layout() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 90),
            loginLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 330),
            heightAnchor.constraint(equalToConstant: 50),
            centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
