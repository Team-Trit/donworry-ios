//
//  PostSpaceDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PostSpace: Codable {
        public let id, adminID: Int
        public let title, status, shareID: String

        public enum CodingKeys: String, CodingKey {
            case id
            case adminID = "adminId"
            case title, status
            case shareID = "shareId"
        }
    }
}
