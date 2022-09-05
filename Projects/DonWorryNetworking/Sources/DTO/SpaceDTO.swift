//
//  SpaceDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct Space: Decodable {
        public let id, adminID: Int
        public let title, status, shareID: String
        public let isTaker: Bool
        public let payments: [Payment]

        enum CodingKeys: String, CodingKey {
            case id
            case adminID = "adminId"
            case title, status
            case shareID = "shareId"
            case isTaker
            case payments
        }

        // MARK: - Payment
        public struct Payment: Decodable {
            public let id, amount: Int
            public let isCompleted: Bool
            public let user: User
        }

        // MARK: - User
        public struct User: Decodable {
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

