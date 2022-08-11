//
//  UserInfoViewController.swift
//  DonWorryTests
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import RxCocoa
import RxSwift

final class UserInfoViewController: BaseViewController {
    private let titleLabel = UILabel()
    private let nickNameStackView = UIStackView()
    private let accountStackView = UIStackView(frame: .zero)
    private let nextButton = LargeButton(type: .next)
    let viewModel = UserInfoViewModel()
    
    public override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .white
        attributes()
        layout()
    }
}

// MARK: - Configuration
extension UserInfoViewController {
    
    private func attributes() {
        setTitleLabel()
        setNickNameStackView()
        setAccountStackView()
        nextButton.delegate = self
    }
    
    private func layout() {
        setTitleLabelLayout()
        setNickNameStackViewLayout()
        setAccountStackViewLayout()
        setNextButtonLayout()
    }
    
    // MARK: - Attributes Helper
    private func setTitleLabel() {
        titleLabel.text = "돈.워리"
        titleLabel.font = .gmarksans(weight: .bold, size: ._30)
    }
    
    private func setNickNameStackView() {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "닉네임"
        nickNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        let nickNameTextField = LimitTextField(placeholder: "닉네임을 입력해주세요", limit: 20)
        nickNameStackView.axis = .vertical
        nickNameStackView.spacing = 20
        nickNameStackView.alignment = .leading
        nickNameStackView.addArrangedSubview(nickNameLabel)
        nickNameStackView.addArrangedSubview(nickNameTextField)
        view.addSubview(nickNameStackView)
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nickNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    private func setAccountStackView() {
        let accountLabel = UILabel()
        accountLabel.text = "계좌정보"
        accountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        accountStackView.axis = .vertical
        accountStackView.spacing = 20
        accountStackView.alignment = .leading
        accountStackView.addArrangedSubview(accountLabel)
        let accountInfoStackView = AccountTextField()
        accountInfoStackView.delegate = self
        accountStackView.addArrangedSubview(accountInfoStackView)
        view.addSubview(accountStackView)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountLabel.widthAnchor.constraint(equalToConstant: 100),
            accountLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        accountInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            accountInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            accountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            accountStackView.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func setAccountInfoStackView() -> UIStackView {
        let accountInfoStackView = UIStackView()
        let chooseBankLabel = UILabel()
        chooseBankLabel.text = "은행 선택"
        chooseBankLabel.textColor = .white
        chooseBankLabel.font = .systemFont(ofSize: 10)
        chooseBankLabel.textAlignment = .center
        chooseBankLabel.clipsToBounds = true
        chooseBankLabel.layer.cornerRadius = 15
        chooseBankLabel.backgroundColor = .designSystem(.gray2)
        let holderTextField = LimitTextField(placeholder: "예금주명을 입력해주세요", limit: 20)
        accountInfoStackView.axis = .horizontal
        accountInfoStackView.spacing = 10
        accountInfoStackView.alignment = .center
        accountInfoStackView.addArrangedSubview(chooseBankLabel)
        accountInfoStackView.addArrangedSubview(holderTextField)
        view.addSubview(accountInfoStackView)
        chooseBankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseBankLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chooseBankLabel.widthAnchor.constraint(equalToConstant: 90),
            chooseBankLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        holderTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            holderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return accountInfoStackView
    }
    
    // MARK: - Layout Helper
    private func setTitleLabelLayout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        ])
    }
    
    private func setNickNameStackViewLayout() {
        nickNameStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nickNameStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50)
        ])
    }
    
    private func setAccountStackViewLayout() {
        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountStackView.topAnchor.constraint(equalTo: nickNameStackView.bottomAnchor, constant: 80)
        ])
    }
    
    private func setNextButtonLayout() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - AccountTextFieldDelegate
extension UserInfoViewController: AccountTextFieldDelegate {
    func showBankSelectSheet() {
        present(BankSelectViewController(), animated: true)
    }
}

// MARK: - LargeButtonDelegate
extension UserInfoViewController: LargeButtonDelegate {
    func buttonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(TermAgreeViewController(), animated: true)
    }
}
