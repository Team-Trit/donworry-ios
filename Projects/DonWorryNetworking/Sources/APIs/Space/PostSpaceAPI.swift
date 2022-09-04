//
//  PostSpaceAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PostSpaceAPI: ServiceAPI {
    public typealias Response = DTO.PostSpace
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/spaces/users" }
    public var method: Method = .post
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PostSpaceAPI {
    public struct Request: Encodable {
        public var title: String
        public init(title: String) {
            self.title = title
        }
    }
}
