//
//  PostSapceJoinAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PostSpaceJoinAPI: ServiceAPI {
    public typealias Response = DTO.PostSpaceJoin
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/spaces/join" }
    public var method: Method = .post
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PostSpaceJoinAPI {
    public struct Request: Encodable {
        public var shareId: String
        public init(shareId: String) {
            self.shareId = shareId
        }
    }
}
