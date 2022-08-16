//
//  SelectBankViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/16.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import RxCocoa
import RxSwift
import SnapKit

final class SelectBankViewController: BaseViewController {
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "은행선택"
        v.font = .designSystem(weight: .bold, size: ._20)
        return v
    }()
    private lazy var dismissButton: UIButton = {
        let v = UIButton()
        v.setTitle("취소", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
        v.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    private lazy var bankSearchTextField = BankSearchTextField()
    private lazy var bankCollectionView = SelectBankCollectionView()
    let viewModel = SelectBankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension SelectBankViewController {
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubviews(titleLabel, dismissButton, bankSearchTextField, bankCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(25)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        bankSearchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        bankCollectionView.snp.makeConstraints { make in
            make.top.equalTo(bankSearchTextField.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Interaction Functions
extension SelectBankViewController {
    @objc private func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
