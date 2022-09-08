//
//  GetPaymentsTakerAPI.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetPaymentsTakerAPI: ServiceAPI {
    public typealias Response = DTO.GetPaymentsTaker
    public var spaceID: Int
    public init(spaceID: Int) {
        self.spaceID = spaceID
    }
    public var path: String { "/payments/taker/\(spaceID)" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
