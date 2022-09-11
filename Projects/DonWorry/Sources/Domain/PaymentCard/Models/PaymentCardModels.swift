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
    
    enum FetchCard {
        struct Response {
            public let card: PaymentCard
            struct PaymentCard: Codable {
                public let id, totalAmount: Int
                public let users: [User]
                public let imgUrls: [String]
            }
            
            struct User: Codable {
                public let id: Int
                public let isTaker: Bool
                public let nickname: String
               public let imgURL: String?

                enum CodingKeys: String, CodingKey {
                    case id, isTaker, nickname
                    case imgURL = "imgUrl"
                }
            }
        }
    }
    
    enum PutCard {
        struct Response {
            public let card: PaymentCard
            struct PaymentCard: Codable {
                public let id, totalAmount: Int
            }
        }
    }
    
    enum DeleteCard {
        public struct Empty: Decodable { }
    }
    
}
