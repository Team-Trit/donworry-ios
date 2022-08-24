//
//  HomeViewController.swift
//  App
//
//  Created by Woody on 2022/08/08.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import DonWorryExtensions
import DesignSystem
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class HomeViewController: BaseViewController, ReactorKit.View {
    typealias Reactor = HomeViewReactor

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func bind(reactor: Reactor) {
        self.render(reactor)
        self.dispatch(to: reactor)
    }

    private func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad.map { .setup }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.gotoSearchPaymentRoomButton.rx.tap.map { .didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.goToCreatePaymentRoomButton.rx.tap.map { .didTapCreatePaymentRoomButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.headerView.alarmButton.rx.tap.map { .didTapAlarm }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.paymentRoomCollectionView.rx.itemSelected.map { .didSelectPaymentRoom(at: $0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.paymentRoomCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.billCardCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }).disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.homeHeader }
            .bind(to: self.headerView.rx.viewModel)
            .disposed(by: disposeBag)

        reactor.state.map { $0.paymentRoomList.isNotEmpty }
            .bind(to: self.emptyView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections.isEmpty }
            .bind(to: self.billCardCollectionView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.paymentRoomList }
            .bind(to: self.paymentRoomCollectionView.rx.items(
                cellIdentifier: PaymentRoomCollectionViewCell.identifier,
                cellType: PaymentRoomCollectionViewCell.self)
            ) { item, cellModel, cell in
                let selectedIndex: Int = reactor.currentState.selectedPaymentRoomIndex
                cell.viewModel = .init(title: cellModel.name, isSelected: selectedIndex == item)
            }.disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: self.billCardCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    lazy var dataSource = paymentCardDataSourceOf()
    lazy var headerView = HomeHeaderView()
    lazy var paymentRoomCollectionView = PaymentRoomCollectionView()
    lazy var billCardCollectionView = BillCardCollectionView()
    lazy var emptyView = EmptyPaymentCardView()
    lazy var gotoSearchPaymentRoomButton: UIButton = {
        let v = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy)
        v.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal)
        v.tintColor = .designSystem(.white)
        v.backgroundColor = .designSystem(.grayC5C5C5)
        return v
    }()
    lazy var goToCreatePaymentRoomButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("정산방 만들기", for: .normal)
        v.setTitleColor(.designSystem(.white), for: .normal)
        v.titleLabel?.font = .designSystem(weight: .heavy, size: ._15)
        return v
    }()
}

// MARK: setUI

extension HomeViewController {

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.paymentRoomCollectionView)
        self.view.addSubview(self.billCardCollectionView)
        self.view.addSubview(self.gotoSearchPaymentRoomButton)
        self.view.addSubview(self.goToCreatePaymentRoomButton)
        self.view.addSubview(self.emptyView)

        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        self.paymentRoomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        self.billCardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.paymentRoomCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.gotoSearchPaymentRoomButton.snp.makeConstraints { make in
            make.top.equalTo(self.billCardCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(58)
        }
        self.goToCreatePaymentRoomButton.snp.makeConstraints { make in
            make.top.equalTo(self.billCardCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(self.gotoSearchPaymentRoomButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(25)
            make.width.equalTo(self.gotoSearchPaymentRoomButton.snp.width).multipliedBy(262/70)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(58)
        }
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.goToCreatePaymentRoomButton.snp.top)
        }

        self.gotoSearchPaymentRoomButton.roundCorners(29)
        self.goToCreatePaymentRoomButton.roundCorners(29)
        self.goToCreatePaymentRoomButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
    }
}

extension HomeViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource

    func paymentCardDataSourceOf() -> DataSource<BillCardSection> {
           return .init(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in

               switch dataSource[indexPath] {
               case .GivePaymentCard(let viewModel):
                   let cell = collectionView.dequeueReusableCell(GiveBillCardCollectionViewCell.self, for: indexPath)
                   cell.viewModel = viewModel
                   return cell
               case .TakePaymentCard(let viewModel):
                   let cell = collectionView.dequeueReusableCell(TakeBillCardCollectionViewCell.self, for: indexPath)
                   cell.viewModel = viewModel
                   return cell
               case .StatePaymentCard:
                   let cell = collectionView.dequeueReusableCell(StateBillCardCollectionViewCell.self, for: indexPath)
                   return cell
               case .LeavePaymentCard:
                   let cell = collectionView.dequeueReusableCell(LeavePaymentRoomBillCardCollectionViewCell.self, for: indexPath)
                   return cell
               }
           })
       }
}