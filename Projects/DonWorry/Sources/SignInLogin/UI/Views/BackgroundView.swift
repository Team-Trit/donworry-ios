//
//  BackgroundView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final class BackgroundView: UIView {
    private lazy var gradientBackground: UIView = {
        let gradientBackground = UIView()
        gradientBackground.bounds = UIScreen.main.bounds
        /// Reference : https://babbab2.tistory.com/55
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBackground.bounds
        let colors: [CGColor] = [
            .init(red: 1, green: 1, blue: 1, alpha: 1),
            .init(red: 0.1098, green: 0.4196, blue: 1, alpha: 1)
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0.47, 0.75]
        gradientLayer.type = .axial
        gradientBackground.layer.addSublayer(gradientLayer)
        return gradientBackground
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "SignInImage")
        return backgroundImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension BackgroundView {
    private func setUI() {
        addSubviews(gradientBackground, backgroundImageView)
        
        gradientBackground.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
        }
    }
}
