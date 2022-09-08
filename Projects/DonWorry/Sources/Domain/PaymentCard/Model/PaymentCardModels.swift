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
    
    enum PostCard {
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
            var images: [UIImage]
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
    
    
    enum PostCardImage {
        
        struct Request {
            let images: [UIImage]
        }
        
        struct Response {
            let id, spaceID, categoryID, takerID: Int
            let name: String
            let totalAmount: Int
            let bgColor, paymentDate: String
            let account: Account
            let imgUrls: [String]
            
            struct Account: Codable {
                let bank, number, holder: String
                let userID: Int
            }
        }
    }
    
    enum Empty {
        struct Response {}
    }
    
}
