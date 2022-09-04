//
//  GetCategoriesAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetCategoriesAPI: ServiceAPI {
    public typealias Response = DTO.Category.List
    public init() {}
    public var path: String { "/categories" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
