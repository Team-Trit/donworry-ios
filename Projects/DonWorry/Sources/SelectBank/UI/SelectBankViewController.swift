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
    private lazy var bankSearchTextField: BankSearchTextField = {
        let v = BankSearchTextField()
        v.addTarget(self, action: #selector(searchBarEdit(_:)), for: .editingChanged)
        return v
    }()
    private lazy var bankCollectionView = SelectBankCollectionView()
    let viewModel = SelectBankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performQuery(with: nil)
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
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(55)
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
    
    @objc private func searchBarEdit(_ sender: UITextField) {
        self.performQuery(with: sender.text)
    }
}

// MARK: - Helper
extension SelectBankViewController {
    private func performQuery(with filter: String?) {
        let bankList = viewModel.banks
        let filtered = bankList.filter { $0.hasPrefix(filter ?? "") }
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filtered)
        bankCollectionView.diffableDataSouce.apply(snapshot, animatingDifferences: true)
    }
}
