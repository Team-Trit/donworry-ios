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
        public let userUpdateCommand: UserUpdateCommand
        public let user: User

        public struct User: Codable {
            public let user: InnerUser
            public let password, username: String
            public let authorities: [Authority]
            public let accountNonExpired, accountNonLocked, credentialsNonExpired, enabled: Bool
        }

        public struct Authority: Codable {
            public let authority: String
        }

        public struct InnerUser: Codable {
            public let id: Int
            public let nickname, email: String
            public let isAgreeMarketing: Bool
            public let provider, providerID, role: String

            enum CodingKeys: String, CodingKey {
                case id, nickname, email, isAgreeMarketing, provider
                case providerID = "providerId"
                case role
            }
        }

        public struct UserUpdateCommand: Codable {
            public let nickname, imgURL: String
            public let account: Account
            public let isAgreeMarketing: Bool

            enum CodingKeys: String, CodingKey {
                case nickname
                case imgURL = "imgUrl"
                case account, isAgreeMarketing
            }
        }

        public struct Account: Codable {
            public let bank, number, holder: String
            public let userID: Int

            enum CodingKeys: String, CodingKey {
                case bank, number, holder
                case userID = "userId"
            }
        }
    }
}
