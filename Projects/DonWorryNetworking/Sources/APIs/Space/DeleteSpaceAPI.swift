//
//  DeleteSpaceAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct DeleteSpaceAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public var spaceId: Int
    public var path: String { return "/spaces/\(spaceId)" }
    public var method: Method { .delete }
    public var task: Task { .requestPlain }

    public init(spaceId: Int) {
        self.spaceId = spaceId
    }

}
