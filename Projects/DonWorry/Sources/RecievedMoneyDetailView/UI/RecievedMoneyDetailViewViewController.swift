//
//  RecievedMoneyDetailViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/07.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class RecievedMoneyDetailViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = RecievedMoneyDetailViewViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        attributes()
        layout()
    }


}

extension RecievedMoneyDetailViewViewController {

    private func attributes() {

    }

    private func layout() {

    }
}
