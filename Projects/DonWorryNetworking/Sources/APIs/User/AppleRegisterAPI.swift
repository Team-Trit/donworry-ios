//
//  AppleRegisterAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct AppleRegisterAPI: ServiceAPI {
    public typealias Response = DTO.PostUser
    public var request: Request
    public init(request: Request, identityToken: String, fcmToken: String) {
        self.request = request
        self.fcmToken = fcmToken
        self.identityToken = identityToken
    }
    public var path: String { return "/register/user/apple" }
    public var method: Method = .post
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        ["Authorization-APPLE": "Bearer \(identityToken)",
         "DeviceToken": "\(fcmToken)"]
    }
    private let identityToken: String
    private let fcmToken: String
}

extension AppleRegisterAPI {
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
