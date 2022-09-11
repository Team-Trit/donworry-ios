//
//  RemoveAlarmsAPI.swift
//  DonWorryNetworking
//
//  Created by uiskim on 2022/09/11.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct RemoveAlarmsAPI: ServiceAPI {
    public typealias Response = DTO.Empty
    public init() {}
    public var path: String { "/alarms/clear" }
    public var method: Method { .patch }
    public var task: Task { .requestPlain }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }

}
