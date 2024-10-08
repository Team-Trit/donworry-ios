//
//  GetSpaceListAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetSpaceListAPI: ServiceAPI {
    public typealias Response = [DTO.Space]
    public init() {}
    public var path: String { "/spaces/users" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}
