//
//  ReceivedMoneyDetailViewViewModel.swift
//  App
//
//  Created by uiskim on 2022/08/13.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import BaseArchitecture

import RxSwift

struct RecievingCellContent {
    let name: String
    let money: Int
    var isCompleted: Bool = false
}

final class ReceivedMoneyDetailViewViewModel: BaseViewModel {
    let contents: [RecievingCellContent] = [
        RecievingCellContent(name: "유쓰햄", money: 6000, isCompleted: true),
        RecievingCellContent(name: "임애셔", money: 6000, isCompleted: true),
        RecievingCellContent(name: "김루미", money: 6000),
        RecievingCellContent(name: "정버리", money: 6000)
    ]
}
