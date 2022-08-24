//
//  NickNameStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class NickNameStackView: UIStackView {
    private lazy var nickNameLabel: UILabel = {
       let v = UILabel()
        v.text = "닉네임"
        v.font = .designSystem(weight: .bold, size: ._18)
        return v
    }()
    private lazy var nickNameTextField = LimitTextField(frame: .zero, type: .nickName)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension NickNameStackView {
    private func configure() {
        self.axis = .vertical
        self.spacing = 20
        self.alignment = .leading
    }
    
    private func setUI() {
        self.addArrangedSubviews(nickNameLabel, nickNameTextField)
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        nickNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
}
