//
//  AccountEditViewController.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift

final class AccountEditViewController: BaseViewController, View {
    typealias Reactor = AccountEditViewReactor
    private lazy var navigationBar = DWNavigationBar()
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "계좌정보를\n수정해볼까요?"
        v.numberOfLines = 0
        v.setLineSpacing(spacing: 10.0)
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    private lazy var accountEditField = AccountInputField(frame: .zero, type: .EnterUserInfo)
    private lazy var doneButton: DWButton = {
        let v = DWButton.create(.xlarge50)
        v.setTitle("완료", for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Layout
extension AccountEditViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        view.addSubviews(navigationBar, titleLabel, accountEditField, doneButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        accountEditField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension AccountEditViewController {
    private func dispatch(to reactor: Reactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.pressBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.pressDoneButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
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
extension AccountEditViewController {
    private func route(to: AccountEditViewStep) {
        switch to {
        case .none:
            break
            
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .presentSelectBankView:
            let vc = SelectBankViewController()
            let reactor = SelectBankViewReactor()
            vc.reactor = reactor
            self.navigationController?.present(vc, animated: true)
        }
    }
}
