////
////  PaymentCardModels.swift
////  DonWorry
////
////  Created by Woody on 2022/09/04.
////  Copyright © 2022 Tr-iT. All rights reserved.
////

import Foundation

enum PaymentCardModels {

    enum FetchCardList {
        struct Response {
            public let isAllPaymentCompleted: Bool
            public let space: Space
            public let spaceJoinUsers: [PaymentCard.User]
            public let cards: [PaymentCard]

            struct Space {
                let id, adminID: Int
                let title, status, shareID: String
            }

            struct PaymentCard {
                let id, cardJoinUserCount: Int
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
            var accountNumber: String
            var holder: String
            var name: String
            var totalAmount: Int
            var bgColor: String
            var paymentDate: String
            var imageURLs: [String]
            var viewModel: ViewModel
            struct ViewModel {
                var categoryIconName: String
                var spaceName: String
            }

            static var initialValue: Request = .init(
                spaceID: -1, categoryID: -1, bank: "", accountNumber: "", holder: "",
                name: "", totalAmount: 0, bgColor: "#", paymentDate: "", imageURLs: [], viewModel: .init(categoryIconName: "", spaceName: ""))
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

    // MARK: 정산 내역(카드) 정보 불러오기
    
    enum FetchCard {
        struct Response {
            public var card: PaymentCard
            struct PaymentCard: Codable {
                public var id, totalAmount: Int
                public let users: [User]
                public let imgUrls: [String]
                public let category: String
            }
            
            struct User: Codable {
                let id: Int
                let isTaker: Bool
                let nickname: String
                let imgURL: String?

                enum CodingKeys: String, CodingKey {
                    case id, isTaker, nickname
                    case imgURL = "imgUrl"
                }
            }
        }
    }

    // MARK: 정산 내역(카드) 수정하기
    
    enum PutCard {
        struct Response {
            public let card: PaymentCard
            struct PaymentCard: Codable {
                public let id, totalAmount: Int
            }
        }
    }

    // MARK: 정산 내역 (카드) 참여하기

    enum JoinCard {
        struct Request {
            let currentCardIds: [Int]
            let selectedCardIds: [Int]
        }
    }

    enum JoinOneCard {
        struct Request {
            let cardID: Int
        }
    }
}
