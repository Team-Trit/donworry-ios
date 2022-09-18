//
//  DeregisterAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct DeregisterAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
    public var path: String { return "/deregister" }
    public var method: Method = .delete
    public var headers: [String : String]? {
        ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    public var task: Task { .requestPlain }
    private let authorizationCode: String
}
