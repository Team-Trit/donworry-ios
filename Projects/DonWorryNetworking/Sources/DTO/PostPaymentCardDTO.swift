//
//  PaymentCard.swift
//  DonWorryNetworking
//
//  Created by Chanhee Jeong on 2022/09/01.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PostPaymentCard: Codable {
        public let id, spaceID, takerID: Int
        public let name: String
        public let totalAmount: Int
        public let bgColor, paymentDate: String
        public let category: Category
        public let account: Account?

        public enum CodingKeys: String, CodingKey {
            case id
            case spaceID = "spaceId"
            case takerID = "takerId"
            case name, totalAmount, bgColor, paymentDate, category, account
        }
        
        public struct Category: Codable {
            public let id: Int
            public let name, imgURL: String

            public enum CodingKeys: String, CodingKey {
                case id, name
                case imgURL = "imgUrl"
            }
        }
        
        public struct Account: Codable {
            public let bank, number, holder: String?
            public let userID: Int?

            public enum CodingKeys: String, CodingKey {
                case bank, number, holder
                case userID = "userId"
            }
        }
        
    }

}

