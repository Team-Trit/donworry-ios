//
//  UploadImageAPI.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

public struct UploadImageAPI: ServiceAPI {
    public typealias Response = DTO.UploadImage
    public var request: Request
    public var type: String
    public init(type: String, request: Request) {
        self.type = type
        self.request = request
    }
    public var path: String = "/s3/single"
    public var method: Method { .post }
    public var task: Task { .requestCompositeData(bodyData: request.imageData, urlParameters: ["type": type]) }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
                "Content-Type": "image/jpeg",]
    }
}

extension UploadImageAPI {
    public struct Request {
        public let imageData: Data
        public init(imageData: Data) {
            self.imageData = imageData
        }
    }
}
