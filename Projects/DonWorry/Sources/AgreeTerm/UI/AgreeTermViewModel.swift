//
//  AgreeTermViewModel.swift
//  App
//
//  Created by 김승창 on 2022/08/17.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import BaseArchitecture

import RxSwift

struct Term {
    var label: String
    var isChecked: Bool = false
    var isSection: Bool = false
    var isExpanded: Bool = false
    var children: [Term]?
}

final class AgreeTermViewModel: BaseViewModel {

}
