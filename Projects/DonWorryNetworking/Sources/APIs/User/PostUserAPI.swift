//
//  PostUserAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct PostUserAPI: ServiceAPI {
    public typealias Response = DTO.PostUser
    public var request: Request
    public init(request: Request, accessToken: String) {
        self.request = request
        self.accessToken = accessToken
    }
    public var path: String { return "/register/user/kakao" }
    public var method: Method = .post
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? { return ["Authorization-KAKAO": "Bearer \(accessToken)"] }
    private let accessToken: String
}

extension PostUserAPI {
    public struct Request: Encodable {
        public var provider: String
        public var nickname: String
        public var email: String
        public var bank: String
        public var bankNumber: String
        public var bankHolder: String
        public var isAgreeMarketing: Bool

        public init(
            provider: String,
            nickname: String,
            email: String,
            bank: String,
            bankNumber: String,
            bankHolder: String,
            isAgreeMarketing: Bool
        ) {
            self.provider = provider
            self.nickname = nickname
            self.email = email
            self.bank = bank
            self.bankNumber = bankNumber
            self.bankHolder = bankHolder
            self.isAgreeMarketing = isAgreeMarketing
        }
    }
}
