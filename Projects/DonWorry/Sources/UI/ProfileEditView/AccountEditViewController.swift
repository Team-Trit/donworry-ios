//
//  AccountEditViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem

final class AccountEditViewController: BaseViewController {
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.setLineSpacing(spacing: 10.0)
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    private lazy var accountEditField = AccountInputField(frame: .zero, type: .EnterUserInfo)
    private lazy var doneButton = DWButton.create(.xlarge58)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension AccountEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, doneButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        accountEditField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
