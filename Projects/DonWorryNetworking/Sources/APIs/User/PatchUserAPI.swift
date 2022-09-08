//
//  PatchUserAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct PatchUserAPI: ServiceAPI {
    public typealias Response = DTO.PatchUser
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/user" }
    public var method: Method = .patch
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PatchUserAPI {
    public struct Request: Encodable {
        public var userUpdateCommand: UserUpdateCommand
        public var user: PatchAPIUser
        
        public init(
            nickname: String?,
            imgURL: String?,
            bank: String?,
            number: String?,
            holder: String?,
            userID: Int?,
            isAgreeMarketing: Bool?,
            id: Int?,
            innerUserNickname: String?,
            email: String?,
            innerUserIsAgreeMarketing: Bool?,
            provider: String?,
            providerID: String?,
            role: String?,
            password: String?,
            username: String?,
            authorities: [Authority]?,
            accountNonExpired: Bool?,
            accountNonLocked: Bool?,
            credentialsNonExpired: Bool?,
            enabled: Bool?
        ) {
            self.userUpdateCommand = UserUpdateCommand(nickname: nickname,
                                                       imgURL: imgURL,
                                                       account: Account(bank: bank,
                                                                        number: number,
                                                                        holder: holder,
                                                                        userID: userID),
                                                       isAgreeMarketing: isAgreeMarketing)
            
            self.user = PatchAPIUser(user: InnerUser(id: id,
                                                     nickname: innerUserNickname,
                                                     email: email,
                                                     isAgreeMarketing: innerUserIsAgreeMarketing,
                                                     provider: provider,
                                                     providerID: providerID,
                                                     role: role),
                                     password: password,
                                     username: username,
                                     authorities: authorities,
                                     accountNonExpired: accountNonExpired,
                                     accountNonLocked: accountNonLocked,
                                     credentialsNonExpired: credentialsNonExpired,
                                     enabled: enabled)
        }
    }
    public struct PatchAPIUser: Codable {
        let user: InnerUser?
        let password, username: String?
        let authorities: [Authority]?
        let accountNonExpired, accountNonLocked, credentialsNonExpired, enabled: Bool?
    }

    public struct Authority: Codable {
        let authority: String?
    }

    public struct InnerUser: Codable {
        let id: Int?
        let nickname, email: String?
        let isAgreeMarketing: Bool?
        let provider, providerID, role: String?

        enum CodingKeys: String, CodingKey {
            case id, nickname, email, isAgreeMarketing, provider
            case providerID = "providerId"
            case role
        }
    }

    public struct UserUpdateCommand: Codable {
        let nickname, imgURL: String?
        let account: Account?
        let isAgreeMarketing: Bool?

        enum CodingKeys: String, CodingKey {
            case nickname
            case imgURL = "imgUrl"
            case account, isAgreeMarketing
        }
    }

    public struct Account: Codable {
        let bank, number, holder: String?
        let userID: Int?

        enum CodingKeys: String, CodingKey {
            case bank, number, holder
            case userID = "userId"
        }
    }
}
