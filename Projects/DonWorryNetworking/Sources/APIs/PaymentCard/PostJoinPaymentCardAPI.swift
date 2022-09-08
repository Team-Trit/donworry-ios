//
//  PostJoinPaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Hankyu Lee on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

public struct PostJoinPaymentCardAPI: ServiceAPI {
    
    public typealias Response = DTO.Empty
    public var request: Request
    public var path: String = "/cards/join"
    public var method: Method { .post }
    public var task: Task {
        .requestJSONEncodable(request)
    }
    
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    
    public init(request: Request) {
        self.request = request
    }
}

extension PostJoinPaymentCardAPI {

    public struct Request: Encodable {
        public let cardIds: [Int]
        public init(cardIds: [Int]) {
            self.cardIds = cardIds
        }
    }
}
