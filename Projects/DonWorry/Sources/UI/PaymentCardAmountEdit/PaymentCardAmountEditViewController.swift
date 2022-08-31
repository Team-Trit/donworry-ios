//
//  PaymentCardAmountEditViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/22.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class PaymentCardAmountEditViewController: BaseViewController, View {
    // TODO: 수정 시 VC 재사용
    typealias Reactor = PaymentCardAmountEditReactor
    private let padItems = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "00", "0", "<"]
    private lazy var navigationBar = CustomNavigationBar()
    private lazy var imageBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.grayEEEEEE)
        v.layer.cornerRadius = 5
        v.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        v.layer.borderWidth = 1
        v.layer.shadowPath = UIBezierPath(roundedRect: v.bounds, cornerRadius: v.layer.cornerRadius).cgPath
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowOpacity = 0.5
        v.layer.shadowRadius = 0.5
        return v
    }()
    private lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    private lazy var paymentTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    private lazy var amountLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._50)
        v.textAlignment = .right
        v.adjustsFontSizeToFitWidth = true
        return v
    }()
    private lazy var wonLabel: UILabel = {
        let v = UILabel()
        v.text = "원"
        v.textColor = .init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        v.font = .designSystem(weight: .regular, size: ._18)
        return v
    }()
    private lazy var nextButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.title = "다음"
        v.isEnabled = false
        return v
    }()
    private lazy var numberPadCollectionView: NumberPadCollectionView = {
        let v = NumberPadCollectionView()
        v.dataSource = self
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = PaymentCardAmountEditReactor()
        setUI()
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Bind
extension PaymentCardAmountEditViewController {
    private func dispatch(to reactor: Reactor) {
        nextButton.rx.tap
            .map { Reactor.Action.nextButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        numberPadCollectionView.rx.itemSelected
            .map { Reactor.Action.numberPadPressed(pressedItem: self.padItems[$0.row]) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.state.map { $0.iconName }
            .distinctUntilChanged()
            .map { UIImage(.init(rawValue: $0)!) }
            .bind(to: iconImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentTitle }
            .distinctUntilChanged()
            .bind(to: paymentTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.amount }
            .distinctUntilChanged()
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension PaymentCardAmountEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, imageBackgroundView, iconImageView, paymentTitleLabel, amountLabel, wonLabel, nextButton, numberPadCollectionView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        imageBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.centerY.equalTo(navigationBar.snp.bottom).offset(50)
            make.width.height.equalTo(37)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackgroundView.snp.center)
            make.width.height.equalTo(30)
        }
        
        paymentTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.centerY.equalTo(imageBackgroundView.snp.centerY)
            make.top.equalToSuperview().offset(134)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-100)
            make.top.equalTo(paymentTitleLabel.snp.bottom).offset(30)
            make.trailing.equalTo(wonLabel.snp.leading).offset(-6)
            make.width.equalTo(230)
        }
        
        wonLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-110)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(340)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(394)
        }
        
        numberPadCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PaymentCardAmountEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return padItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberPadCollectionViewCell.identifier, for: indexPath) as? NumberPadCollectionViewCell else { return UICollectionViewCell() }
        cell.numberLabel.text = padItems[indexPath.row]
        return cell
    }
}
