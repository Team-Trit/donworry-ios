//
//  PaymentCardDecoViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import PhotosUI
import UIKit
import RxCocoa
import RxSwift
import SnapKit

import BaseArchitecture
import DesignSystem
import DonWorryExtensions


final class PaymentCardDecoViewController: BaseViewController {
    
    //    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = PaymentCardDecoViewModel()
    
    // MARK: - Model 활용하여 교체 예정
    var cardColor: CardColor = .pink
    
    lazy var paymentCard = PaymentCardView()
    
    private lazy var navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        // TODO: Nav bar title 설정해주기
        v.leftItem.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        return v
    }()
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
        $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        attributes()
        layout()
    }
    
}


// MARK: - Methods

extension PaymentCardDecoViewController {
    
    // TODO: 임시 -> 나중에 앞쪽 페이지들에 맞춰서 해야함
    private func configNavigationBar() {
        self.navigationItem.title = "MC2 첫 회식"
    }
    
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
            make.top.leading.trailing.equalToSuperview()
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
    
    @objc private func didTapCompleteButton() {
        // TODO: 완료 버튼
        print("완료 버튼")
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
            }
        }
    }
    
}

extension PaymentCardDecoViewController: PaymentCardDecoTableViewDelegate {
    
    func updateCardColor(with color: CardColor) {
        paymentCard.backgroundColor = UIColor(hex:color.rawValue)?.withAlphaComponent(0.72)
        paymentCard.cardSideView.backgroundColor = UIColor(hex:color.rawValue)
        paymentCard.dateLabel.textColor = UIColor(hex:color.rawValue)
        cardColor = color
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
    }
    
    func showPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    

}
