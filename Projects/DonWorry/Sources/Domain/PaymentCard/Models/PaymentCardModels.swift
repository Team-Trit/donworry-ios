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
            let id, spaceJoinUserCount, cardJoinUserCount: Int
            let name: String
            let totalAmount: Int
            let bgColor, paymentDate: String
            let category: Category
            let account: BankAccount
            let taker: User
            let givers: [User]

            struct User {
                let id: Int
                let nickname: String
                let imgURL: String?
            }

            struct BankAccount {
                let bank, number, holder: String
            }

            struct Category: Codable {
                let id: Int
                let name, imgURL: String
            }

        }
        typealias ResponseList = [Response]
    }

}
