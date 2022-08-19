//
//  AccountStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class AccountStackView: UIStackView {
    private lazy var accountLabel: UILabel = {
        let v = UILabel()
        v.text = "계좌정보"
        v.font = .designSystem(weight: .bold, size: ._18)
        return v
    }()
    lazy var accountInputField = AccountInputField()
    
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
extension AccountStackView {
    private func configure() {
        self.axis = .vertical
        self.spacing = 20
        self.alignment = .leading
    }
    
    private func setUI() {
        self.addArrangedSubviews(accountLabel, accountInputField)

        accountInputField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
}
