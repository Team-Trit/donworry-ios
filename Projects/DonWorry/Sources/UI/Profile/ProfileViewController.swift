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

enum ProfileTableViewCellType {
    case user
    case account
    case service(String)
}

final class ProfileViewController: BaseViewController, View {
    typealias Reactor = ProfileViewReactor
    private var items: [ProfileTableViewCellType] = [
        .user,
        .account,
        .service("공지사항"),
        .service("이용약관"),
        .service("푸시설정")
    ]
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

// MARK: - Bind
extension ProfileViewController {
    private func dispatch(to reactor: Reactor) {
        self.rx.viewWillAppear
            .map { _ in
                return Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.leftItem.rx.tap
            .map { Reactor.Action.pressBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func render(_ reactor: Reactor) {
        reactor.pulse(\.$reload)
            .asDriver(onErrorJustReturn: ())
            .compactMap { $0 }
            .drive(onNext: { [weak self] in
                self?.profileTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: ProfileStep.none)
            .compactMap { $0 }
            .drive(onNext: { [weak self] in
                self?.route(to: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Routing
extension ProfileViewController {
    private func route(to step: ProfileStep) {
        switch step {
        case .pop:
            self.navigationController?.popViewController(animated: true)
            
        case .profileImageSheet:
            // TODO: ChageProfile Image
            break
            
        case .nicknameEdit:
            let vc = NicknameEditViewController()
            let reactor = NicknameEditViewReactor(userService: UserServiceImpl())
            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .accountEdit:
            let vc = AccountEditViewController()
            let reactor = AccountEditViewReactor(userService: UserServiceImpl())
            vc.reactor = reactor
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .deleteAccountSheet:
            // TODO: 회원 삭제 sheet present
            break
            
        default:
            break
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
        switch items[indexPath.row] {
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewUserCell.identifier, for: indexPath) as? ProfileTableViewUserCell {
                cell.imagePlusButton.rx.tap
                    .map { Reactor.Action.updateProfileImageButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                cell.editButton.rx.tap
                    .map {
                        return Reactor.Action.updateNickNameButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.imageURL }
                    .asDriver(onErrorJustReturn: "profile_sample")
                    .map { imageURL in
                        // TODO: 서버에서 받아온 이미지로 변경
                        UIImage(Asset.profile_sample)
                    }
                    .drive(cell.profileImageView.rx.image)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.nickname }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.nickNameLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewAccountCell.identifier, for: indexPath) as? ProfileTableViewAccountCell {
                cell.editButton.rx.tap
                    .map { Reactor.Action.updateAccountButtonPressed }
                    .bind(to: reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.bank }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.bankLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.accountNumber }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.accountLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                reactor?.state.map { $0.accountHolder }
                    .asDriver(onErrorJustReturn: "")
                    .drive(cell.holderLabel.rx.text)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        case .service(let title):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell {
                cell.titleLabel.text = title
                
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .user:
            guard let cell = cell as? ProfileTableViewUserCell else { return }
            cell.disposeBag = DisposeBag()
            
        case .account:
            guard let cell = cell as? ProfileTableViewAccountCell else { return }
            cell.disposeBag = DisposeBag()
            
        case .service(_):
            guard let cell = cell as? ProfileTableViewServiceCell else { return }
            cell.disposeBag = DisposeBag()
        }
    }
}
