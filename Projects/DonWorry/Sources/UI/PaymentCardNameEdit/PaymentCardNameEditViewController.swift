//
//  PaymentCardNameEditViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import SnapKit


final class PaymentCardNameEditViewController: BaseViewController, View {
    typealias Reactor = PaymentCardNameEditViewReactor

    // MARK: - Views
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())

    private lazy var paymentNameLabel = LimitTextField(frame: .zero, type: .paymentTitle)

    private lazy var nextButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "다음"
        return v
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }

    // MARK: - Binding
    func bind(reactor: PaymentCardNameEditViewReactor) {
        self.render(reactor: reactor)
        self.dispatch(to: reactor)
    }
    
    func dispatch(to reactor: Reactor) {
        self.nextButton.rx.tap.map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.paymentNameLabel.textField.rx.text
            .compactMap { $0 }
            .map { .typeCardName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func render(reactor: Reactor) {

        self.paymentNameLabel.textField.rx.text.map { !($0?.isEmpty ?? false) }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.type }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.titleLabel.text = self?.setTitleLabelText(type: $0)
            }).disposed(by: disposeBag)

        reactor.state.map{ $0.paymentCard.name }
            .bind(to: paymentNameLabel.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step, reactor: reactor)
            }).disposed(by: disposeBag)
    }
}

extension PaymentCardNameEditViewController {
    func move(to step: PaymentCardNameEditStep, reactor: Reactor) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .paymentCardIconEdit:
            let paymentCardIconEditViewController = PaymentCardIconEditViewController()
            paymentCardIconEditViewController.reactor =
            PaymentCardIconEditViewReactor(paymentCard: reactor.currentState.paymentCard)
            self.navigationController?.pushViewController(paymentCardIconEditViewController, animated: true)
        }
    }
}
// MARK: - setUI

extension PaymentCardNameEditViewController {

    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, paymentNameLabel, nextButton)

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        paymentNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// 배경 터치시  포커싱 해제
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.paymentNameLabel.textField.resignFirstResponder()
    }

    /// 키보드 Show 시에 위치 조정
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - 15)
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    /// 키보드 Hide 시에 위치 조정
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }


}

extension PaymentCardNameEditViewController {
    private func setTitleLabelText(type: Reactor.PaymentCardNameEditViewType) -> String {
        switch type {
        case .create:
            return "정산내역을\n추가해볼까요?"
        case .update:
            return "정산항목명을\n수정해볼까요?"
        }
    }

    private func setPlaceholderText(type: Reactor.PaymentCardNameEditViewType)  -> String {
        switch type {
        case .create:
            return "정산하고자 하는 항목을 입력하세요"
        case .update:
            return "정산항목명을 입력하세요"
        }
    }
}
