//
//  PutEditPaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Hankyu Lee on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

public struct PutEditPaymentCardAPI: ServiceAPI {
    public typealias Response = DTO.PutEditPaymentCard.PaymentCard
    public var request: Request
    public var path: String { "/cards" }
    public var method: Method { .put }
    public var task: Task { .requestJSONEncodable(request) }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    public init(request: Request) {
        self.request = request
    }
}

extension PutEditPaymentCardAPI {

    public struct Request: Codable {
        public let id: Int
        public let totalAmount: Int
        
        public init(
            id: Int,
            totalAmount: Int
        ) {
            self.id = id
            self.totalAmount = totalAmount
        }
    }
}
