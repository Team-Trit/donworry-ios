//
//  EnterUserInfoViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/12.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import RxCocoa
import RxSwift

final class EnterUserInfoViewController: BaseViewController {
    private lazy var titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.text = "돈.워리"
        titleLabel.font = .gmarksans(weight: .bold, size: ._30)
        return titleLabel
    }()
    private lazy var nickNameStackView = NickNameStackView()
    private lazy var accountStackView = AccountStackView()
    private lazy var nextButton = LargeButton(type: .next)
    let viewModel = EnterUserInfoViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.delegate = self
        setUI()
    }
}

// MARK: - Layout
extension EnterUserInfoViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, nickNameStackView, accountStackView, nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        nickNameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.trailing.centerX.equalToSuperview()
        }
        
        accountStackView.snp.makeConstraints { make in
            make.top.equalTo(nickNameStackView.snp.bottom).offset(150)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - LargeButtonDelegate
extension EnterUserInfoViewController: LargeButtonDelegate {
    func buttonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(TermAgreeViewController(), animated: true)
    }
}

// MARK: - AccountTextFieldDelegate
extension EnterUserInfoViewController: AccountInputFieldDelegate {
    func showBankSelectSheet() {
        present(BankSelectViewController(), animated: true)
    }
}
