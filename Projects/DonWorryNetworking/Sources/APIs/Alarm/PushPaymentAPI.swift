//
//  PushPaymentAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PushPaymentAPI: ServiceAPI {

    public typealias Response = DTO.Empty
    public var path: String = "/alarms/payment/push"
    public var method: Method { .post }
    public var request: Request
    public var task: Task { .requestJSONEncodable(request) }
    public init(request: Request) {
        self.request = request
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PushPaymentAPI {
    public struct Request: Encodable {
        public let spaceID: Int
        public let payments: [Payment]
        public init(spaceID: Int, payments: [Payment]) {
            self.spaceID = spaceID
            self.payments = payments
        }

        public struct Payment: Encodable {
            public let id: Int
            public let receiverID: Int
            public let isCompleted: Bool
            public init(id: Int, receiverID: Int, isCompleted: Bool) {
                self.id = id
                self.receiverID = receiverID
                self.isCompleted = isCompleted
            }
        }
    }

}
