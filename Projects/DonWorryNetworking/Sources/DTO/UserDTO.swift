//
//  UserDTO.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/08/30.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct User: Codable {
        public let id: Int
        public let nickname: String
        public let isAgreeMarketing: Bool
        public let email, role, tokenType, accessToken: String
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
