//
//  PaymentCardModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import UIKit

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

    // MARK: 정산내역 (카드) 생성하기

    enum CreateCard {
        struct Request {
            var spaceID: Int
            var categoryID: Int
            var bank: String
            var number: String
            var holder: String
            var name: String
            var totalAmount: Int
            var bgColor: String
            var paymentDate: String
            var imageURLs: [String]
            var viewModel: ViewModel
            struct ViewModel {
                var categoryIconName: String
            }

            static var initialValue: Request = .init(
                spaceID: -1, categoryID: -1, bank: "", number: "", holder: "",
                name: "", totalAmount: 0, bgColor: "#", paymentDate: "", imageURLs: [], viewModel: .init(categoryIconName: ""))
        }

        struct Response {
            let id, spaceID, takerID: Int
            let name: String
            let totalAmount: Int
            let bgColor, paymentDate: String
            let category: Category
            let account: Account
            
            struct Account: Codable {
                let bank, number, holder: String
                let userID: Int
            }

            struct Category: Codable {
                let id: Int?
                let name, imgURL: String
            }
        }
    }
    
    enum Empty {
        struct Response {}
    }
    
}
