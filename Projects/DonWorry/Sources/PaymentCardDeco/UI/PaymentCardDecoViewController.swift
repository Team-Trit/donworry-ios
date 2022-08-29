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
    var paymentCard: PaymentCardView!
    
    
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
        
        paymentCard = PaymentCardView()
        view.addSubviews(paymentCard)
        
        NSLayoutConstraint.activate([
            paymentCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            paymentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            paymentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
            
    }

}
