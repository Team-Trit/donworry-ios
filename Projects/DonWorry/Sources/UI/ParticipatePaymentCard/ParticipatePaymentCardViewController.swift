//
//  ParticipatePaymentCardViewController.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Combine
import UIKit

import BaseArchitecture
import DesignSystem
import DonWorryExtensions
import Models
import ReactorKit
import RxCocoa
import RxSwift

final class ParticipatePaymentCardViewController: BaseViewController, View {
    typealias Reactor = ParticipatePaymentCardViewReactor

    private var numberOfselectedCardsLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._17)
        label.textColor = .designSystem(.mainBlue)
        return label
    }()
    
    private var cancleSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택해제", for: .normal)
        button.tintColor = .designSystem(.black)
        button.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var participateCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = Constants.collectionViewMinLineSpacing
        collectionViewFlowLayout.headerReferenceSize = .init(width: 100, height: 38)
        collectionViewFlowLayout.footerReferenceSize = .init(width: 100, height: 74)
        collectionViewFlowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.showsHorizontalScrollIndicator = false
        view.register(ParticipateCollectionViewCell.self, forCellWithReuseIdentifier: ParticipateCollectionViewCell.cellID)
      return view
    }()
    
    private lazy var selectAllButton: UIButton = {
        let bt = DWButton.create(.halfMainBlue)
        bt.setTitle("모두 선택", for: .normal)
        return bt
    }()
    
    private lazy var checkAttendanceButton: UIButton = {
        let bt = DWButton.create(.halfLightBlue)
        bt.setTitle("참석 확인", for: .normal)
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
        configNavigationBar()
    }

    func bind(reactor: ParticipatePaymentCardViewReactor) {
        checkAttendanceButton.rx.tap.map { .didTapAttendanceButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selectAllButton.rx.tap.map { .didTapSelectAllButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        cancleSelectButton.rx.tap.map { .didTapCancelSelectButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        cancelButton.rx.tap.map { .didTapCancelButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.cardList.filter { $0.isSelected }}
            .map { "\($0.count)"}
            .bind(to: numberOfselectedCardsLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.cardList }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.participateCollectionView.reloadData()
            }).disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)

        reactor.pulse(\.$toast)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { toast in
                DWToastFactory.show(message: toast, type: .error)
            }).disposed(by: disposeBag)

    }
}

// MARK: Routing

extension ParticipatePaymentCardViewController {

    func move(to step: ParticipatePaymentCardStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
        }
    }
}
// MARK: setUI

extension ParticipatePaymentCardViewController {

    private func configNavigationBar() {
        
        navigationItem.title = "참석확인"
        let cancelEmptyView = UIView()
        cancelEmptyView.setWidth(width: 4)
        
        let cancelButtonContainer = UIStackView(arrangedSubviews: [cancelEmptyView, cancelButton])
        cancelButtonContainer.spacing = Constants.betweenNumberAndLabel
        let leftBarbutton = UIBarButtonItem(customView: cancelButtonContainer)
        navigationItem.leftBarButtonItem = leftBarbutton
        
        let selectEmptyView = UIView()
        selectEmptyView.setWidth(width: 4)
        
        let selectRelatedContainer = UIStackView(arrangedSubviews: [numberOfselectedCardsLabel, cancleSelectButton, selectEmptyView])
        selectRelatedContainer.spacing = Constants.betweenNumberAndLabel
        
        let rightBarbutton = UIBarButtonItem(customView: selectRelatedContainer)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    private func attributes() {
        
        view.backgroundColor = .designSystem(.white)
        participateCollectionView.register(ParticipateCollectionViewCell.self, forCellWithReuseIdentifier: ParticipateCollectionViewCell.cellID)
        participateCollectionView.delegate = self
        participateCollectionView.dataSource = self
        participateCollectionView.showsVerticalScrollIndicator = false
    }

    private func layout() {
        view.addSubview(participateCollectionView)
        participateCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: Constants.collectionViewTopPadding, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        let bottomButtons = UIStackView(arrangedSubviews: [selectAllButton, checkAttendanceButton])
        bottomButtons.distribution = .fillEqually
        bottomButtons.spacing = 16
        view.addSubview(bottomButtons)
        bottomButtons.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 25, paddingBottom: 40, paddingRight: 25)
    }
}

extension ParticipatePaymentCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.cardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardList = reactor?.currentState.cardList else { return .init() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipateCollectionViewCell.cellID, for: indexPath) as? ParticipateCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = cardList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewWidth, height: Constants.collectionViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ParticipateCollectionViewCell,
              let viewModel = cell.viewModel else { return }
        reactor?.action.onNext(.selectCard(viewModel))
    }
}

extension ParticipatePaymentCardViewController: ParticipateCellDelegate {
    func toggleCheckAt(_ viewModel: ParticipateCellViewModel) {
        reactor?.action.onNext(.selectCard(viewModel))
    }
}

extension ParticipatePaymentCardViewController {
    struct Constants {
        static let betweenNumberAndLabel: CGFloat = 4
        static let collectionViewMinLineSpacing: CGFloat = 12
        static let collectionViewTopPadding: CGFloat = 0
        static let collectionViewLeftPadding: CGFloat = 25
        static let collectionViewWidth: CGFloat = UIScreen.main.bounds.width - collectionViewLeftPadding * 2
        static let collectionViewHeight: CGFloat = (collectionViewWidth - 42 - 17) * 139 / 281
    }
}

