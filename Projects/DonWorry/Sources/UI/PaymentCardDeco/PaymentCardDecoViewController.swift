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

    lazy var paymentCardView = PaymentCardView()
    
    private lazy var navigationBar = DWNavigationBar(title: "", rightButtonImageName: "xmark")

    private lazy var tableView = PaymentCardDecoTableView()

    private let imagePicker = UIImagePickerController()

    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
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
        $0.image = UIImage(.ic_debit_card)
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
        setNotification()
    }
    
    // MARK: - Binding
    
    func bind(reactor: PaymentCardDecoReactor) {
        dispatch(to: reactor)
        render(reactor: reactor)
    }

    func dispatch(to reactor: PaymentCardDecoReactor) {
        self.rx.viewDidLoad.map { .viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.completeButton.rx.tap.map { .didTapCompleteButton }
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

        reactor.state.map { "\($0.paymentCard.viewModel.spaceName)" }
            .bind(to: (navigationBar.titleLabel?.rx.text)!)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.paymentCard.name }
            .bind(to: paymentCardView.nameLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.selectedDate }
            .map { Formatter.mmddDateFormatter.string(from: $0) }
            .observe(on: MainScheduler.instance)
            .bind(to: paymentCardView.dateLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.selectedColor }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tableView.selectedColor = $0
                self?.paymentCardView.setColor(by: $0)
            }).disposed(by: disposeBag)

        reactor.state
            .map{ "\($0.paymentCard.totalAmount.formatted())원"}
            .bind(to: paymentCardView.totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.paymentCard.viewModel.categoryIconName }
            .distinctUntilChanged()
            .map { UIImage(assetName: $0) }
            .bind(to: paymentCardView.icon.rx.image)
            .disposed(by: disposeBag)

        reactor.state.map { $0.imageURLs }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tableView.filePickerCellViewModel = .init(imageURLs: $0)
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)

        reactor.state.map { $0.bankAccount }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.paymentCardView.setBankAccount($0)
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.userInfo }
            .observe(on: MainScheduler.instance)
            .bind(to: self.paymentCardView.rx.viewModel)
            .disposed(by: disposeBag)

        reactor.pulse(\.$step)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(onNext:{ [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)
    }
}

// MARK: Routing

extension PaymentCardDecoViewController {
    func move(to step: PaymentCardDecoStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .paymentCardListView:
            NotificationCenter.default.post(name: .init("popToPaymentCardList"), object: nil, userInfo: nil)
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
        imagePicker.delegate = self
        tableView.paymentCardDecoTableViewDelegate = self
        paymentCardView.dateLabel.text = "MM/dd"
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
            let height: CGFloat = (48 + 15) * 3 + 5 // 3 : cell 개수
            make.height.equalTo(height)
        }
        self.footerView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.completeButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading).inset(25)
            make.trailing.equalTo(self.view.snp.trailing).inset(25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 30)
            make.height.equalTo(50)
        }
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// 배경 터치시  포커싱 해제
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }

    /// 키보드 Show 시에 위치 조정
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.scrollView.setContentOffset(.init(x: 0, y: 236), animated: true)
                self.view.layoutIfNeeded()
            })
        }
    }

    /// 키보드 Hide 시에 위치 조정
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.scrollView.contentInset = .zero
                self.scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
                self.view.layoutIfNeeded()
            })
            self.view.layoutIfNeeded()
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
        reactor?.action.onNext(.didTapColor(color))
    }
    
    func updateTableViewHeight(to height: CGFloat) {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        tableView.reloadData()
    }
    
    func updatePayDate(with date : Date) {
        reactor?.action.onNext(.didTapDate(date))
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

    func deleteImage(imageURL: String) {
        reactor?.action.onNext(.deleteImage(imageURL))
    }

    func updateHolder(holder: String) {

    }

    func updateAccountNumber(number: String) {
        
    }


}
