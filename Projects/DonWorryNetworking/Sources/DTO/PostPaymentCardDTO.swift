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
        public let id, spaceID, categoryID, takerID: Int
        public let bank, number, holder, name: String
        public let totalAmount: Int
        public let status: PaymentCardStatus
        public let position: Int
        public let bgColor, paymentDate: String

        public enum CodingKeys: String, CodingKey {
            case id
            case spaceID = "spaceId"
            case categoryID = "categoryId"
            case takerID = "takerId"
            case bank, number, holder, name, totalAmount, position, bgColor, paymentDate, status
        }
        
        public enum PaymentCardStatus: Codable {
            case OPEN
            case PROGRESS
            case CLOSE
            case DELETE
            case STOP
        }
    }

}

