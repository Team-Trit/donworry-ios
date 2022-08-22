//
//  PaymentCardAmountEditViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/22.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import RxCocoa
import RxSwift


final class PaymentCardAmountEditViewController: BaseViewController {
    private lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        
        return v
    }()
    private lazy var amountLabel: UILabel = {
        let v = UILabel()
        
        return v
    }()
    private lazy var nextButton: UIButton = {
        let v = UIButton()
        
        return v
    }()
    private lazy var numberPadCollectionView: NumberPadCollectionView = {
        let v = NumberPadCollectionView()
        
        return v
    }()
    
    let viewModel = PaymentCardAmountEditViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

}

// MARK: - Layout
extension PaymentCardAmountEditViewController {
    private func setUI() {
        
    }
}
