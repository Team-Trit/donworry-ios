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
import Models
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class SelectBankViewController: BaseViewController, View {
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
        return v
    }()
    private lazy var bankSearchTextField = BankSearchTextField()
    private lazy var bankCollectionView = SelectBankCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }
        
    func bind(reactor: SelectBankViewReactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension SelectBankViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
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

// MARK: - Bind
extension SelectBankViewController {
    private func dispatch(to reactor: SelectBankViewReactor) {
        dismissButton.rx.tap
            .map { Reactor.Action.dismissButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bankSearchTextField.rx.text.changed
            .map { Reactor.Action.searchTextChanged(filter: $0 ?? "") }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bankCollectionView.rx.itemSelected
            .map {
                guard let cell = self.bankCollectionView.cellForItem(at: $0) as? SelectBankCollectionViewCell else { return Reactor.Action.dismissButtonPressed }
                return Reactor.Action.selectBank(cell.bank!)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: SelectBankViewReactor) {
        reactor.state.map { $0.snapshot }
            .bind(onNext: { self.bankCollectionView.diffableDataSouce.apply($0, animatingDifferences: true) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: .none)
            .compactMap { $0 }
            .drive { [weak self] in
                self?.route(to: $0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Route
extension SelectBankViewController {
    private func route(to step: SelectBankStep) {
        switch step {
        case .dismiss:
            self.dismiss(animated: true)
            
        default:
            break
        }
    }
}
