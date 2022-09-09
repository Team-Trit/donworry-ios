//
//  SentMoneyDetailViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions

final class SentMoneyDetailViewController: BaseViewController, View {
    
    typealias Reactor = SentMoneyDetailViewReactor
    private var statusView: SentMoneyDetailStatusView = {
        let status = SentMoneyDetailStatusView()
        return status
    }()

    private let accountInfo: AccountInformationView = {
        let accontInfo = AccountInformationView()
        accontInfo.layer.masksToBounds = true
        accontInfo.layer.cornerRadius = 8
        accontInfo.backgroundColor = .designSystem(.grayF6F6F6)
        return accontInfo
    }()
    lazy var buttonStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 19
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    lazy var leftButtomButton: DWButton = {
        let v = DWButton.create(.mediumBlue)
        v.title = "상세내역 보기"
        v.addTarget(self, action: #selector(showSheet), for: .touchUpInside)
        return v
    }()

    private let rightButtomButton: DWButton = {
        let v = DWButton.create(.smallBlue)
        v.title = "보냈어요!"
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }

    func bind(reactor: Reactor) {
        rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rightButtomButton.rx.tap.map { .didTapSendButtton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { !$0.isSent }
            .bind(to: rightButtomButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.currentStatus }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.statusView.configure(
                    recievedUser: status?.takerNickname,
                    payment: status?.amount ?? 0,
                    totalAmount: status?.spaceTotalAmount ?? 0
                )
                self?.accountInfo.configure(
                    bank: status?.account.bank ?? "",
                    account: status?.account.number ?? "",
                    name: status?.account.holder ?? ""
                )
            }).disposed(by: disposeBag)

        reactor.pulse(\.$toast)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                DWToastFactory.show(message: "정산 완료 알림을 보냈어요!")
            }).disposed(by: disposeBag)
    }

    @objc private func copyTap() {
        UIPasteboard.general.string = String((reactor?.currentState.currentStatus?.account.number)!)
    }
}

extension SentMoneyDetailViewController {

    private func attributes() {
        self.view.backgroundColor = .white
        let copyTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyTap))
        view.backgroundColor = .white
        accountInfo.addGestureRecognizer(copyTapGesture)
    }

    private func layout() {
        view.addSubview(statusView)
        view.addSubview(accountInfo)
        view.addSubview(self.buttonStackView)
        buttonStackView.addArrangedSubview(self.leftButtomButton)
        buttonStackView.addArrangedSubview(self.rightButtomButton)

        statusView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(150)
        }
        accountInfo.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(90)
        }
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        leftButtomButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
        rightButtomButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
    }
}
