//
//  GetPaymentsTakeDTO.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct GetPaymentsTaker: Codable {
        public let totalAmount, currentAmount: Int
        public let payments: [Payment]

        public struct Payment: Codable {
            public let id, amount: Int
            public let isCompleted: Bool
            public let user: User
        }

        // MARK: - User
        public struct User: Codable {
            public let id: Int
            public let nickname: String
            public let imgURL: String?

            enum CodingKeys: String, CodingKey {
                case id, nickname
                case imgURL = "imgUrl"
            }
        }
    }


}
