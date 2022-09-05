//
//  EnterRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/24.
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

final class JoinSpaceViewController: BaseViewController, View {

    lazy var dismissButton = UIButton(type: .system)
    private lazy var textField = LimitTextField(frame: .zero, type: .roomCode)
    private lazy var nextButton = DWButton.create(.xlarge50)
    private lazy var titleLabel: UILabel = {
        $0.text = "정산방 코드로 정산에 참가하기"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "cash_and_coins")
        v.contentMode = .scaleAspectFit
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    func bind(reactor: JoinSpaceReactor) {
        dismissButton.rx.tap.map { .didTapDismissButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap.map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        textField.textField.rx.text.compactMap { $0 }
            .map { .typeTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sharedID }
            .map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)

        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showToast(message: $0.localizedDescription)
            }).disposed(by: disposeBag)
    }

    private func showToast(message: String) {
    }
}

// MARK: setUI

extension JoinSpaceViewController {

    private func setUI() {
        self.dismissButton.setTitle("취소", for: .normal)
        self.dismissButton.setTitleColor(.designSystem(.redFF0B0B), for: .normal)
        self.nextButton.title = "다음"
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(dismissButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)

        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 95).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 181).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 118).isActive = true

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.centerX.equalToSuperview()
            make.width.equalTo(182)
            make.height.equalTo(118)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension JoinSpaceViewController {
    func move(to step: JoinSpaceStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
        case .paymentCardList(let space):
            self.dismiss(animated: true) {
                let paymentCardListViewController = PaymentCardListViewController()
                paymentCardListViewController.reactor = PaymentCardListReactor(
                    space: .init(id: space.id, adminID: space.adminID, title: space.title, shareID: space.shareID)
                )
                self.navigationController?.pushViewController(paymentCardListViewController, animated: true)
            }
        }
    }
}
