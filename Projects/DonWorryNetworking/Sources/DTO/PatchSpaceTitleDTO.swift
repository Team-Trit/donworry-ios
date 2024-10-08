//
//  PatchSpaceTitleDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct PatchSpaceTitle: Codable {
        public let id, adminID: Int
        public let title, shareID: String

        public enum CodingKeys: String, CodingKey {
            case id
            case adminID = "adminId"
            case title
            case shareID = "shareId"
        }
    }
}
