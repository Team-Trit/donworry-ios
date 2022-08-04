//
//  BaseViewController.swift
//  BaseArchitecture
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
  var disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
