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
import ReactorKit
import RxCocoa
import RxSwift

final class AccountEditViewController: BaseViewController, View {
    typealias Reactor = AccountEditViewReactor
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "계좌정보를\n수정해볼까요?"
        v.numberOfLines = 0
        v.setLineSpacing(spacing: 10.0)
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    lazy var accountEditField: AccountInputField = {
        let v = AccountInputField(frame: .zero, type: .EnterUserInfo)
        v.holderTextField.textField.attributedPlaceholder = NSAttributedString(string: (reactor?.currentState.user.bankAccount.accountHolderName) ?? "예금주명", attributes: [.font: UIFont.designSystem(weight: .regular, size: ._15)])
        v.accountTextField.textField.attributedPlaceholder = NSAttributedString(string: (reactor?.currentState.user.bankAccount.accountNumber) ?? "계좌번호", attributes: [.font: UIFont.designSystem(weight: .regular, size: ._15)])
        v.accountTextField.textField.delegate = self
        return v
    }()
    private lazy var doneButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.setTitle("완료", for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension AccountEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, accountEditField, doneButton)
        
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

// MARK: - Bind
extension AccountEditViewController {
    private func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.pressBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountEditField.chooseBankButton.rx.tap
            .map { Reactor.Action.selectBankButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountEditField.holderTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateHolder(holder: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountEditField.accountTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateAccountNumber(number: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.pressDoneButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.user.bankAccount.bank }
            .asDriver(onErrorJustReturn: "은행선택")
            .drive { [weak self] bank in
                self?.accountEditField.chooseBankButton.setTitle(bank, for: .normal)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.user.bankAccount.accountHolderName }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] placeholder in
                self?.accountEditField.holderTextField.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: UIFont.designSystem(weight: .regular, size: ._15)])
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.user.bankAccount.accountNumber }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] placeholder in
                self?.accountEditField.accountTextField.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: UIFont.designSystem(weight: .regular, size: ._15)])
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isDoneButtonAvailable)
            .asDriver(onErrorJustReturn: false)
            .drive(self.doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: AccountEditViewStep.none)
            .compactMap { $0 }
            .drive { [weak self] in
                self?.route(to: $0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension AccountEditViewController {
    private func route(to: AccountEditViewStep) {
        switch to {
        case .none:
            break
            
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .presentSelectBankView:
            guard let currentReactor = self.reactor else { return }
            let vc = SelectBankViewController()
            let reactor = SelectBankViewReactor(accountEditViewDelegate: currentReactor, parentView: .profileAccountEdit)
            vc.reactor = reactor
            self.navigationController?.present(vc, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AccountEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
             return false
        }
        return true
    }
}

// MARK: - Keyboard Helper
extension AccountEditViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.accountEditField.accountTextField.resignFirstResponder()
        self.accountEditField.holderTextField.resignFirstResponder()
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.doneButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - 15)
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            self.doneButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }
}
