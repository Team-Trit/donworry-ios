//
//  DeleteSpaceLeaveAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct DeleteSpaceLeaveAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public var spaceId: Int
    public var path: String { return "/spaces/users/\(spaceId)" }
    public var method: Method { .delete }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    public init(spaceId: Int) {
        self.spaceId = spaceId
    }

}
