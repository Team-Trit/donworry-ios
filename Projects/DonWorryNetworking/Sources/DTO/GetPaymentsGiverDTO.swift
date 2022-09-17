//
//  GetPaymentsGiverDTO.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct GetPaymentsGiver: Codable {
        public let paymentID, spaceID, amount, totalAmount: Int
        public let isCompleted: Bool
        public let takerNickname: String
        public let account: Account
        public let cards: [Card]
        public let payments: [Payment]
        enum CodingKeys: String, CodingKey {
            case paymentID = "paymentId"
            case spaceID = "spaceId"
            case amount, totalAmount, isCompleted, takerNickname, account, cards, payments
        }

        public struct Account: Codable {
            public let bank, number, holder: String
        }

        public struct Card: Codable {
            public let name: String
            public let paymentDate: String
            public let categoryImgURL: String
            public let totalAmount, cardJoinUserCount, amountPerUser: Int

            enum CodingKeys: String, CodingKey {
                case name, paymentDate
                case categoryImgURL = "categoryImgUrl"
                case totalAmount, cardJoinUserCount, amountPerUser
            }
        }

        public struct Payment: Codable {
            public let id, amount: Int
            public let isCompleted: Bool
            public let takerNickname: String
        }
    }

}
