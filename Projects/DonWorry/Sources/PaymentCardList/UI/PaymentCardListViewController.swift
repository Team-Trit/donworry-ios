//
//  PaymentCardListViewController.swift
//  App
//
//  Created by Woody on 2022/08/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift

final class PaymentCardListViewController: BaseViewController, View {
    typealias Reactor = PaymentCardListViewReactor

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func bind(reactor: Reactor) {
        self.render(reactor: reactor)
    }

    private func render(reactor: Reactor) {

    }

}

// MARK: setUI

extension PaymentCardListViewController {

    private func setUI() {

    }
}
