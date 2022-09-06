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

    // MARK: - Init

    var type: PaymentCardNameEditViewType = .create

    convenience init(type: PaymentCardNameEditViewType) {
        self.init()
        self.type = type
    }

    // MARK: - Views
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        $0.text = setTitleLabelText(type: type)
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
        self.hideKeyboardWhenTappedAround()
        setUI()
    }

    // MARK: - Binding
    func bind(reactor: PaymentCardNameEditViewReactor) {
        self.render(reactor: reactor)
        self.dispatch(to: reactor)
    }
    
    func dispatch(to reactor: PaymentCardNameEditViewReactor) {        self.nextButton.rx.tap.map { .didTapNextButton(self.type) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func render(reactor: PaymentCardNameEditViewReactor) {
        
        reactor.state.map{ $0.paymentCard.name }
            .bind(to: paymentNameLabel.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }
    

}

extension PaymentCardNameEditViewController {
    func move(to step: PaymentCardNameEditStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .paymentCardIconEdit:
            let paymentCardIconEditViewController = PaymentCardIconEditViewController()
            paymentCardIconEditViewController.reactor =
                PaymentCardIconEditViewReactor(spaceId: 43,
                                               paymentCard: PaymentCardModels.PostCard.Request(spaceID: 42, categoryID: 5, bank: "신한은행", number: "", holder: "", name: "맛찬들", totalAmount: 0, bgColor: "", paymentDate: ""))
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

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(50)
        }
    }

}

// MARK: - Method
extension PaymentCardNameEditViewController {
    private func setTitleLabelText(type: PaymentCardNameEditViewType) -> String {
        switch type {
        case .create:
            return "정산내역을\n추가해볼까요?"
        case .update:
            return "정산항목명을\n수정해볼까요?"
        }
    }

    private func setPlaceholderText(type: PaymentCardNameEditViewType)  -> String {
        switch type {
        case .create:
            return "정산하고자 하는 항목을 입력하세요"
        case .update:
            return "정산항목명을 입력하세요"
        }
    }
}
