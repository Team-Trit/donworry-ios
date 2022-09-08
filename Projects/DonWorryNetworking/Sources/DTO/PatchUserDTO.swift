//
//  PatchUserDTO.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PatchUser: Codable {
        public let id: Int
        public let nickname: String
        public let isAgreeMarketing: Bool
        public let email, tokenType, accessToken, refreshToken: String
        public let account: Account
        
        public struct Account: Codable {
            public let id: Int
            public let bank, number, holder: String
            public let userID: Int?

            enum CodingKeys: String, CodingKey {
                case id, bank, number, holder
                case userID = "userId"
            }
        }
    }
}
