//
//  ServiceButtonView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

enum ServiceButtonType {
    case inquiry
    case question
    case blog
}

final class ServiceButtonView: UIView {
    private var type: ServiceButtonType
    private lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(.inquiry_button_icon)
        return v
    }()
    private lazy var buttonLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        return v
    }()
    
    init(frame: CGRect, type: ServiceButtonType) {
        self.type = type
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension ServiceButtonView {
    private func configure() {
        switch type {
        case .inquiry:
            self.iconImageView.image = UIImage(.inquiry_button_icon)
            self.buttonLabel.text = "1대1 문의"
            
        case .question:
            self.iconImageView.image = UIImage(.question_button_icon)
            self.buttonLabel.text = "자주 찾는 질문"
            
        case .blog:
            self.iconImageView.image = UIImage(.blog_button_icon)
            self.buttonLabel.text = "Blog"
        }
    }
    
    private func setUI() {
        addSubviews(iconImageView, buttonLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalTo(iconImageView)
        }
    }
}
