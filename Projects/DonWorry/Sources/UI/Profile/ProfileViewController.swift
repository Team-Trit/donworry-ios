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
    typealias Reactor = ProfileViewReactor
    private lazy var navigationBar = CustomNavigationBar()
    private lazy var profileTableView = ProfileTableView()
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
        
    }
    
    private func render(_ reactor: Reactor) {
        
    }
}

// MARK: - Layout
extension ProfileViewController {
    private func setUI() {
        view.backgroundColor = .designSystem(.white)
        
        view.addSubviews(navigationBar, profileTableView, inquiryButtonView, questionButtonView, blogButtonView, accountButtonStackView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
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
