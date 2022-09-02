//
//  DeletePaymentCardListAPI.swift
//  DonWorryNetworking
//
//  Created by Chanhee Jeong on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

// query = userId
public struct DeletePaymentCardAPI: ServiceAPI {
    
    public typealias Response = DTO.Empty
    public var cardId: Int
    public var path: String { return "/cards/\(cardId)" }
    public var method: Method { .delete }
    public var task: Task { .requestPlain }
    
    public init(cardId: Int) {
        self.cardId = cardId
    }
    
}
