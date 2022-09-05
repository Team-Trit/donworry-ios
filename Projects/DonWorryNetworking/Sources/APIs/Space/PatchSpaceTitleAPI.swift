//
//  PatchSpaceTitleAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PatchSpaceTitleAPI: ServiceAPI {
    public typealias Response = DTO.PatchSpaceTitle
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/spaces/title" }
    public var method: Method = .patch
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PatchSpaceTitleAPI {
    public struct Request: Encodable {
        public var id: Int
        public var title: String
        public init(
            id: Int,
            title: String
        ) {
            self.id = id
            self.title = title
        }
    }
}
