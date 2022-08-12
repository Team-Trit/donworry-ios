//
//  AccountStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final class AccountStackView: UIStackView {
    private lazy var accountStackView: UIStackView = {
        let accountStackView = UIStackView()
        accountStackView.axis = .vertical
        accountStackView.spacing = 20
        accountStackView.alignment = .leading
        return accountStackView
    }()
    private lazy var accountLabel: UILabel = {
        let accountLabel = UILabel()
        accountLabel.text = "계좌정보"
        accountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return accountLabel
    }()
    private lazy var accountInputField: AccountInputField = {
        let accountInputField = AccountInputField()
        // TODO: Inject Delegate
        return accountInputField
    }()
    
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
        accountStackView.addArrangedSubview(accountLabel)
        accountStackView.addArrangedSubview(accountInputField)
        addSubview(accountStackView)
        
        accountInputField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        accountStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
