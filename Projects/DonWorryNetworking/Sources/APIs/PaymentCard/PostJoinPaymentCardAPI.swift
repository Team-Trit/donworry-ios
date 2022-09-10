//
//  PostJoinPaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Hankyu Lee on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PostJoinPaymentCardAPI: ServiceAPI {
    public typealias Response = DTO.PostJoinPaymentCard
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/cards/join" }
    public var method: Method = .post
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PostJoinPaymentCardAPI {
    public struct Request: Encodable {
        public let cardIds: [Int64]
        public init(cardIds: [Int64]) {
            self.cardIds = cardIds
        }
    }
}

