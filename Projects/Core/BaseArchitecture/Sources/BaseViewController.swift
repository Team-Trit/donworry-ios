//
//  BaseViewController.swift
//  BaseArchitecture
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import RxSwift

open class BaseViewController: UIViewController {
  public var disposeBag: DisposeBag = DisposeBag()
  open override func viewDidLoad() {
    super.viewDidLoad()
  }
}
