//
//  PaymentCardListViewController.swift
//  App
//
//  Created by Woody on 2022/08/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import RxDataSources

final class PaymentCardListViewController: BaseViewController, View {
    typealias Reactor = PaymentCardListViewReactor

    lazy var navigationBar: NavigationBar = {
        let v = NavigationBar()
        return v
    }()
    lazy var paymentRoomStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 4
        v.alignment = .center
        v.distribution = .fill
        return v
    }()
    lazy var paymentRoomIDLabel: UILabel = {
        let v = UILabel()
        v.text = "정산방 ID : "
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.grayC5C5C5)
        return v
    }()
    lazy var paymentRoomIDCopyButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.init(.btn_copy), for: .normal)
        
        return v
    }()
    lazy var startPaymentAlgorithmButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("정산 시작", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        v.setTitleColor(UIColor.designSystem(.mainBlue), for: .normal)
        v.backgroundColor = .designSystem(.lightBlue)
        return v
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        #warning("통일화시켜야 하는 카드 사이즈")
        layout.estimatedItemSize = .init(width: 340, height: 0)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.contentInset = UIEdgeInsets(top: 13, left: 25, bottom: 25, right: 25)
        v.register(PaymentCardCollectionViewCell.self)
        v.register(AddPaymentCardCollectionViewCell.self)
        v.showsVerticalScrollIndicator = false
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func bind(reactor: Reactor) {
        self.render(reactor: reactor)
        self.dispatch(to: reactor)
    }

    private func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad.map { .setup }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func render(reactor: Reactor) {
        reactor.state.map { $0.paymentRoom?.name }
            .bind(to: navigationBar.titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.paymentRoom?.code }
            .map { "정산방 ID : \($0 ?? "")"}
            .bind(to: paymentRoomIDLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.section }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    lazy var dataSource = paymentCardDataSourceOf()
}

// MARK: setUI

extension PaymentCardListViewController {

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.paymentRoomStackView)
        self.view.addSubview(self.startPaymentAlgorithmButton)
        self.view.addSubview(self.collectionView)
        self.paymentRoomStackView.addArrangedSubviews(self.paymentRoomIDLabel, self.paymentRoomIDCopyButton)

        self.navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.paymentRoomStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
        }
        self.paymentRoomIDCopyButton.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(19)
        }
        self.startPaymentAlgorithmButton.snp.makeConstraints { make in
            make.width.equalTo(98)
            make.height.equalTo(34)
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(self.paymentRoomStackView)
        }
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.paymentRoomIDLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.startPaymentAlgorithmButton.roundCorners(14)
    }
}

// MARK: RxCollectionViewSectionedReloadDataSource

extension PaymentCardListViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource

    func paymentCardDataSourceOf() -> DataSource<PaymentCardSection> {
        return .init(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in

            switch dataSource[indexPath] {
            case .AddPaymentCard:
                let cell = collectionView.dequeueReusableCell(AddPaymentCardCollectionViewCell.self, for: indexPath)
                return cell
            case .PaymentCard(let viewModel):
                let cell = collectionView.dequeueReusableCell(PaymentCardCollectionViewCell.self, for: indexPath)
                cell.viewModel = viewModel
                return cell
            }
        })
    }
}
