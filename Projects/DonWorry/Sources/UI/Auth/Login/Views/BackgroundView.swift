//
//  BackgroundView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class BackgroundView: UIView {
    private lazy var gradientBackground: UIView = {
        let v = UIView()
        v.bounds = UIScreen.main.bounds
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = v.bounds
        let colors: [CGColor] = [
            .init(red: 1, green: 1, blue: 1, alpha: 1),
            .init(red: 0.1098, green: 0.4196, blue: 1, alpha: 1)
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0.47, 0.75]
        gradientLayer.type = .axial
        v.layer.addSublayer(gradientLayer)
        return v
    }()
    private lazy var backgroundImageView: UIImageView = {
        let v = UIImageView()
        v.image = .init(.sign_in_image)
        return v
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
