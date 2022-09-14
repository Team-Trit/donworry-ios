//
//  GetAlarmsDTO.swift
//  DonWorryNetworking
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct GetAlarmsDTO: Codable {
        public let id, senderID, receiverID: Int
        public let type, title, message: String
        public let createdDate: String

        enum CodingKeys: String, CodingKey {
            case id
            case senderID = "senderId"
            case receiverID = "receiverId"
            case type, title, message, createdDate
        }
    }
    
}
