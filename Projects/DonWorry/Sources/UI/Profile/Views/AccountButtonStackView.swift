//
//  AccountButtonStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class AccountButtonStackView: UIStackView {
    lazy var logoutButton: UIButton = {
        let v = UIButton()
        v.setTitle("로그아웃", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        v.setTitleColor(.designSystem(.gray818181), for: .normal)
        return v
    }()
    private lazy var borderLabel: UILabel = {
        let v = UILabel()
        v.text = "|"
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        return v
    }()
    
    lazy var deleteButton: UIButton = {
        let v = UIButton()
        v.setTitle("회원탈퇴", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        v.setTitleColor(.designSystem(.gray818181), for: .normal)
        return v
    }()
    
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
extension AccountButtonStackView {
    private func configure() {
        self.axis = .horizontal
        self.spacing = 10
    }
    
    private func setUI() {
        self.addArrangedSubviews(logoutButton, borderLabel, deleteButton)
        
        borderLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoutButton.snp.trailing).offset(5)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(borderLabel.snp.trailing).offset(5)
        }
    }
}
