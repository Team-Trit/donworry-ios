//
//  GetAlarmsDTO.swift
//  DonWorryNetworking
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    
    // 네트워킹단이기때문에 public -> 나중에 도메인에서도 써야하기 때문에
    // enum을 제외한 나머지 변수들은 전부다 public으로
    public struct GetAlarmsDTO: Codable {
        
        public let id, senderID, receiverID: Int
        public let type, title, message: String
        public let data: DataClass
        public let isRead: Bool
        public let createdDate: String

        enum CodingKeys: String, CodingKey {
            case id
            case senderID = "senderId"
            case receiverID = "receiverId"
            case type, title, message, data, isRead, createdDate
        }


        public struct DataClass: Codable {
            public let additionalProp1, additionalProp2, additionalProp3: AdditionalProp
        }


        public struct AdditionalProp: Codable {
        }
        
        // typealias는 지워도 괜찮음
        // typealias getAlertDTO = [GetAlertsDTO]
        
    }
    
}

// quicktype에서 가져온 복사본(from swagger)

//// MARK: - WelcomeElement
//struct WelcomeElement: Codable {
//    let id, senderID, receiverID: Int
//    let type, title, message: String
//    let data: DataClass
//    let isRead: Bool
//    let createdDate: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case senderID = "senderId"
//        case receiverID = "receiverId"
//        case type, title, message, data, isRead, createdDate
//    }
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let additionalProp1, additionalProp2, additionalProp3: AdditionalProp
//}
//
//// MARK: - AdditionalProp
//struct AdditionalProp: Codable {
//}
//
//typealias Welcome = [WelcomeElement]



