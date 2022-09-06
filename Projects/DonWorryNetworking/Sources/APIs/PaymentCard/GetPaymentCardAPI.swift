//
//  GetPaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Hankyu Lee on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct GetPaymentCardAPI: ServiceAPI {
    public typealias Response = DTO.GetPaymentCard
    public var cardId: Int
    public init(cardId: Int) {
        self.cardId = cardId
    }
    public var path: String { "/cards/\(cardId)" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}


