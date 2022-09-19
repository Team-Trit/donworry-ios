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
import SnapKit

final class ParticipatePaymentCardViewController: BaseViewController, View {
    typealias Reactor = ParticipatePaymentCardViewReactor
    private lazy var navigationBar = ParticipatePaymentNavigationBar()
    private lazy var participateCollectionView: ParticipateCollectionView = {
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(ParticipateCollectionView())
    
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
        setUI()
    }

    func bind(reactor: ParticipatePaymentCardViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension ParticipatePaymentCardViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, participateCollectionView, selectAllButton, checkAttendanceButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        participateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 30)
        }
        
        selectAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.centerX).offset(-8)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 30)
        }
        
        checkAttendanceButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(8)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 30)
        }
    }
}

// MARK: - Bind
extension ParticipatePaymentCardViewController {
    private func dispatch(to reactor: Reactor) {
        checkAttendanceButton.rx.tap.map { .didTapAttendanceButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selectAllButton.rx.tap.map { .didTapSelectAllButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigationBar.deselectButton.rx.tap
            .map { Reactor.Action.didTapCancelSelectButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigationBar.dismissButton.rx.tap
            .map { Reactor.Action.didTapCancelButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.cardList.filter { $0.isSelected } }
            .observe(on: MainScheduler.instance)
            .map { "\($0.count)" }
            .bind(to: navigationBar.selectedCardNumberLabel.rx.text)
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

// MARK: - Routing
extension ParticipatePaymentCardViewController {
    func move(to step: ParticipatePaymentCardStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UICollectionView Protocols
extension ParticipatePaymentCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.cardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipateCollectionViewCell.cellID, for: indexPath) as? ParticipateCollectionViewCell, let reactor = reactor else { return UICollectionViewCell() }
        
        let index = indexPath.row
        
        cell.checkButton.rx.tap
            .map { Reactor.Action.selectCard(cell.viewModel!) }
            .bind(to: reactor.action)
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index] }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                cell.viewModel = $0
            })
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].isSelected }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                cell.checkButton.setImage($0 ? UIImage(.check_gradient_image) : nil , for: .normal)
            })
            .disposed(by: cell.disposeBag)
        
        /*
         view model 없어진 후 bind
        reactor.state.map { $0.cardList[index].name }
            .observe(on: MainScheduler.instance)
            .bind(to: cell.cardNameLabel.rx.text)
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].amount }
            .observe(on: MainScheduler.instance)
            .bind(to: cell.totalPriceLabel.rx.text)
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].payer.imgURL }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                cell.userImageView.setBasicProfileImageWhenNilAndEmpty(with: $0)
            })
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { UIImage(assetName: $0.cardList[index].categoryName) }
            .observe(on: MainScheduler.instance)
            .bind(to: cell.iconImageView.rx.image)
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].payer.name }
            .observe(on: MainScheduler.instance)
            .bind(to: cell.userNickNameLabel.rx.text)
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].bgColor }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { color in
                cell.cardLeftView.backgroundColor = UIColor(hex: color)?.withAlphaComponent(0.72)
                cell.cardRightView.backgroundColor = UIColor(hex: color)
            })
            .disposed(by: cell.disposeBag)
        
        reactor.state.map { $0.cardList[index].date }
            .observe(on: MainScheduler.instance)
            .bind(to: cell.dateLabel.rx.text)
            .disposed(by: cell.disposeBag)
         */
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewWidth, height: Constants.collectionViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ParticipateCollectionViewCell, let viewModel = cell.viewModel, let reactor = reactor else { return }

        reactor.action.onNext(.selectCard(viewModel))
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipateCollectionViewCell.cellID, for: indexPath) as? ParticipateCollectionViewCell else { return }
        cell.disposeBag = DisposeBag()
    }
}

// MARK: - Constants
extension ParticipatePaymentCardViewController {
    struct Constants {
        static let betweenNumberAndLabel: CGFloat = 4
        static let collectionViewLeftPadding: CGFloat = 25
        static let collectionViewWidth: CGFloat = UIScreen.main.bounds.width - collectionViewLeftPadding * 2
        static let collectionViewHeight: CGFloat = (collectionViewWidth - 42 - 17) * 139 / 281
    }
}

