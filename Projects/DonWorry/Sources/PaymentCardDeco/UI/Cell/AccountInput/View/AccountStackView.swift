//
//  AccountStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//
#warning("나중에 디자인시스템 공용컴포넌트로 교체예정")
import UIKit

import DesignSystem
import SnapKit

final class AccountStackView: UIStackView {
    private lazy var accountStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.alignment = .leading
        return v
    }()
    lazy var accountInputField = AccountInputField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AccountStackView {
    private func setUI() {
        accountStackView.addArrangedSubviews(accountInputField)
        addSubview(accountStackView)

        accountInputField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        accountStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
