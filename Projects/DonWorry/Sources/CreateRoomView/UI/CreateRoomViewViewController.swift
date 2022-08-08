//
//  CreateRoomViewViewController.swift
//  App
//
//  Created by 임영후 on 2022/08/08.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture

import RxCocoa
import RxSwift


final class CreateRoomViewViewController: BaseViewController {

    #warning("ReactorKit으로 변환 필요 + RxFlow를 통해 주입하기")
    let viewModel = CreateRoomViewViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        attributes()
        layout()
    }


}

extension CreateRoomViewViewController {

    private func attributes() {

    }

    private func layout() {

    }
}
