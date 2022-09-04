//
//  PaymentCardModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

// 유즈케이스 정리
enum PaymentCardModels {

    enum FetchCardList {

        struct Response {
            public let isAllPaymentCompleted: Bool
            public let space: Space
            public let cards: [PaymentCard]

            struct Space {
                let id, adminID: Int
                let title, status, shareID: String
            }

            struct PaymentCard {
                let id, spaceJoinUserCount, cardJoinUserCount: Int
                let name: String
                let totalAmount: Int
                let bgColor, paymentDate: String
                let category: Category
                let account: BankAccount
                let taker: User
                let givers: [User]
                let isUserParticipatedIn: Bool

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
        }
    }
    
    enum PostCard {
        struct Request {
            let spaceID: Int
            let categoryID: Int
            let bank: String
            let number: String
            let holder: String
            let name: String
            let totalAmount: Int
            let bgColor: String
            let paymentDate: String
        }

        struct Response {
            
        }
    }
    
}
