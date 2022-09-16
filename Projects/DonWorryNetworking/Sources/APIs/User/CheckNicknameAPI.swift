//
//  CheckNicknameAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct CheckNicknameAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    private let nickname: String
    public init(nickname: String) {
        self.nickname = nickname
    }
    public var path: String { return "/register/validate/nickname" }
    public var method: Method = .get
    public var task: Task {
        .requestParameters(parameters: ["nickname" : nickname], encoding: URLEncoding.queryString)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    
}

extension CheckNicknameAPI {
    public struct Request: Encodable {
        public let nickname: String
        
        public init(nickname: String) {
            self.nickname = nickname
        }
    }
}
