//
//  SentMoneyDetailViewViewModel.swift
//  App
//
//  Created by uiskim on 2022/08/09.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import BaseArchitecture

import RxSwift

final class SentMoneyDetailViewViewModel: BaseViewModel {
    
    let payments = [
        Payment(name: "우디네 당구장", date: "05/25", totalAmount: 184000, totalUers: 4, myAmount: 44000),
        Payment(name: "유쓰네 삼겹살", date: "05/25", totalAmount: 152000, totalUers: 2, myAmount: 76000)
    ]
}
