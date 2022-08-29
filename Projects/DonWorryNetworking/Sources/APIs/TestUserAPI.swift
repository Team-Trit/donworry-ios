//
//  TestUserAPI.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct TestUserAPI: ServiceAPI {
    public typealias Response = DTO.TestUser
    public var userID: Int

    public init(userID: Int) {
        self.userID = userID
    }

    public var path: String {
        return "/test/user/\(userID)"
    }
    public var method: Method = .get
    public var task: Task { .requestPlain }
}
