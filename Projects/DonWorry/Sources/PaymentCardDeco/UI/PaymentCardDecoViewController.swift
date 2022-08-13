//
//  PaymentCardDecoViewController.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

import BaseArchitecture
import DesignSystem
import DonWorryExtensions


final class PaymentCardDecoViewController: BaseViewController {
    
    //    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = PaymentCardDecoViewModel()
    lazy var paymentCard = PaymentCardView()
    lazy var tableView = PaymentCardDecoTableView()
    
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
        view.backgroundColor = .designSystem(.white)
    }
    
    private func layout() {
        
        view.addSubviews(headerView, paymentCard, tableView, completeButton)
        headerView.addArrangedSubviews(cardIcon, titleLabel)
        NSLayoutConstraint.activate([
            cardIcon.widthAnchor.constraint(equalToConstant: 30),
            cardIcon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
        ])

        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: paymentCard.bottomAnchor, constant: 20),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            headerView.widthAnchor.constraint(equalToConstant: 340),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            paymentCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            paymentCard.bottomAnchor.constraint(equalTo: paymentCard.topAnchor, constant: -10),
            paymentCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.widthAnchor.constraint(equalToConstant: 340),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
           
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            
        ])
            
    }

}
