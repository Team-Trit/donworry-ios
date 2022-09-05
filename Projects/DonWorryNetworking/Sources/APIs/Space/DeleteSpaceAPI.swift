//
//  DeleteSpaceAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct DeleteSpaceAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public var spaceID: Int
    public var path: String { return "/spaces/\(spaceID)" }
    public var method: Method { .delete }
    public var task: Task { .requestPlain }

    public init(spaceID: Int) {
        self.spaceID = spaceID
    }
}
