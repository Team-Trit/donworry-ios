//
//  ReceivedMoneyDetailViewViewController.swift
//  App
//
//  Created by uiskim on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class ReceivedMoneyDetailViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = ReceivedMoneyDetailViewViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        attributes()
        layout()
    }


}

extension ReceivedMoneyDetailViewViewController {

    private func attributes() {

    }

    private func layout() {

    }
}
