//
//  CreateRoomViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class CreateRoomViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = CreateRoomViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        attributes()
        layout()
    }


}

extension CreateRoomViewController {

    private func attributes() {

    }

    private func layout() {

    }
}
