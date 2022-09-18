//
//  AppleLoginAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct AppleLoginAPI: ServiceAPI {
    public typealias Response = DTO.PostUser
    public init(identityToken: String, fcmToken: String) {
        self.identityToken = identityToken
        self.fcmToken = fcmToken
    }
    public var path: String { return "/login/apple" }
    public var method: Method = .post
    public var task: Task {
        .requestPlain
    }
    public var headers: [String : String]? {
        ["Authorization-APPLE": "Bearer \(identityToken)",
         "DeviceToken": "\(fcmToken)"]
    }
    private let identityToken: String
    private let fcmToken: String
}
