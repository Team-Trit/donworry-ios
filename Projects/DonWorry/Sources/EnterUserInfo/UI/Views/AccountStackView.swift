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
    private lazy var accountStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.alignment = .leading
        return v
    }()
    private lazy var accountLabel: UILabel = {
        let v = UILabel()
        v.text = "계좌정보"
        v.font = .designSystem(weight: .bold, size: ._18)
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
        accountStackView.addArrangedSubviews(accountLabel, accountInputField)
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
