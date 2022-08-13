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
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    
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
        
        view.addSubviews(paymentCard, scrollView)
        scrollView.addSubviews(tableView)
        scrollView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            paymentCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            paymentCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: paymentCard.bottomAnchor, constant: -20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            
            tableView.widthAnchor.constraint(equalToConstant: 340),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: paymentCard.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            
            
        ])
         
            
    }

}
