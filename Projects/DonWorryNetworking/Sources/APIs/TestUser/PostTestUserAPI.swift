//
//  PostTestUserAPI.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PostTestUserAPI: ServiceAPI {
    public typealias Response = DTO.TestUser
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/test/user/save" }
    public var method: Method = .get
    public var task: Task {
        .requestParameters(parameters: request.dicationary, encoding: URLEncoding.default)
    }
}

extension PostTestUserAPI {
    public struct Request: Encodable {
        var provider: String
        var nickname: String
        var email: String
        var bank: String
        var bankNumber: String
        var bankHolder: String
        var isAgreeMarketing: Bool
    }
}
