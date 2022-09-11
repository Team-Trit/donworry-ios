//
//  PutEditPaymentCardDTO.swift
//  DonWorryNetworking
//
//  Created by Hankyu Lee on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PutEditPaymentCard: Codable {
        public let card: PaymentCard
        public struct PaymentCard: Codable {
            public let id: Int
            public let totalAmount: Int
            public let name: String
        }
    }
}
