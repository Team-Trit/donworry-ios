//
//  PostPaymentCardAPI.swift
//  DonWorryNetworking
//
//  Created by Chanhee Jeong on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

public struct PostPaymentCardAPI: ServiceAPI {
    
    public typealias Response = DTO.PostPaymentCard
    public var request: Request
    public var path: String = "/cards"
    public var method: Method { .post }
    public var task: Task {
        .requestJSONEncodable(request)
    }
    
    public init(request: Request) {
        self.request = request
    }
}


extension PostPaymentCardAPI {

    public struct Request: Encodable {
        public let spaceID, categoryID: Int
        public let bank, number, holder, name: String
        public let totalAmount, position: Int
        public let bgColor, paymentDate: String

        enum CodingKeys: String, CodingKey {
            case spaceID = "spaceId"
            case categoryID = "categoryId"
            case bank, number, holder, name, totalAmount, position, bgColor, paymentDate
        }
        
        
        public init(
            spaceID: Int,
            categoryID: Int,
            bank: String,
            number: String,
            holder: String,
            name: String,
            totalAmount: Int,
            position: Int,
            bgColor: String,
            paymentDate: String
        ) {
            self.spaceID = spaceID
            self.categoryID = categoryID
            self.bank = bank
            self.number = number
            self.holder = holder
            self.name = name
            self.totalAmount = totalAmount
            self.position = position
            self.bgColor = bgColor
            self.paymentDate = paymentDate
        }
        
        
    }
}
