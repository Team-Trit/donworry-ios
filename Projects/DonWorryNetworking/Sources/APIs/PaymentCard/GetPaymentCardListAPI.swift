//
//  PaymentCardListAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetPaymentCardListAPI: ServiceAPI {
    public typealias Response = DTO.GetPaymentCardList
    public var spaceID: Int
    public init(spaceID: Int) {
        self.spaceID = spaceID
    }
    public var path: String { "/cards/spaces/\(spaceID)" }
    public var method: Method { .get }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
