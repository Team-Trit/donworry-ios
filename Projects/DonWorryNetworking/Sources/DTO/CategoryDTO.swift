//
//  CategoryDTO.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct Category: Codable {
        public var id: Int
        public var name: String
        public var imgUrl: String

        public typealias List = [Category]
    }
}
