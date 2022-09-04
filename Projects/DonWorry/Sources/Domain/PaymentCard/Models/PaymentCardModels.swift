//
//  PaymentCardModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum PaymentCardModels {

    enum FetchCardList {
        struct Response {
            let id: Int
            let categoryID: Int
            let taker: Taker
            let givers: [Taker]
            let spaceJoinUserCount: Int
            let cardJoinUserCount: Int
            let bank: String
            let number: String
            let holder: String
            let name: String
            let totalAmount: Int
            let status, bgColor, paymentDate: String

            struct Taker {
                let id: Int
                let nickname: String
                let imgURL: String?

            }
        }

        typealias ResponseList = [Response]
    }
}
