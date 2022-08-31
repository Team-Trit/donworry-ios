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
        v.contentInset = UIEdgeInsets(top: 13, left: 25, bottom: 58 + 6 + 20, right: 25)
        v.register(PaymentCardCollectionViewCell.self)
        v.register(AddPaymentCardCollectionViewCell.self)
        v.showsVerticalScrollIndicator = false
        return v
    }()
    lazy var floatingStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    lazy var shareLinkButton: DWButton = {
        let v = DWButton.create(.halfMainBlue)
        v.setTitle("링크 공유", for: .normal)
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .bold))
        v.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration), for: .normal)
        v.semanticContentAttribute = .forceRightToLeft
        let imagePadding: CGFloat = 12
        v.titleEdgeInsets = .init(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
        v.contentEdgeInsets = .init(top: 0, left: imagePadding, bottom: 0, right: 0)
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        return v
    }()
    lazy var checkParticipatedButton: DWButton = {
        let v = DWButton.create(.halfLightBlue)
        v.setTitle("참석 확인", for: .normal)
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .bold))
        v.setImage(UIImage(systemName: "checkmark", withConfiguration: configuration), for: .normal)
        v.semanticContentAttribute = .forceRightToLeft
        let imagePadding: CGFloat = 12
        v.titleEdgeInsets = .init(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
        v.contentEdgeInsets = .init(top: 0, left: imagePadding, bottom: 0, right: 0)
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        v.tintColor = .designSystem(.white)
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

        self.navigationBar.dismissButton.rx.tap.map { .didTapDismissButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.collectionView.rx.itemHighlighted
            .subscribe(onNext: { [weak self] indexPath in
                if let cell = self?.collectionView.cellForItem(at: indexPath) as? PaymentCardCollectionViewCell {
                    UIView.animate(withDuration: 0.22) {
                        cell.transform = .init(scaleX: 0.95, y: 0.95)
                    }
                }
            })
            .disposed(by: disposeBag)

        self.collectionView.rx.itemUnhighlighted
            .subscribe(onNext: { [weak self] indexPath in
                if let cell = self?.collectionView.cellForItem(at: indexPath) as? PaymentCardCollectionViewCell {
                    UIView.animate(withDuration: 0.2) {
                        cell.transform = .identity
                    }
                }
            })
            .disposed(by: disposeBag)

        self.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? PaymentCardCollectionViewCell else { return }
                let viewController = UIViewController()
                viewController.view.backgroundColor = .systemIndigo
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
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

        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: PaymentCardListStep.none)
            .compactMap { $0 }
            .drive(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
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
        self.view.addSubview(self.floatingStackView)
        self.floatingStackView.addArrangedSubviews(self.shareLinkButton, self.checkParticipatedButton)
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
            make.bottom.equalToSuperview()
        }
        self.floatingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(6)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        self.shareLinkButton.snp.makeConstraints { make in

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

// MARK: Routing

extension PaymentCardListViewController {
    private func move(to step: PaymentCardListStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
        case .none:
            break
        }
    }
}
