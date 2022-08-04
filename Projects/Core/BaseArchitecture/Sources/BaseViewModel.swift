//
//  BaseViewModel.swift
//  BaseArchitecture
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

open class BaseViewModel {
  open var disposeBag: DisposeBag = DisposeBag()
  public init() {}
}
