//
//  PaymentCardDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PaymentCard: Codable {
        public let id, spaceJoinUserCount, cardJoinUserCount: Int
        public let name: String
        public let totalAmount: Int
        public let bgColor, paymentDate: String
        public let category: Category
        public let account: Account
        public let taker: User
        public let givers: [User]

        public struct User: Codable {
            public let id: Int
            public let nickname: String
            public let imgURL: String?

            enum CodingKeys: String, CodingKey {
                case id, nickname
                case imgURL = "imgUrl"
            }
        }

        public struct Account: Codable {
            public let bank, number, holder: String

            enum CodingKeys: String, CodingKey {
                case bank, number, holder
            }
        }

        public struct Category: Codable {
            public let id: Int
            public let name, imgURL: String

            enum CodingKeys: String, CodingKey {
                case id, name
                case imgURL = "imgUrl"
            }
        }

    }
}
