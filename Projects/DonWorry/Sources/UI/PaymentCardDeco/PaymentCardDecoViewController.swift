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

final class PaymentCardDecoViewController: BaseViewController, View, UINavigationControllerDelegate {
    
    typealias Reactor = PaymentCardDecoReactor
    
    // MARK: cardVM이 화면에 보여주기 위해서 데이터를 가지고 있는 친구라면 bank, holder, number는 bind처리 해놨기 때문에 이 3친구는 필요 없어요! (from charlie)
    var cardVM = CardViewModel(cardColor: .pink,
                               payDate: Date(),
                               bank: UserServiceImpl().fetchLocalUser()?.bankAccount.bank ?? "은행명" ,
                               holder: UserServiceImpl().fetchLocalUser()?.bankAccount.accountHolderName ?? "(예금주명)",
                               number: UserServiceImpl().fetchLocalUser()?.bankAccount.accountNumber ?? "000000-00000",
                               images: [])
    
    lazy var paymentCardView = PaymentCardView()
    
    private lazy var navigationBar = DWNavigationBar(title: "", rightButtonImageName: "xmark")

    private lazy var tableView: PaymentCardDecoTableView = {
        let v = PaymentCardDecoTableView()
        v.vcReactor = self.reactor
        return v
    }()
    
    private let imagePicker = UIImagePickerController()

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
    
    private lazy var cardIconImageView: UIImageView = {
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
        
        reactor.state.map { "\($0.paymentCard.name)" }
            .bind(to: (navigationBar.titleLabel?.rx.text)!)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.paymentCard.name }
            .bind(to: paymentCardView.nameLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map{ "\($0.paymentCard.totalAmount.formatted())"}
            .bind(to: paymentCardView.totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.bank }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(paymentCardView.bankLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.bank }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] bank in
                guard let cell = self?.tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? AccountInputCell else { return }
                cell.accountInputField.chooseBankButton.setTitle(bank, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.holder }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0.isEmpty ? "(예금주명)" : "(\($0))" }
            .drive(paymentCardView.accountHodlerNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.number }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0.isEmpty ? "000000-00000" : $0 }
            .drive(paymentCardView.accountNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.viewModel.categoryIconName }
            .distinctUntilChanged()
            .map { UIImage(assetName: $0) }
            .bind(to: paymentCardView.icon.rx.image)
            .disposed(by: disposeBag)

        reactor.state.map { $0.imageURLs }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
//                self?.
            }).disposed(by: disposeBag)
        
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
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
        case .completePaymentCardDeco:
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
            
        case .selectBankView:
            let vc = SelectBankViewController()
            let reactor = SelectBankViewReactor(cardDecoViewDelegate: self.reactor!, parentView: .paymentCardDeco)
            vc.reactor = reactor
            self.navigationController?.present(vc, animated: true)
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
        imagePicker.delegate = self
        paymentCardView.dateLabel.text = cardVM.payDate.getDateToString(format: "MM/dd")
        
    }
    
    private func layout() {
        self.view.addSubviews(self.navigationBar, self.scrollView, self.completeButton)
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubviews(self.paymentCardView, self.headerView, self.tableView, self.footerView)
        self.stackView.setCustomSpacing(0, after: headerView)
        self.headerView.addArrangedSubviews(self.cardIconImageView, self.titleLabel)
        
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
        self.cardIconImageView.snp.makeConstraints { make in
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

// MARK: UIImagePickerControllerDelegate

extension PaymentCardDecoViewController: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
            self?.reactor?.action.onNext(.addImage(image))
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: PaymentCardDecoTableViewDelegate

extension PaymentCardDecoViewController: PaymentCardDecoTableViewDelegate {
    
    func updateCardColor(with color: CardColor) {
        paymentCardView.backgroundColor = UIColor(hex:color.rawValue)?.withAlphaComponent(0.72)
        paymentCardView.cardSideView.backgroundColor = UIColor(hex:color.rawValue)
        paymentCardView.dateLabel.textColor = UIColor(hex:color.rawValue)
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
        paymentCardView.dateLabel.text = formmater.string(from: date)
        cardVM.payDate = date
    }

    func showPhotoPicker() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { [weak self] _ in
                            guard let self = self else { return }
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)
                        })
                    }
                }
            })
            PHPhotoLibrary.requestAuthorization( { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        alertController.addAction(UIAlertAction(title: "Gallery", style: .default) { [weak self] action in
                            guard let self = self else { return }
                            self.imagePicker.sourceType = .photoLibrary
                            self.imagePicker.allowsEditing = false
                            self.present(self.imagePicker, animated: true, completion: nil)
                        })
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
                        }))

                        alertController.modalPresentationStyle = .popover

                        self.present(alertController, animated: true, completion: nil)
                    }
                default:
                    break
                }
            })
        }
    }
}
