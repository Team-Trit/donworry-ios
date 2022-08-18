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
import RxCocoa
import RxSwift
import SnapKit

final class ProfileViewController: BaseViewController {
    private lazy var profileTableView: ProfileTableView = {
        let v = ProfileTableView()
        v.backgroundColor = .designSystem(.white)
        return v
    }()
    private lazy var buttonStackView = ButtonStackView()
    let viewModel = ProfileViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Layout
extension ProfileViewController {
    private func setUI() {
        view.addSubviews(profileTableView,buttonStackView)
        
        profileTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
