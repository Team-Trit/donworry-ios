//
//  PaymentCardDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PaymentCard: Decodable {
        public let id, spaceID, categoryID: Int
        public let taker: User
        public let givers: [User]
        public let spaceJoinUserCount, cardJoinUserCount: Int
        public let bank, number, holder, name: String
        public let totalAmount: Int
        public let status: String
        public let bgColor, paymentDate: String

        enum CodingKeys: String, CodingKey {
            case id
            case spaceID = "spaceId"
            case categoryID = "categoryId"
            case taker
            case spaceJoinUserCount, cardJoinUserCount
            case givers, bank, number, holder, name
            case totalAmount, status, bgColor, paymentDate
        }

        public struct User: Codable {
            public let id: Int
            public let nickname, imgURL: String

            enum CodingKeys: String, CodingKey {
                case id, nickname
                case imgURL = "imgUrl"
            }
        }

    }
}
