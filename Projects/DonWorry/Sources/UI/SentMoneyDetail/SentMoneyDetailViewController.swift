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

    private let questionButton: UIImageView = {
        let questionButton = UIImageView()
        questionButton.image = UIImage(named: "QuestionMark")
        return questionButton
    }()

    private let accountInfo: AccountInformationView = {
        let accontInfo = AccountInformationView()
        accontInfo.configure(bank: "우리은행", account: "1002 - 045 - 401235", name: "임영후")
        accontInfo.layer.masksToBounds = true
        accontInfo.layer.cornerRadius = 8
        accontInfo.backgroundColor = .designSystem(.grayF6F6F6)
        return accontInfo
    }()

    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .designSystem(.grayF6F6F6)
        return separatorView
    }()

    private let questionView: QuestionInformationView = {
        let questionView = QuestionInformationView()
        questionView.isHidden = true
        questionView.frame = CGRect(x: 195, y: 70, width: 168, height: 76)
        questionView.layer.masksToBounds = true
        questionView.layer.cornerRadius = 8
        questionView.backgroundColor = .designSystem(.white)
        return questionView
    }()

    private let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.text = "총 정산 내역"
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        subTitle.textColor = .black
        return subTitle
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SentMoneyTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()

    lazy var buttonStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 19
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    private let leftButtomButton: DWButton = {
        let v = DWButton.create(.mediumBlue)
        v.title = "계좌번호 복사하기"
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

        reactor.state.map { $0.currentStatus }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.statusView.configure(
                    recievedUser: status?.takerNickname,
                    payment: status?.amount ?? 0,
                    totalAmount: status?.spaceTotalAmount ?? 0
                )
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

    @objc private func appearInfoTap() {
        questionView.isHidden.toggle()
    }

    @objc private func copyTap() {
        UIPasteboard.general.string = String((reactor?.currentState.currentStatus?.account.number)!)
    }
}

extension SentMoneyDetailViewController {

    private func attributes() {
        self.view.backgroundColor = .white
        let appearTapGesture = UITapGestureRecognizer(target: self, action: #selector(appearInfoTap))
        let copyTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyTap))
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        questionButton.addGestureRecognizer(appearTapGesture)
        questionButton.isUserInteractionEnabled = true
        accountInfo.addGestureRecognizer(copyTapGesture)
    }

    private func layout() {
        view.addSubview(statusView)
        view.addSubview(questionView)
        view.addSubview(accountInfo)
        view.addSubview(separatorView)
        view.addSubview(subTitle)
        view.addSubview(tableView)
        view.addSubview(self.buttonStackView)
        buttonStackView.addArrangedSubview(self.leftButtomButton)
        buttonStackView.addArrangedSubview(self.rightButtomButton)

        statusView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(150)
        }
        accountInfo.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(90)
        }
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(1)
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(buttonStackView.snp.top).offset(10)
        }
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        // 이거 statusView 안에 들어가야 하는거 아닌가요? 유스
//        questionButton.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 78).isActive = true
//        questionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 160).isActive = true
//        questionButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        questionButton.widthAnchor.constraint(equalToConstant: 18).isActive = true

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

extension SentMoneyDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return reactor?.currentState.cards.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SentMoneyTableViewCell.self, for: indexPath)
        cell.configure(
            icon: "flame.fill",
            myPayment: reactor!.currentState.cards[indexPath.row]
        )
        return cell
    }
}
