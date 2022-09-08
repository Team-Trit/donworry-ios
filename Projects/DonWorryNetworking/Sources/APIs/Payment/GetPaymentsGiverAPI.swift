//
//  GetPaymentsTakerAPI.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetPaymentsGiverAPI: ServiceAPI {
    public typealias Response = DTO.GetPaymentsGiver
    public var spaceID: Int
    public var paymentID: Int
    public init(spaceID: Int, paymentID: Int) {
        self.spaceID = spaceID
        self.paymentID = paymentID
    }
    public var path: String { "/payments/giver/\(spaceID)/\(paymentID)" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
