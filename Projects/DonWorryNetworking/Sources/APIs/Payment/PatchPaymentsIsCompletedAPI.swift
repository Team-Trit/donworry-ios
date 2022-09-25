//
//  PatchPaymentsIsCompletedAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct PatchPaymentsIsCompletedAPI: ServiceAPI {
    public typealias Response = DTO.PatchPaymentsIsCompleted
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/payments/giver/isCompleted" }
    public var method: Method = .patch
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PatchPaymentsIsCompletedAPI {
    public struct Request: Encodable {
        public let paymentId: Int

        public init(paymentId: Int) {
            self.paymentId = paymentId
        }
    }
}
