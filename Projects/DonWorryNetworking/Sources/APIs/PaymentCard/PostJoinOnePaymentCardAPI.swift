//
//  PostJoinOnePaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PostJoinOnePaymentCardAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public var cardID: Int
    public init(cardID: Int) {
        self.cardID = cardID
    }
    public var path: String { "/cards/\(cardID)/join" }
    public var method: Method { .post }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
