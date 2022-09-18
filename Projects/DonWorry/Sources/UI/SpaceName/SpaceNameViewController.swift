//
//  SpaceNameViewController.swift
//  DonWorry
//
//  Created by 임영후 on 2022/08/21.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import SnapKit


final class SpaceNameViewController: BaseViewController, View {

    // MARK: - Views
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())

    private lazy var spaceNameView = LimitTextField(frame: .zero, type: .roomName)
    private lazy var nextButton = DWButton.create(.xlarge58)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }

    // MARK: - Binding

    func bind(reactor: SpaceNameReactor) {
        reactor.state.map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.placeHolderText }
            .subscribe(onNext: { [weak self] in
                self?.spaceNameView.textField.placeholder = $0
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.buttonText ?? "완료" }
            .subscribe(onNext: { [weak self] in
                self?.nextButton.title = $0
            }).disposed(by: disposeBag)

        reactor.state.map { $0.spaceName }
            .map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.spaceNameView.textField.rx.text.compactMap { .typeTextField($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.nextButton.rx.tap.map { .didTapButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)
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
        self.spaceNameView.textField.resignFirstResponder()
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

// MARK: - setUI

extension SpaceNameViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, spaceNameView, nextButton)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        spaceNameView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Routing

extension SpaceNameViewController {
    func move(to step: SpaceNameStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .cardList(let space):
            let paymentCardListViewController = PaymentCardListViewController()
            paymentCardListViewController.reactor = PaymentCardListReactor(
                spaceID: space.id, adminID: space.adminID, status: space.status
            )
            self.navigationController?.pushViewController(paymentCardListViewController, animated: true)
        }
    }
}
