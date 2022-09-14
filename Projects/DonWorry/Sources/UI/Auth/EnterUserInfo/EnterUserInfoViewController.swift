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
import Models
import ReactorKit
import RxCocoa
import RxSwift

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import RxKakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon

final class EnterUserInfoViewController: BaseViewController, View{
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "돈.워리"
        v.font = .gmarksans(weight: .bold, size: ._30)
        return v
    }()
    private lazy var nickNameStackView = NickNameStackView()
    lazy var accountStackView = AccountStackView()
    private lazy var nextButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "다음"
        v.isEnabled = false
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }
    
    func bind(reactor: EnterUserInfoViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension EnterUserInfoViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, titleLabel, nickNameStackView, accountStackView, nextButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(30)
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

// MARK: - Bind
extension EnterUserInfoViewController {
    private func dispatch(to reactor: EnterUserInfoViewReactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.backButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nickNameStackView.nickNameTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.nicknameFieldUpdated(nickname: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        accountStackView.accountInputField.holderTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.accountHolderFieldUpdated(holder: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        accountStackView.accountInputField.accountTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.accountNumberFieldUpdated(number: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

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
        reactor.state.map { $0.signUpModel.bank }
            .asDriver(onErrorJustReturn: "은행선택")
            .drive { self.accountStackView.accountInputField.chooseBankButton.setTitle($0, for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isNextButtonAvailable)
            .asDriver(onErrorJustReturn: false)
            .drive(self.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: EnterUserInfoStep.none)
            .compactMap { $0 }
            .drive { [weak self] in
                self?.route(to: $0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension EnterUserInfoViewController {
    private func route(to step: EnterUserInfoStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .selectBank(let delegate):
            let vc = SelectBankViewController()
            vc.reactor = SelectBankViewReactor(userInfoViewDelegate: delegate, parentView: .enterUserInfo)
            self.present(vc, animated: true)
            
        case .agreeTerm(let signupModel):
            let vc = AgreeTermViewController()
            vc.reactor = AgreeTermViewReactor(signUpModel: signupModel)
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}
