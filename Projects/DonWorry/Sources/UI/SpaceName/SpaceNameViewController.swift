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

    private lazy var roomInfoLabel = LimitTextField(frame: .zero, type: .roomName)
    private lazy var nextButton = DWButton.create(.xlarge58)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    // MARK: - Binding

    func bind(reactor: SpaceNameReactor) {
        reactor.state.map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.placeHolderText }
            .subscribe(onNext: { [weak self] in
                self?.roomInfoLabel.textField.placeholder = $0
            }).disposed(by: disposeBag)

        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap.map { .didTapButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)
    }

}

// MARK: - setUI

extension SpaceNameViewController {
    private func setUI() {
        nextButton.title = "정산방 참가하기"
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, roomInfoLabel, nextButton)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        roomInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.trailing.equalToSuperview().inset(25)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
    }
}

// MARK: Routing

extension SpaceNameViewController {
    func move(to step: SpaceNameStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .cardList:
            guard let first = self.navigationController?.viewControllers[0] else { return }
            let paymentCardListViewController = PaymentCardListViewController()
            self.navigationController?.setViewControllers([
                first,
                paymentCardListViewController
            ], animated: true)
        }
    }
}
