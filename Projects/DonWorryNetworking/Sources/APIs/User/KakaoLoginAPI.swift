//
//  KakaoLoginAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct KakaoLoginAPI: ServiceAPI {
    public typealias Response = DTO.PostUser
    public init(accessToken: String, fcmToken: String) {
        self.accessToken = accessToken
        self.fcmToken = fcmToken
    }
    public var path: String { return "/login/kakao" }
    public var method: Method = .post
    public var task: Task {
        .requestPlain
    }
    public var headers: [String : String]? {
        ["Authorization-KAKAO": "Bearer \(accessToken)",
         "DeviceToken": "\(fcmToken)"]
    }
    private let accessToken: String
    private let fcmToken: String
}
