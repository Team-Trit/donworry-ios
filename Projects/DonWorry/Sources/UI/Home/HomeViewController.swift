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
import RxSwift
import SnapKit

final class HomeViewController: BaseViewController, ReactorKit.View {
    typealias Reactor = HomeReactor

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func bind(reactor: Reactor) {
        self.render(reactor)
        self.dispatch(to: reactor)
    }

    private func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad.map { _ in .setup }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.gotoSearchPaymentRoomButton.rx.tap.map { .didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.goToCreatePaymentRoomButton.rx.tap.map { .didTapCreatePaymentRoomButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.headerView.profileButton.rx.tap.map { .didTapProfileImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.headerView.alarmButton.rx.tap.map { .didTapAlarm }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.paymentRoomCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.billCardCollectionView.scrollToItem(
                    at: .init(item: 0, section: 0),
                    at: .centeredHorizontally, animated: false
                )
            }).disposed(by: disposeBag)

        self.billCardCollectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in self?.billCardCollectionView.cellForItem(at: indexPath) }
            .map { cell in
                switch cell.tag {
                case 0:
                    return .didTapStateBillCard
                case 1:
                    return .didTapTakeBillCard
                case 2:
                    return .didTapGiveBillCard
                case 3:
                    return .didTapLeaveBillCard(reactor.currentState.selectedSpaceIndex)
                default:
                    return .none
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.homeHeader }
            .bind(to: self.headerView.rx.viewModel)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceViewModelList.isNotEmpty }
            .bind(to: self.emptyView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceViewModelList.isEmpty }
            .bind(to: self.billCardCollectionView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] section in
                self?.billCardCollectionView.reloadData()
            }).disposed(by: disposeBag)

        paymentRoomCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)

        paymentRoomCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        billCardCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)

        reactor.pulse(\.$reload)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.paymentRoomCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)
    }

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

// MARK: Routing

extension HomeViewController {
    private func move(to step: HomeStep) {
        switch step {
        case .editRoom:
            let editRoomViewController = EditRoomNameViewController(type: .create)
            self.navigationController?.pushViewController(editRoomViewController, animated: true)
        case .enterRoom:
            let enterRoomViewController = EnterRoomViewController()
            self.present(enterRoomViewController, animated: true)
        case .recievedMoneyDetail:
            let recieveMoneyDetailViewController = RecievedMoneyDetailViewViewController()
            self.present(recieveMoneyDetailViewController, animated: true)
        case .sentMoneyDetail:
            let sentMoneyDetailViewController = SentMoneyDetailViewViewController()
            self.present(sentMoneyDetailViewController, animated: true)
        case .alert:
            let alertViewController = AlertViewViewController()
            self.navigationController?.pushViewController(alertViewController, animated: true)
        case .profile:
            let profileViewController = ProfileViewController()
            profileViewController.reactor = ProfileViewReactor()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        case .paymentCardList:
            guard let reactor = reactor else { return }
            let paymentCardListViewController = PaymentCardListViewController()
            let selectedIndex = reactor.currentState.selectedSpaceIndex
            let selectedSpace = reactor.currentState.spaceList[selectedIndex]
            paymentCardListViewController.reactor = PaymentCardListReactor(space: selectedSpace)
            self.navigationController?.pushViewController(paymentCardListViewController, animated: true)
        case .none:
            break
        }
    }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch collectionView {
        case paymentRoomCollectionView:
            return reactor?.currentState.spaceViewModelList.count ?? 0
        case billCardCollectionView:
            return reactor?.currentState.sections[0].items.count ?? 1
        default:
            return 0
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case paymentRoomCollectionView:
            return paymentRoomCollectionViewCell(for: indexPath)
        case billCardCollectionView:
            return billCardCollectionViewCell(for: indexPath)
        default:
            return .init()
        }
    }
    private func paymentRoomCollectionViewCell(
        for indexPath: IndexPath
    ) -> PaymentRoomCollectionViewCell {
        guard let reactor = reactor else { return .init() }
        let cell = paymentRoomCollectionView.dequeueReusableCell(
            PaymentRoomCollectionViewCell.self,
            for: indexPath
        )
        cell.viewModel = reactor.currentState.spaceViewModelList[indexPath.item]
        return cell
    }
    private func billCardCollectionViewCell(
        for indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let reactor = reactor else { return .init() }
        switch reactor.currentState.sections[0].items[indexPath.item] {
        case .GiveBillCard(let viewModel):
            return giveBillCardCollectionViewCell(for: indexPath, viewModel: viewModel)
        case .TakeBillCard(let viewModel):
            return takeBillCardCollectionViewCell(for: indexPath, viewModel: viewModel)
        case .StateBillCard:
            return stateBillCardCollectionViewCell(for: indexPath)
        case .LeaveBillCard:
            return leaveBillCardCollectionViewCell(for: indexPath)
        }
    }
    private func giveBillCardCollectionViewCell(
        for indexPath: IndexPath,
        viewModel: GiveBillCardCellViewModel
    ) -> GiveBillCardCollectionViewCell {
        let cell = billCardCollectionView.dequeueReusableCell(
            GiveBillCardCollectionViewCell.self,
            for: indexPath
        )
        cell.tag = 1
        cell.viewModel = viewModel
        return cell
    }
    private func takeBillCardCollectionViewCell(
        for indexPath: IndexPath,
        viewModel: TakeBillCardCellViewModel
    ) -> TakeBillCardCollectionViewCell {
        let cell = billCardCollectionView.dequeueReusableCell(
            TakeBillCardCollectionViewCell.self,
            for: indexPath
        )
        cell.tag = 2
        cell.viewModel = viewModel
        return cell
    }
    private func stateBillCardCollectionViewCell(
        for indexPath: IndexPath
    ) -> StateBillCardCollectionViewCell {
        let cell = billCardCollectionView.dequeueReusableCell(
            StateBillCardCollectionViewCell.self,
            for: indexPath
        )
        cell.tag = 0
        return cell
    }
    private func leaveBillCardCollectionViewCell(
        for indexPath: IndexPath
    ) -> LeavePaymentRoomBillCardCollectionViewCell {
        let cell = billCardCollectionView.dequeueReusableCell(
            LeavePaymentRoomBillCardCollectionViewCell.self,
            for: indexPath
        )
        cell.tag = 3
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reactor = reactor else { return }
        reactor.action.onNext(.didSelectPaymentRoom(at: indexPath.item))
        paymentRoomCollectionView.reloadItems(at: [
            IndexPath(item: reactor.currentState.selectedSpaceIndex, section: 0),
            IndexPath(item: reactor.currentState.beforeSelectedSpaceIndex, section: 0)
        ])
    }
}
