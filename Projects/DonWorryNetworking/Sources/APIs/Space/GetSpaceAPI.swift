//
//  GetSpaceAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetSpaceAPI: ServiceAPI {
    public typealias Response = DTO.Space
    public init(spaceID: Int) {
        self.spaceID = spaceID
    }
    public var spaceID: Int
    public var path: String {
        "/spaces/users/\(spaceID)"
    }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}
