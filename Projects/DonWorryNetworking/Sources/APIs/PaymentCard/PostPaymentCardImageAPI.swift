//
//  PostPaymentCardImageAPI.swift
//  DonWorryNetworking
//
//  Created by Chanhee Jeong on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

public struct PostPaymentCardImageAPI: ServiceAPI {
    
    public typealias Response = DTO.PostPaymentCardImage
    public var cardId: Int
    public var request: String
    public var path: String { return "/cards/images\(cardId)" }
    public var method: Method { .post }
    public var task: Task {
        .requestJSONEncodable(request)
    }
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    
    public init(cardId: Int, request: String) {
        self.cardId = cardId
        self.request = request
    }

}
