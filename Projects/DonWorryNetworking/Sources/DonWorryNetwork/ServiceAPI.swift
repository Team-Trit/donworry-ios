//
//  Networking.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public protocol ServiceAPI: TargetType, AccessTokenAuthorizable {
    associatedtype Response: Decodable

    var task: Task { get }

}

public extension ServiceAPI {
    var baseURL: URL { return URL(string: "http://ec2-13-125-121-230.ap-northeast-2.compute.amazonaws.com")! }
    var headers: [String : String]? { nil }
    var task: Task { task }
    var sampleData: Data { Data() }
    var authorizationType: AuthorizationType? { .bearer }
}
