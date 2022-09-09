//
//  PatchUserAPI.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import Moya

public struct PatchUserAPI: ServiceAPI {
    public typealias Response = DTO.PatchUser
    public var request: Request
    public init(request: Request) {
        self.request = request
    }
    public var path: String { return "/user" }
    public var method: Method = .patch
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
}

extension PatchUserAPI {
    public struct Request: Encodable {
        public let nickname: String?
        public let imgUrl: String?
        public let account: Account?
        public let isAgreeMarketing: Bool?
        
        public struct Account: Codable {
            public let id: Int?
            public let bank, number, holder: String?
            public let userId: Int?
        }
        
        public init() {
            self.nickname = nil
            self.imgUrl = nil
            self.account = nil
            self.isAgreeMarketing = nil
        }
        public init(nickname: String) {
            self.nickname = nickname
            self.imgUrl = nil
            self.account = nil
            self.isAgreeMarketing = nil
        }
        public init(imgUrl: String) {
            self.imgUrl = imgUrl
            self.nickname = nil
            self.account = nil
            self.isAgreeMarketing = nil
        }
        public init(bank: String, number: String, holder: String) {
            let account = Account(id: nil, bank: bank, number: number, holder: holder, userId: nil)
            self.account = account
            self.nickname = nil
            self.imgUrl = nil
            self.isAgreeMarketing = nil
        }
        public init(isAgreeMarketing: Bool) {
            self.isAgreeMarketing = isAgreeMarketing
            self.nickname = nil
            self.imgUrl = nil
            self.account = nil
        }
    }
}
