//
//  ReceivedMoneyDetailViewController.swift
//  App
//
//  Created by uiskim on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import BaseArchitecture
import DesignSystem
import ReactorKit
import DonWorryExtensions

final class RecievedMoneyDetailViewController: BaseViewController, View {
    typealias Reactor = ReceivedMoneyDetailReactor
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        button.addTarget(self, action: #selector(sheetClosed), for: .touchUpInside)
        return button
    }()

    private var statusView: RecieveMoneyDetailStatusView = {
        let status = RecieveMoneyDetailStatusView()
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .designSystem(.white)
        return separatorView
    }()
    private let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.text = "상세내역"
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return subTitle
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecievedMoneyTableViewCell.self, forCellReuseIdentifier: RecievedMoneyTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()
    private let bottomButton: DWButton = {
        let buttonButton = DWButton.create(.xlarge50)
        buttonButton.translatesAutoresizingMaskIntoConstraints = false
        buttonButton.title = "재촉하기"
        return buttonButton
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attributes()
        layout()
    }
    
    @objc func sheetClosed() {
        self.dismiss(animated: true)
        
    }

    func bind(reactor: Reactor) {
        rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bottomButton.rx.tap.map { .didTapBottomButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentStatus }
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.statusView.configure(payment: $0.currentAmount, outstanding: $0.totalAmount)
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

}

extension RecievedMoneyDetailViewController {

    private func attributes() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(statusView)
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 10).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        view.addSubview(subTitle)
        subTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
        subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        subTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 440).isActive = true

        view.addSubview(bottomButton)
        bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        giveSidePadding(someView: bottomButton, side: 27)
    }

    func giveSidePadding(someView: UIView, side: Int) {
        someView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(side)).isActive = true
        someView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-side)).isActive = true
    }
}

extension RecievedMoneyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.payments.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor = reactor else { return .init() }
        let cell = tableView.dequeueReusableCell(RecievedMoneyTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.configure(reactor.currentState.payments[indexPath.row])
        return cell
    }
}

extension RecievedMoneyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
