//
//  PaymentRoomDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PaymentRoom: Decodable {
        let id, adminID: Int
        let title, status, shareID: String
        let cards: [Card]

        enum CodingKeys: String, CodingKey {
            case id
            case adminID = "adminId"
            case title, status
            case shareID = "shareId"
            case cards
        }

        struct Card: Decodable {
            let id: Int
            let isTaker: Bool
            let payments: [Payment]
        }

        // MARK: - Payment
        struct Payment: Decodable {
            let id, amount: Int
            let isCompleted: Bool
            let user: User
        }

        // MARK: - User
        struct User: Decodable {
            let id: Int
            let nickname, imgURL: String

            enum CodingKeys: String, CodingKey {
                case id, nickname
                case imgURL = "imgUrl"
            }
        }

    }
}

