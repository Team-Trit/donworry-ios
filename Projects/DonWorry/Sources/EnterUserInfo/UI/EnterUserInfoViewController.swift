//
//  EnterUserInfoViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/16.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift

final class EnterUserInfoViewController: BaseViewController, View {
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "돈.워리"
        v.font = .gmarksans(weight: .bold, size: ._30)
        return v
    }()
    private lazy var nickNameStackView = NickNameStackView()
    lazy var accountStackView = AccountStackView()
    private lazy var nextButton = LargeButton(type: .next)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isUserInteractionEnabled = true
        setUI()
    }
    
    func bind(reactor: EnterUserInfoViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Bind
extension EnterUserInfoViewController {
    private func dispatch(to reactor: EnterUserInfoViewReactor) {
        accountStackView.accountInputField.chooseBankButton.rx.tap
            .map { Reactor.Action.bankSelectButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.nextButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: EnterUserInfoViewReactor) {
        
    }
}

// MARK: - Layout
extension EnterUserInfoViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(titleLabel, nickNameStackView, accountStackView, nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        
        nickNameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(100)
        }
        
        accountStackView.snp.makeConstraints { make in
            make.top.equalTo(nickNameStackView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(150)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
}
