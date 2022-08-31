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
    enum PaymentCardNameEditViewType {
        case create //default
        case update
    }

    var type: PaymentCardNameEditViewType = .create

    convenience init(type: PaymentCardNameEditViewType) {
        self.init()
        self.type = type
    }

    // MARK: - Views
    // TODO: Navigation bar title 설정해줘야함
    private lazy var navigationBar = CustomNavigationBar()
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
        v.isEnabled = false
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
        //binding here
    }

}

// MARK: - setUI

extension PaymentCardNameEditViewController {

    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, paymentNameLabel, nextButton)

        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(50)
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
