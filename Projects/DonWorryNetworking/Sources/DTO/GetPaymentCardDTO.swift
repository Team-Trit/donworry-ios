//
//  PaymentCardDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.

import Foundation

extension DTO {
    public struct GetPaymentCard: Codable {
        public let card: PaymentCard
        public struct PaymentCard: Codable {
            public let id, totalAmount: Int
            public let users: [User]
            public let imgUrls: [String]
        }

        public struct User: Codable {
            public let id: Int
            public let isTaker: Bool
            public let nickname: String?
            public let imgURL: String?

            enum CodingKeys: String, CodingKey {
                case id, isTaker, nickname
                case imgURL = "imgUrl"
            }
        }
    }
}
