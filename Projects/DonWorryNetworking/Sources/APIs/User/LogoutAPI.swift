//
//  LogoutAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct LogoutAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public var path: String { return "/logout" }
    public var method: Method = .get
    public var task: Task {
        .requestPlain
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    public init() {}
}
