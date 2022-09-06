//
//  ProfileViewController.swift
//  App
//
//  Created by 김승창 on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit

import BaseArchitecture
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class ProfileViewController: BaseViewController, View {
    private var items: [ProfileViewModelItem] = [
        ProfileViewModelUserItem(nickName: "Charlie", name: "Kim", imageURL: "profile-sample"),
        ProfileViewModelAccountItem(bank: "우리은행", account: "123123123", holder: "김승창"),
        ProfileViewModelServiceItem(label: "공지사항"),
        ProfileViewModelServiceItem(label: "이용약관"),
        ProfileViewModelServiceItem(label: "1대1 문의")
    ]
    
    typealias Reactor = ProfileViewReactor
    private lazy var navigationBar = DWNavigationBar()
    private lazy var profileTableView: ProfileTableView = {
        let v = ProfileTableView()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    private lazy var inquiryButtonView = ServiceButtonView(frame: .zero, type: .inquiry)
    private lazy var questionButtonView = ServiceButtonView(frame: .zero, type: .question)
    private lazy var blogButtonView = ServiceButtonView(frame: .zero, type: .blog)
    private lazy var accountButtonStackView = AccountButtonStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func bind(reactor: Reactor) {
        dispatch(to: reactor)
        render(reactor)
    }
}

// MARK: - Bind
extension ProfileViewController {
    private func dispatch(to reactor: Reactor) {
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.backButtonPressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: ProfileStep.none)
            .compactMap { $0 }
            .drive(onNext: { [weak self] in
                self?.move(to: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension ProfileViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, profileTableView, inquiryButtonView, questionButtonView, blogButtonView, accountButtonStackView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-200)
        }
        
        inquiryButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(30)
            make.trailing.equalTo(questionButtonView.snp.leading).offset(-50)
            make.width.height.equalTo(50)
        }
        
        questionButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        blogButtonView.snp.makeConstraints { make in
            make.top.equalTo(profileTableView.snp.bottom).offset(30)
            make.leading.equalTo(questionButtonView.snp.trailing).offset(50)
            make.width.height.equalTo(50)
        }
        
        accountButtonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Routing
extension ProfileViewController {
    private func move(to step: ProfileStep) {
        switch step {
        case .none:
            break
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .nicknameEdit:
            let vc = NicknameEditViewController()
            let reactor = NicknameEditViewReactor()
            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .accountEdit:
            let vc = AccountEditViewController()
            let reactor = AccountEditViewReactor()
            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewUserCell.identifier, for: indexPath) as? ProfileTableViewUserCell {
                cell.user = item
                
                cell.imagePlusButton.rx.tap
                    .map { Reactor.Action.updateProfileImageButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: disposeBag)
                    
                cell.editButton.rx.tap
                    .map { Reactor.Action.updateNickNameButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: disposeBag)
                
                return cell
            }
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewAccountCell.identifier, for: indexPath) as? ProfileTableViewAccountCell {
                cell.account = item
                
                cell.editButton.rx.tap
                    .map { Reactor.Action.updateAccountButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: disposeBag)
                
                return cell
            }
        case.service:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell {
                cell.service = item
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row].type {
        case .user:
            return 130
        case .account:
            return 170
        case .service:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return v
    }
}
