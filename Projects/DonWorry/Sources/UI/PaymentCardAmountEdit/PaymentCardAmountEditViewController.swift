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

enum paymentAmountEditType {
    case create
    case update
}

final class PaymentCardAmountEditViewController: BaseViewController, View {
    typealias Reactor = PaymentCardAmountEditReactor
    private let padItems = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "00", "0", "delete.left.fill"]
    private var editType: paymentAmountEditType = .create
    
    private lazy var navigationBar: DWNavigationBar = {
        if editType == .update {
            return .init(title: "")
        } else {
            return .init(title: "", rightButtonImageName: "xmark")
        }
    }()
    
    init(editType: paymentAmountEditType = .create) {
        super.init(nibName: nil, bundle: nil)
        self.editType = editType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topView =  UIView()
    
    private lazy var labelStackView: UIStackView = {
        let v = UIStackView()
        v.spacing = 15
        v.alignment = .center
        v.distribution = .fill
        v.axis = .horizontal
        return v
    }()
    
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
        v.baselineAdjustment = .alignBaselines
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
        if editType == .update {
            v.title = "수정 완료"
        } else {
            v.title = "다음"
            v.isEnabled = false
        }
        return v
    }()
    
    private lazy var numberPadCollectionView: NumberPadCollectionView = {
        let v = NumberPadCollectionView()
        v.dataSource = self
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
            .map { [weak self] in
                self?.editType == .create ? Reactor.Action.nextButtonPressed : Reactor.Action.doneButtonPressed
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        numberPadCollectionView.rx.itemSelected
            .map { Reactor.Action.numberPadPressed(pressedItem: self.padItems[$0.row]) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.rightItem?.rx.tap.map { .didTapCloseButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func render(_ reactor: Reactor) {
        if editType == .create {
            reactor.state.map { $0.paymentCard!.viewModel.categoryIconName }
                .distinctUntilChanged()
                .observe(on: MainScheduler.instance)
                .map { UIImage(assetName: $0) }
                .bind(to: iconImageView.rx.image)
                .disposed(by: disposeBag)
            
            reactor.state.map { $0.paymentCard!.name }
                .distinctUntilChanged()
                .observe(on: MainScheduler.instance)
                .bind(to: paymentTitleLabel.rx.text)
                .disposed(by: disposeBag)
        } else {
            reactor.state.map { $0.updateCard!.category }
                .distinctUntilChanged()
                .observe(on: MainScheduler.instance)
                .map { UIImage(assetName: $0) }
                .bind(to: iconImageView.rx.image)
                .disposed(by: disposeBag)
            
            reactor.state.map { $0.cardTitle }
                .distinctUntilChanged()
                .bind(to: paymentTitleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        reactor.state.map { $0.amount }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext:{ [weak self] step in
                self?.move(to: step, reactor: reactor)
            }).disposed(by: disposeBag)
    }
}

extension PaymentCardAmountEditViewController {
    
    func move(to step: PaymentCardAmountEditStep, reactor: Reactor) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .paymentCardDeco:
            self.navigationController?.pushViewController(paymentCardDecoViewController(), animated: true)
        case .paymentCardList:
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
        }
    }

    private func paymentCardDecoViewController() -> UIViewController {
        let paymentCardDecoViewController = PaymentCardDecoViewController()
        let newPaymentCard = reactor!.currentState.paymentCard
        paymentCardDecoViewController.reactor =  PaymentCardDecoReactor(paymentCard: newPaymentCard!)
        return paymentCardDecoViewController
    }
}

// MARK: - Layout
extension PaymentCardAmountEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)

        view.addSubviews(navigationBar, topView, numberPadCollectionView)
        topView.addSubviews(labelStackView, amountLabel, wonLabel, nextButton)
        
        labelStackView.addArrangedSubviews(imageBackgroundView, iconImageView, paymentTitleLabel)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(UIDevice.current.hasNotch ? 45 : 35)
            make.leading.equalToSuperview().offset(50)
        }
        
        imageBackgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackgroundView.snp.center)
            make.width.height.equalTo(30)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(UIDevice.current.hasNotch ? 40 : 30)
            make.trailing.equalTo(wonLabel.snp.leading).offset(-6)
            make.width.equalTo(230)
        }
        
        wonLabel.snp.makeConstraints { make in
            make.bottom.equalTo(amountLabel.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).inset(25)
            make.trailing.equalTo(self.view.snp.trailing).inset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(numberPadCollectionView.snp.top).offset(UIDevice.current.hasNotch ? -25 : -15)
        }
        
        numberPadCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo( UIScreen.main.bounds.size.height / 2.1 )
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
        
        if indexPath.row == 11 {
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.bounds = CGRect(x: 0, y: 0, width: 35, height: 27)
            let image = UIImage(systemName: padItems[indexPath.row])?.withTintColor(.designSystem(.mainBlue)!)
            imageAttachment.image = image
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            cell.numberLabel.attributedText = attributedString
        } else {
            cell.numberLabel.text = padItems[indexPath.row]
        }
        return cell
    }
}
