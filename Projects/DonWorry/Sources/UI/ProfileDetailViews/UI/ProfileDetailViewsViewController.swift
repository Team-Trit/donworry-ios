//
//  ProfileDetailViewsViewController.swift
//  App
//
//  Created by uiskim on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class ProfileDetailViewsViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = ProfileDetailViewsViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        attributes()
        layout()
    }


}

extension ProfileDetailViewsViewController {

    private func attributes() {

    }

    private func layout() {

    }
}
