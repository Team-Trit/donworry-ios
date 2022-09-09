//
//  PatchSpaceStatusAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PatchSpaceStatusAPI: ServiceAPI {
    public typealias Response = DTO.PostSpace
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/spaces/status" }
    public var method: Method = .patch
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PatchSpaceStatusAPI {
    public struct Request: Encodable {
        public var id: Int
        public var status: String
        public init(
            id: Int,
            status: String
        ) {
            self.id = id
            self.status = status
        }
    }
}
