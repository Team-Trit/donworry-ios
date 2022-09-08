//
//  PaymentModels.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum PaymentModels {

    // MARK: 정산방에 포함된 giver의 특정 payment 상세 조회

    enum FetchGiverPayment {
        struct Request {
            let spaceID: Int
            let paymentID: Int
        }

        struct Response {
            let paymentID, spaceID, amount, spaceTotalAmount: Int
            let isCompleted: Bool
            let takerNickname: String
            let account: Account
            let cards: [Card]

            struct Account {
                let bank, number, holder: String
            }

            struct Card{
                let name: String
                let paymentDate: String
                let categoryImgURL: String
                let totalAmount, cardJoinUserCount, amountPerUser: Int
            }
        }
    }

    // MARK: 정산방에 포함된 taker의 모든 payment 조회

    enum FetchTakerPaymentList {

        struct Request {
            let spaceID: Int
        }
        
        struct Response {
            let totalAmount, currentAmount: Int
            let payments: [Payment]

            struct Payment {
                let id, amount: Int
                let isCompleted: Bool
                let user: User
            }

            // MARK: - User
            struct User {
                let id: Int
                let nickname: String
                let imgURL: String?

            }
        }
    }
}
