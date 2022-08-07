//
//  KakaoLoginButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class KakaoLoginButton: UIView {
    private let kakaoLoginButtonImageView = UIImageView()
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
extension KakaoLoginButton {
    private func attributes() {
        kakaoLoginButtonImageView.image = UIImage(named: "kakao_login_button")
        addSubview(kakaoLoginButtonImageView)
    }
    
    private func layout() {
        kakaoLoginButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kakaoLoginButtonImageView.widthAnchor.constraint(equalToConstant: 330),
            kakaoLoginButtonImageView.heightAnchor.constraint(equalToConstant: 50),
            kakaoLoginButtonImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
