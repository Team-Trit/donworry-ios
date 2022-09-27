//
//  PostPaymentCardImageDTO.swift
//  DonWorryNetworking
//
//  Created by Chanhee Jeong on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
extension DTO {
    public struct PostPaymentCardImage: Codable {
        
        public let id, spaceID, categoryID, takerID: Int
        public let name: String
        public let totalAmount: Int
        public let bgColor, paymentDate: String
        public let account: Account?
        public let imgUrls: [String]

        public enum CodingKeys: String, CodingKey {
            case id
            case spaceID = "spaceId"
            case categoryID = "categoryId"
            case takerID = "takerId"
            case name, totalAmount, bgColor, paymentDate, account, imgUrls
        }
        
        public struct Account: Codable {
            public let bank, number, holder: String?
            public let userID: Int

            public enum CodingKeys: String, CodingKey {
                case bank, number, holder
                case userID = "userId"
            }
        }
        
        
    }
}
