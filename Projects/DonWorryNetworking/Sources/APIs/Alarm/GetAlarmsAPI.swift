//
//  GetAlarmsAPI.swift
//  DonWorryNetworking
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct GetAlarmsAPI: ServiceAPI {
    
    public typealias Response = [DTO.GetAlarmsDTO]
    public var path: String = "/alarms"
    public var method: Method { .get }
    public var task: Task { .requestPlain }

    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    public init() {}
}
