//
//  PaymentCardDecoViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//


import UIKit
import PhotosUI

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import DesignSystem
import DonWorryExtensions


final class PaymentCardDecoViewController: BaseViewController, View {
    
    typealias Reactor = PaymentCardDecoReactor
    
    var cardVM = CardViewModel(cardColor: .pink,
                               payDate: Date(),
                               bank: "카뱅" ,
                               holder: "버리",
                               number: "123445",
                               images: [])
    
    lazy var paymentCard = PaymentCardView()
    
    private lazy var navigationBar = DWNavigationBar(title: "", rightButtonImageName: "xmark")
    
    private lazy var tableView = PaymentCardDecoTableView()
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private lazy var footerView = UIView()
    
    private lazy var headerView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private lazy var cardIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "debit-card")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산카드 꾸미기"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var completeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.backgroundColor = .designSystem(.mainBlue)
        $0.layer.cornerRadius = 25
        $0.setTitle("완료", for: .normal)
        return $0
    }(UIButton())
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
    }
    
    // MARK: - Binding
    
    func bind(reactor: PaymentCardDecoReactor) {
        dispatch(to: reactor)
        render(reactor: reactor)
    }

    func dispatch(to reactor: PaymentCardDecoReactor) {
        self.completeButton.rx.tap.map { .didTapCompleteButton(self.cardVM) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.navigationBar.rightItem?.rx.tap.map { .didTapCloseButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func render(reactor: PaymentCardDecoReactor) {
        
        reactor.state.map { "\($0.space.title)" }
            .bind(to: (navigationBar.titleLabel?.rx.text)!)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.paymentCard.name }
            .bind(to: paymentCard.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map{ "\($0.paymentCard.totalAmount.formatted())"}
            .bind(to: paymentCard.totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.categoryID }
            .distinctUntilChanged()
            .map {
                UIImage(.init(rawValue: icons[$0].iconName) ?? .ic_cake)
            }
            .bind(to: paymentCard.icon.rx.image)
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext:{ [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }

    
    
}


extension PaymentCardDecoViewController {
    func move(to step: PaymentCardDecoStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .paymentCardListView:
            self.navigationController?.popViewController(animated: true)
        case .completePaymentCardDeco:
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
            
        }
    }
}


// MARK: - Methods

extension PaymentCardDecoViewController {

    private func attributes() {
        view.backgroundColor = .designSystem(.white2)
        scrollView.isScrollEnabled = true
        tableView.isScrollEnabled = false
        tableView.paymentCardDecoTableViewDelegate = self
    }
    
    private func layout() {
        self.view.addSubviews(self.navigationBar, self.scrollView, self.completeButton)
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubviews(self.paymentCard, self.headerView, self.tableView, self.footerView)
        self.stackView.setCustomSpacing(0, after: headerView)
        self.headerView.addArrangedSubviews(self.cardIcon, self.titleLabel)
        
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.width.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
        }
        self.headerView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(340)
        }
        self.cardIcon.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.leading.equalToSuperview().offset(20)
        }
        self.tableView.snp.makeConstraints { make in
            make.width.equalTo(340)
            let height: CGFloat = (48 + 15) * 4 + 5
            make.height.equalTo(height)
        }
        self.footerView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.completeButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).inset(25)
            make.trailing.equalTo(self.view.snp.trailing).inset(25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
    }

}

extension PaymentCardDecoViewController: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        var imageArray = [UIImage]()
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self){ object,
                error in
                if let image = object as? UIImage {
                    imageArray.append(image)
                }
                self.tableView.updatePhotoCell(img: imageArray)
                // image Array 에 image 넣기
                self.cardVM.images = imageArray
                print("🔔🔔🔔🔔이미지 넣기🔔🔔🔔🔔")
                print(self.cardVM.images)
            }
        }
    }
    
}

extension PaymentCardDecoViewController: PaymentCardDecoTableViewDelegate {
    
    func updateCardColor(with color: CardColor) {
        paymentCard.backgroundColor = UIColor(hex:color.rawValue)?.withAlphaComponent(0.72)
        paymentCard.cardSideView.backgroundColor = UIColor(hex:color.rawValue)
        paymentCard.dateLabel.textColor = UIColor(hex:color.rawValue)
        cardVM.cardColor = color
    }
    
    func updateTableViewHeight(to height: CGFloat) {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        tableView.reloadData()
    }
    
    func updatePayDate(with date : Date) {
        let formmater = DateFormatter()
        formmater.dateFormat = "MM/dd"
        formmater.locale = Locale(identifier: "ko_KR")
        paymentCard.dateLabel.text = formmater.string(from: date)
        cardVM.payDate = date
    }
    
    func showPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    

}
