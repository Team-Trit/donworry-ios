//
//  PaymentCardIconEditViewController.swift
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

final class PaymentCardIconEditViewController: BaseViewController, View {
    typealias Reactor = PaymentCardIconEditViewReactor

    // MARK: - Views
    private lazy var navigationBar = DWNavigationBar(title: "", rightButtonImageName: "xmark")

    private lazy var titleLabel: UILabel = {
        $0.text = "정산내역 아이콘을\n선택해주세요"
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 10.0)
        $0.font = .designSystem(weight: .heavy, size: ._25)
        return $0
    }(UILabel())
    
    private lazy var nextButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "다음"
        v.isEnabled = false
        return v
    }()

    private lazy var iconCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
        cv.isScrollEnabled = false
        return cv
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    // MARK: - Binding
    func bind(reactor: Reactor) {
        self.render(reactor: reactor)
        self.dispatch(to: reactor)
    }
    
    func dispatch(to reactor: Reactor) {
        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.nextButton.rx.tap.map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.rightItem?.rx.tap.map { .didTapCloseButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.iconCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.iconCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)

        self.iconCollectionView.rx.itemSelected
            .compactMap { [weak self] in
                self?.iconCollectionView.cellForItem(at: $0) as? PaymentIconCell
            }.compactMap { $0.viewModel?.id }
            .map { .didTapIconCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func render(reactor: Reactor) {
        
        reactor.state.map{ $0.paymentCard.name }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.categoryCellViewModel }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.iconCollectionView.reloadData()
            }).disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }
    
    
}

extension PaymentCardIconEditViewController {
    func move(to step: PaymentCardIconEditStep) {
        switch step {
        case .pop:
            navigationController?.popViewController(animated: true)
        case .paymentCardAmountEdit:
            navigationController?.pushViewController(paymentCardAmountEditViewController(), animated: true)
        case .paymentCardList:
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
        }
    }

    private func paymentCardAmountEditViewController() -> UIViewController {
        let paymentCardAmountEditViewController = PaymentCardAmountEditViewController()
        let newPaymentCard = reactor!.currentState.paymentCard
        paymentCardAmountEditViewController.reactor = PaymentCardAmountEditReactor(paymentCard: newPaymentCard)
        return paymentCardAmountEditViewController
    }
}

// MARK: - setUI

extension PaymentCardIconEditViewController {
    
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, nextButton, iconCollectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 40)
        }
        iconCollectionView.register(PaymentIconCell.self, forCellWithReuseIdentifier: "PaymentIconCell")
        
        iconCollectionView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.top.equalTo(titleLabel.snp.bottom).offset(57.5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
}


// MARK: - CollectionView

extension PaymentCardIconEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(102), heightDimension: .absolute(102))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.categoryCellViewModel.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentIconCell", for: indexPath) as? PaymentIconCell,
              let reactor = reactor else { return UICollectionViewCell() }
        let viewModel = reactor.currentState.categoryCellViewModel[indexPath.item]
        cell.configure(with: viewModel)
        let isSelected = viewModel.id == reactor.currentState.paymentCard.categoryID
        cell.setBackgroundColor(isSelected: isSelected)
        return cell
    }
}
