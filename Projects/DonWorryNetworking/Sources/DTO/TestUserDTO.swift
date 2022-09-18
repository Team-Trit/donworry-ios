//
//  TestUserDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct TestUser: Decodable {
        public let id: Int
        public let nickname: String
        public let isAgreeMarketing: Bool
        public let tokenType, accessToken: String
        public let refreshToken: String
        public let account: Account

        public struct Account: Codable {
            public let bank, number, holder: String
            public let userID: Int

            public enum CodingKeys: String, CodingKey {
                case bank, number, holder
                case userID = "userId"
            }
        }
    }
}
