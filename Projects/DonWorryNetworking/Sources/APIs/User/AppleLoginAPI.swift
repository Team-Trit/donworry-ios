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
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
    public var path: String { return "/login/apple" }
    public var method: Method = .post
    public var task: Task {
        .requestPlain
    }
    public var headers: [String : String]? { return ["Authorization-APPLE": "Bearer \(identityToken)"] }
    private let identityToken: String
}
