//
//  PaymentRoomAPI.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct PaymentRoomAPI: ServiceAPI {
    public var path: String = ""
    public var method: Method { .get }
    public var task: Task { .requestPlain }

    public init() {}
}

extension PaymentRoomAPI {
    public struct Response: Decodable {
        public let list: [DTO.PaymentRoom]?
    }
}
