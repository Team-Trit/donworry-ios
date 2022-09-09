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
    
    // MARK: 테스트용 local storage service
    let service = UserServiceImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }
    

    func bind(reactor: Reactor) {
        self.render(reactor)
        self.dispatch(to: reactor)
    }

    private func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad.map { _ in .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.rx.viewWillAppear.map { _ in .viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.gotoSearchSpaceButton.rx.tap.map { .didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.goToCreateSpaceButton.rx.tap.map { .didTapCreateSpaceButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.headerView.profileButton.rx.tap.map { .didTapProfileImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.headerView.alarmButton.rx.tap.map { .didTapAlarm }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.spaceCollectionView.rx.itemSelected
            .do(onNext: { [weak self] _ in
                self?.billCardCollectionView.scrollToItem(
                    at: .init(item: 0, section: 0),
                    at: .centeredHorizontally, animated: false
                )
            })
            .map { .didSelectSpace(at: $0.item) }
            .bind(to: reactor.action)

            .disposed(by: disposeBag)

        self.billCardCollectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.billCardCollectionView.cellForItem(at: indexPath)
            }.map { cell in
                switch cell.tag {
                case 0:
                    return .didTapStateBillCard
                case 1:
                    return .didTapTakeBillCard
                case 2:
                    guard let cell = cell as? GiveBillCardCollectionViewCell else { fatalError() }
                    return .didTapGiveBillCard(cell.viewModel?.id ?? 0)
                case 3:
                    return .didTapLeaveBillCard
                default:
                    return .none
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.homeHeader }
            .observe(on: MainScheduler.instance)
            .bind(to: self.headerView.rx.viewModel)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceViewModelList.isNotEmpty }
            .observe(on: MainScheduler.instance)
            .bind(to: self.emptyView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceViewModelList.isEmpty }
            .observe(on: MainScheduler.instance)
            .bind(to: self.billCardCollectionView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.spaceViewModelList }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.spaceCollectionView.reloadSections(IndexSet(integer: 0))
            }).disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] section in
                self?.billCardCollectionView.reloadData()
            }).disposed(by: disposeBag)

        spaceCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)

        billCardCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)

        reactor.pulse(\.$reload)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.spaceCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.move(to: $0)
            }).disposed(by: disposeBag)
    }

    lazy var headerView = HomeHeaderView()
    lazy var spaceCollectionView = SpaceCollectionView()
    lazy var billCardCollectionView = BillCardCollectionView()
    lazy var emptyView = EmptyPaymentCardView()
    lazy var gotoSearchSpaceButton: UIButton = {
        let v = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy)
        v.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal)
        v.tintColor = .designSystem(.white)
        v.backgroundColor = .designSystem(.grayC5C5C5)
        return v
    }()
    lazy var goToCreateSpaceButton: UIButton = {
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
        self.view.addSubview(self.spaceCollectionView)
        self.view.addSubview(self.billCardCollectionView)
        self.view.addSubview(self.gotoSearchSpaceButton)
        self.view.addSubview(self.goToCreateSpaceButton)
        self.view.addSubview(self.emptyView)

        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        self.spaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        self.billCardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.spaceCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.gotoSearchSpaceButton.snp.makeConstraints { make in
            make.top.equalTo(self.billCardCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(58)
        }
        self.goToCreateSpaceButton.snp.makeConstraints { make in
            make.top.equalTo(self.billCardCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(self.gotoSearchSpaceButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(25)
            make.width.equalTo(self.gotoSearchSpaceButton.snp.width).multipliedBy(262/70)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(58)
        }
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.goToCreateSpaceButton.snp.top)
        }

        self.gotoSearchSpaceButton.roundCorners(29)
        self.goToCreateSpaceButton.roundCorners(29)
        self.goToCreateSpaceButton.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(routeToPaymentListScene), name: .init("com.TriT.DonWorry.joinSpace"), object: nil)
    }

    @objc
    private func routeToPaymentListScene(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Int] else { return }
        guard let spaceID = userInfo["joinSpace.spaceID"],
              let adminID = userInfo["joinSpace.adminID"] else { return }
        move(to: .spaceList(spaceID, adminID))
    }
}

// MARK: Routing

extension HomeViewController {
    private func move(to step: HomeStep) {
        switch step {
        case .spaceName:
            let spaceNameViewController = SpaceNameViewController()
            spaceNameViewController.reactor = SpaceNameReactor(type: .create)
            self.navigationController?.pushViewController(spaceNameViewController, animated: true)
        case .joinSpace:
            let joinSpaceViewController = SheetViewController()
//            joinSpaceViewController.reactor = JoinSpaceReactor()
            self.present(joinSpaceViewController, animated: true)
        case .recievedMoneyDetail(let spaceID):
            let recieveMoneyDetailViewController = RecievedMoneyDetailViewController()
            recieveMoneyDetailViewController.reactor = ReceivedMoneyDetailReactor(spaceID: spaceID)
            self.present(recieveMoneyDetailViewController, animated: true)
        case .sentMoneyDetail(let spaceID, let paymentID):
            let sentMoneyDetailViewController = SentMoneyDetailViewController()
            sentMoneyDetailViewController.reactor = SentMoneyDetailViewReactor(spaceID: spaceID, paymentID: paymentID)
            self.present(sentMoneyDetailViewController, animated: true)
        case .alert:
            let alertViewController = AlertViewViewController()
            self.navigationController?.pushViewController(alertViewController, animated: true)
        case .profile:
            let profileViewController = ProfileViewController()
            profileViewController.reactor = ProfileViewReactor()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        case .leaveAlertMessage:
            self.present(confirmLeaveAlertController(), animated: true)
        case .cantLeaveSpace:
            self.present(cantLeaveAlertController(), animated: true)
        case .spaceList(let spaceID, let adminID):
            let paymentCardListViewController = PaymentCardListViewController()
            paymentCardListViewController.reactor = PaymentCardListReactor(
                spaceID: spaceID, adminID: adminID
            )
            self.navigationController?.pushViewController(paymentCardListViewController, animated: true)
        case .none:
            break
        }
    }

    private func confirmLeaveAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "정산방을 나가실건가요?", message: nil, preferredStyle: .alert)
        let leave = UIAlertAction(title: "나갈래요", style: .default) { _ in
            self.reactor?.action.onNext(.didTapLeaveBillCard)
        }
        let cancel = UIAlertAction(title: "잘못 눌렀어요", style: .cancel)

        alert.addAction(leave)
        alert.addAction(cancel)
        return alert
    }
    private func cantLeaveAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "정산을 완료되기 전까지 못 나가요 💸", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "정산할게요...", style: .cancel)
        alert.addAction(cancel)
        return alert
    }

}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch collectionView {
        case spaceCollectionView:
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
        case spaceCollectionView:
            return spaceCollectionViewCell(for: indexPath)
        case billCardCollectionView:
            return billCardCollectionViewCell(for: indexPath)
        default:
            return .init()
        }
    }
    private func spaceCollectionViewCell(
        for indexPath: IndexPath
    ) -> SpaceCollectionViewCell {
        guard let reactor = reactor else { return .init() }
        let cell = spaceCollectionView.dequeueReusableCell(
            SpaceCollectionViewCell.self,
            for: indexPath
        )
        let isSelected = indexPath.item == reactor.currentState.selectedSpaceIndex
        if isSelected { cell.selectedAttributes() }
        else { cell.initialAttributes() }
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
        cell.tag = 2
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
        cell.tag = 1
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
    ) -> LeaveSpaceBillCardCollectionViewCell {
        let cell = billCardCollectionView.dequeueReusableCell(
            LeaveSpaceBillCardCollectionViewCell.self,
            for: indexPath
        )
        cell.tag = 3
        return cell
    }
}
